// SPDX-FileCopyrightText: Copyright 2020 yuzu Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#pragma once

#include <atomic>
#include <condition_variable>
#include <thread>
#include <queue>
#include "common/types.h"
#include "video_core/renderer_vulkan/vk_common.h"

namespace Vulkan {

class Instance;
class Scheduler;

class MasterSemaphore {
public:
    explicit MasterSemaphore(const Instance& instance_);
    ~MasterSemaphore();

    [[nodiscard]] u64 CurrentTick() const noexcept {
        return current_tick.load(std::memory_order_acquire);
    }

    [[nodiscard]] u64 KnownGpuTick() const noexcept {
        return gpu_tick.load(std::memory_order_acquire);
    }

    [[nodiscard]] bool IsFree(u64 tick) const noexcept {
        return KnownGpuTick() >= tick;
    }

    /// True once a semaphore query has reported the device lost, so a tick read after that point
    /// says nothing about GPU progress and must not be treated as a lifetime guarantee.
    [[nodiscard]] bool HasDeviceLost() const noexcept {
        return device_lost.load(std::memory_order_acquire);
    }

    /// True once the driver answered with a tick the GPU could not possibly have reached. Diagnostic
    /// only - the value is refused, so the timeline itself stays correct.
    [[nodiscard]] bool HasSeenBogusTick() const noexcept {
        return bogus_tick_seen.load(std::memory_order_acquire);
    }

    [[nodiscard]] u64 NextTick() noexcept {
        return current_tick.fetch_add(1, std::memory_order_release);
    }

    [[nodiscard]] vk::Semaphore Handle() const noexcept {
        return semaphore.get();
    }

    /// Refresh the known GPU tick
    void Refresh();

    /// Waits for a tick to be hit on the GPU
    void Wait(u64 tick);

protected:
    const Instance& instance;
    vk::UniqueSemaphore semaphore;    ///< Timeline semaphore.
    std::atomic<u64> gpu_tick{0};     ///< Current known GPU tick.
    std::atomic<u64> current_tick{1}; ///< Current logical tick.
    std::atomic<bool> device_lost{false};     ///< Set when a query reported the device lost.
    std::atomic<bool> bogus_tick_seen{false}; ///< Set when a refused impossible tick was seen.
};

} // namespace Vulkan
