// SPDX-FileCopyrightText: Copyright 2020 yuzu Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#include <limits>
#include "video_core/renderer_vulkan/vk_instance.h"
#include "video_core/renderer_vulkan/vk_master_semaphore.h"

#include "common/assert.h"

namespace Vulkan {

constexpr u64 WAIT_TIMEOUT = std::numeric_limits<u64>::max();

MasterSemaphore::MasterSemaphore(const Instance& instance_) : instance{instance_} {
    const vk::StructureChain semaphore_chain = {
        vk::SemaphoreCreateInfo{},
        vk::SemaphoreTypeCreateInfo{
            .semaphoreType = vk::SemaphoreType::eTimeline,
            .initialValue = 0,
        },
    };
    auto [semaphore_result, sem] =
        instance.GetDevice().createSemaphoreUnique(semaphore_chain.get());
    ASSERT_MSG(semaphore_result == vk::Result::eSuccess, "Failed to create master semaphore: {}",
               vk::to_string(semaphore_result));
    semaphore = std::move(sem);
}

MasterSemaphore::~MasterSemaphore() = default;

void MasterSemaphore::Refresh() {
    u64 this_tick{};
    u64 counter{};
    do {
        this_tick = gpu_tick.load(std::memory_order_acquire);
        auto [counter_result, cntr] = instance.GetDevice().getSemaphoreCounterValue(*semaphore);
        if (counter_result != vk::Result::eSuccess) {
            // MEASURED: on failure vulkan-hpp hands back the uninitialised out-parameter, and the
            // CAS below only ever moves gpu_tick FORWARD - so one failed query used to latch garbage
            // (observed as 0xFFFFFFFFFFFFFFFF) into the tick for the rest of the process. That makes
            // IsFree() true for every tick, i.e. every deferred deletion fires immediately.
            // assert_fail_impl() runs Emulator::Shutdown() BEFORE it traps, and that shutdown
            // flushes the pending-operation queues - so this path must not have poisoned the gate
            // those flushes are about to consult.
            if (counter_result == vk::Result::eErrorDeviceLost) {
                // Refresh is reached from PopPendingOperations, IsFree and SubmitExecution, so it is
                // a very likely FIRST witness of the loss - and it used to assert without ever
                // asking the driver, swallowing the fault records and the work journal entirely.
                device_lost.store(true, std::memory_order_release);
                instance.LogDeviceFaultInfo();
            }
            ASSERT_MSG(counter_result == vk::Result::eSuccess,
                       "Failed to get master semaphore value: {}", vk::to_string(counter_result));
            return;
        }
        counter = cntr;

        // ⚠⚠⚠ THE GPU CANNOT BE AHEAD OF WHAT WAS SUBMITTED TO IT. current_tick is the tick of the
        // command buffer still being recorded, so the highest value the timeline can legitimately
        // hold is current_tick - 1. Anything above that is a driver answer we must not believe.
        //
        // MEASURED, and this is the whole bug: after the GPU hangs, this query returns eSuccess with
        // 0xFFFFFFFFFFFFFFFF. Because IsFree(tick) is `KnownGpuTick() >= tick`, that value satisfies
        // EVERY comparison, so the deferred-deletion gate opens completely: 24 of 24 buffers in the
        // graveyard were freed at one single defer_tick, with no device loss yet reported, while a
        // command buffer was still recording references to them. Destroying a resource a RECORDING
        // command buffer references invalidates that command buffer - and the rasterizer then wrote
        // 127 more commands into it (SetVertexInputEXT, BindVertexBuffers, BindPipeline, Dispatch,
        // DrawIndexed) which the driver executed as undefined behaviour. That is why the fault
        // records show instruction pointers with ZERO memory-access faults, why the signature moves
        // between runs, and why a validation or CDL layer hid it: both change the timing.
        //
        // The CAS below only moves gpu_tick FORWARD, so a single bogus answer is an absorbing state:
        // one is enough to disable the gate for the rest of the process.
        // Read current_tick AFTER the query, never before: a submit racing us only RAISES it, which
        // makes this test more permissive rather than wrongly rejecting a tick that just landed.
        const u64 logical_tick = current_tick.load(std::memory_order_acquire);
        if (counter >= logical_tick) {
            // Report once with everything needed to place it in time, then stay silent: Refresh is
            // called from PopPendingOperations, IsFree, CommitResource and every submit, so an
            // unthrottled message here buries the fault records under thousands of lines.
            if (!bogus_tick_seen.exchange(true, std::memory_order_acq_rel)) {
                LOG_ERROR(Render_Vulkan,
                          "Master semaphore reported GPU tick {} while only {} has been handed out, "
                          "and the last believed tick was {}. REFUSING it. Accepting such a value "
                          "makes KnownGpuTick() satisfy every comparison, which disables the whole "
                          "renderer's lifetime tracking at once: deferred buffer/image deletion, "
                          "command buffer recycling in ResourcePool::CommitResource, descriptor pool "
                          "reset, and StreamBuffer memory reuse. This message is printed once.",
                          counter, logical_tick, this_tick);
            }
            // ⚠ Deliberately NOT setting device_lost here. The value is refused and gpu_tick keeps
            // its last GOOD value, so a transient bad answer costs nothing and the next valid query
            // moves the timeline on as usual. Latching a permanent "lost" would instead force every
            // pool to grow for ever, turning a recoverable hiccup into an out-of-memory death.
            return;
        }
        if (counter < this_tick) {
            return;
        }
    } while (!gpu_tick.compare_exchange_weak(this_tick, counter, std::memory_order_release,
                                             std::memory_order_relaxed));
}

void MasterSemaphore::Wait(u64 tick) {
    // No need to wait if the GPU is ahead of the tick
    if (IsFree(tick)) {
        return;
    }
    // Update the GPU tick and try again
    Refresh();
    if (IsFree(tick)) {
        return;
    }

    // If none of the above is hit, fallback to a regular wait
    const vk::SemaphoreWaitInfo wait_info = {
        .semaphoreCount = 1,
        .pSemaphores = &semaphore.get(),
        .pValues = &tick,
    };

    // This loop used to be bare. On eErrorDeviceLost the wait fails instantly and for ever, so a
    // lost device turned into a silent infinite spin here instead of a crash - no fault records, no
    // journal, and nothing in the log to say what had happened.
    while (true) {
        const auto result = instance.GetDevice().waitSemaphores(&wait_info, WAIT_TIMEOUT);
        if (result == vk::Result::eSuccess) {
            break;
        }
        if (result == vk::Result::eErrorDeviceLost) {
            instance.LogDeviceFaultInfo();
            UNREACHABLE_MSG("Device lost while waiting on the master semaphore");
        }
    }
    Refresh();
}

} // namespace Vulkan
