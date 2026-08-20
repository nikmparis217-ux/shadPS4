// SPDX-FileCopyrightText: Copyright 2024 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#pragma once

#include <atomic>
#include <limits>
#include <mutex>
#include <span>
#include <unordered_map>

#include "video_core/renderer_vulkan/vk_platform.h"

#define TRACY_VK_USE_SYMBOL_TABLE
#include <tracy/TracyVulkan.hpp>

namespace Frontend {
class WindowSDL;
}

VK_DEFINE_HANDLE(VmaAllocator)

namespace Vulkan {

/// dim_x*y*z * threads_x*y*z reaches 2^96, so a plain multiply rolls over silently and a monstrous
/// dispatch reads as a small one. Saturating makes the overflow VISIBLE: a saturated estimate means
/// the group counts are garbage, which wants a different investigation from "this shader was given
/// too much work". Lives here because both the recorder and the reader must agree on it.
constexpr u64 GpuWorkSatMul(u64 a, u64 b) {
    if (a == 0 || b == 0) {
        return 0;
    }
    if (a > std::numeric_limits<u64>::max() / b) {
        return std::numeric_limits<u64>::max();
    }
    return a * b;
}

/// Saturating add, for the same reason as GpuWorkSatMul: a rolled-over total reads as a small one.
constexpr u64 GpuWorkSatAdd(u64 a, u64 b) {
    return (a > std::numeric_limits<u64>::max() - b) ? std::numeric_limits<u64>::max() : a + b;
}

/// What kind of work was handed to the GPU.
enum class GpuWorkKind : u8 {
    Draw,
    DrawIndexed,
    DrawIndirect,
    DrawIndexedIndirect,
    DispatchDirect,
    DispatchIndirect,
    /// ⚠⚠ THE JOURNAL'S BLIND SPOT, and it took six runs to matter. Everything above is recorded
    /// from vk_rasterizer, i.e. GUEST work. The emulator's OWN compute and fullscreen passes -
    /// tile_manager's detiler, FSR, post-process, blits and clears - went through the same queue and
    /// were never recorded at all, so the in-flight census could not name them however complete it
    /// claimed to be. That mattered because the census proved all 69 guest shaders in the hung
    /// command buffer are on disk and only six of them contain a loop, and every one of those six
    /// was capped in a run that still hung. A hang that is "one shader, one loop" and is none of
    /// those six has to be work the journal was not looking at - and tiling.comp does contain a
    /// `while` loop whose only bound is a uniform the host fills without clamping.
    HostDetile,
    HostTile,
    HostFsr,
    HostPostProcess,
    HostBlit,
};

/// How much the indirect argument numbers in a GpuWorkPayload can be trusted. An UNMARKED guess
/// reads as a fact, so every entry says where its numbers came from.
namespace GpuWorkFlag {
/// The guest argument buffer was mapped and the counts below were read out of it.
constexpr u8 IndirectArgsRead = 1 << 0;
/// The argument address was not mapped, so nothing could be read and the counts are unknown.
constexpr u8 IndirectArgsUnmapped = 1 << 1;
/// A shader wrote those arguments, which is the whole point of an indirect dispatch - so the host
/// view is STALE and the counts below are what the CPU last saw, NOT what the GPU used.
constexpr u8 IndirectArgsGpuModified = 1 << 2;
} // namespace GpuWorkFlag

/// One unit of work handed to the GPU. Deliberately plain data: no pointers to walk, no strings to
/// allocate, nothing that can dangle while a device is dying. `cmdbuf` is an opaque handle value
/// kept only so entries can be grouped per queue - it is never dereferenced.
struct GpuWorkPayload {
    GpuWorkKind kind{};
    u8 primary_stage{};   ///< Shader::Stage of the first stage (0=fs 1=vs 2=gs 3=es 4=hs 5=ls 6=cs)
    u8 secondary_stage{};
    u8 flags{};
    u32 lds_bytes{};
    u32 num_vgprs{};
    u64 primary_hash{};   ///< Shader::Info::pgm_hash, i.e. the name of the dumped .spv
    u64 secondary_hash{};
    u64 cmdbuf{};
    u64 guest_addr{};
    u32 groups[3]{};
    u32 threads_per_group[3]{};
    u32 count_a{};        ///< vertices, or max_count for an indirect draw
    u32 count_b{};        ///< instances, or the argument stride for an indirect draw
    u32 rt_width{};       ///< render target, draws only
    u32 rt_height{};
    u32 rt_layers{};
    /// ⚠ An UPPER BOUND on fragment invocations, never a measurement: it is the whole render area,
    /// while the real number depends on triangle coverage, scissor, depth test and early-Z. It
    /// exists because a fullscreen pass is 3 vertices and millions of pixels, so a vertex-only
    /// estimate is blind to exactly the work most likely to be heavy.
    u64 pixel_estimate{};
    /// The biggest dimension of this work: invocations for a dispatch, max(vertex, pixel) for a
    /// draw. SATURATED, see GpuWorkSatMul - a saturated value is itself a finding (garbage counts),
    /// which is a different bug from "a lot of work".
    u64 work_estimate{};
};

class MasterSemaphore;

/// Ticks captured from EVERY Scheduler's timeline at one instant.
///
/// ⚠⚠ MEASURED CAUSE of the destroy-while-in-use faults: BufferCache and TextureCache are bound to
/// `draw_scheduler` ALONE (vk_presenter.cpp:502), while the presenter records commands referring to
/// those same buffers and images on `present_scheduler` and `flip_scheduler` (vk_presenter.cpp:648,
/// :794, :901). Each Scheduler owns a SEPARATE timeline semaphore, so a tick from one says NOTHING
/// about the progress of another - and a lifetime gate that consults one of three is not a gate.
struct GpuTimelineSet {
    static constexpr u32 MaxTimelines = 4;
    u64 ticks[MaxTimelines]{};
    u32 count{};
};

/// One buffer destruction, recorded at the moment the erase ACTUALLY ran. Exists because the
/// validation layer reports "VkBuffer 0x... was destroyed" while a command buffer still referenced
/// it, and BufferCache::DeleteBuffer already defers behind a tick gate - so the gate is passing when
/// it should not, and these are the numbers that say why. `handle` is printed in the same form the
/// layer prints it, so the two logs can be joined by eye.
struct GpuBufferDeath {
    u64 handle{};
    u64 guest_addr{};
    u32 size{};
    u64 timeline{};    ///< which MasterSemaphore the gate was measured against (3 Schedulers exist)
    u64 defer_tick{};  ///< the tick DeleteBuffer recorded
    u64 known_gpu{};   ///< KnownGpuTick when the erase ran - must be >= defer_tick for the gate
    /// ⚠⚠ `known_gpu` ALONE can neither condemn nor clear the gate, and NO OTHER TICK FIELD IS KEPT
    /// HERE, deliberately. Two were tried and both were degenerate, on runs that were no different:
    /// against the caller's own tick the answer can only be "sound" (reported 0 of 256 while the
    /// log carried 2616 use-after-free references), and against another Scheduler's CurrentTick it
    /// can only be "unsound" (reported 689 of 689), because CurrentTick belongs to a command buffer
    /// that has not been submitted and KnownGpuTick is at most CurrentTick-1. The failed-query path
    /// in Refresh() also used to latch 0xFFFFFFFFFFFFFFFF, which satisfies every comparison.
    /// The decidable question is ownership - see Instance::RegisterCommandBuffer.
    bool tick_trustworthy{};  ///< false once any timeline has reported the device lost
    bool during_shutdown{};   ///< true when recorded from the teardown flush, not from normal play
};

struct GpuBufferDeathRing {
    static constexpr u32 Capacity = 256;
    static constexpr u32 PrintDetailed = 24;
    GpuBufferDeath entries[Capacity];
    std::atomic<u64> next{0};
};

struct GpuWorkEntry {
    /// Published LAST with release ordering, and zeroed first: a reader that sees a non-zero value
    /// here, copies the payload, and re-reads the same value knows the copy belongs to this seq.
    std::atomic<u64> seq{0};
    GpuWorkPayload payload{};
};

/// A ring of the most recent work submissions, so a lost device can be asked what it was doing.
/// Lives on the Instance because that is what LogDeviceFaultInfo() has in hand, and because the
/// three Schedulers share one Instance - which makes this the only place the overall order of
/// submissions is visible.
struct GpuWorkJournal {
    /// Power of two: index with & (Capacity - 1), never %.
    ///
    /// MEASURED three times, never guessed. At 64 every entry was still in the open command buffer,
    /// so the ring could not reach back even one submission. At 1024 the tool first reported the real
    /// depth: this game builds command buffers of ~6400 draws and dispatches. 8192 was then chosen as
    /// the first power of two that can see past ONE of them - and that was still too small, which
    /// only became visible once the census printed what it could not read: the open command buffer
    /// held 4596 entries and the in-flight one 6251, so **2657 of the hung command buffer's own
    /// entries had already been overwritten** and the shader that hung could have been any of them.
    /// The ring must hold the OPEN buffer plus the whole IN-FLIGHT set (up to three command buffers
    /// here), not one buffer. 32768 covers ~5 of them. ~96 bytes an entry, so about 3 MB - paid once
    /// at startup, and the point of the instrument is to have the answer in it.
    static constexpr u32 Capacity = 32768;
    /// How many entries the dump prints in full. The rest are summarised - 1024 entries would be
    /// 2000 lines of CRITICAL and would bury the fault records above them.
    static constexpr u32 PrintDetailed = 48;
    static constexpr u32 MaxWarned = 32;

    GpuWorkEntry entries[Capacity];
    std::atomic<u64> next_seq{0};
    std::atomic<u64> submitted_upto_seq{0};

    /// One record per successful submit: which timeline tick that command buffer will signal, and
    /// where its work ends in the journal.
    ///
    /// ⚠⚠ WHY THIS EXISTS. The dump used to name "the newest SUBMITTED entry" as the last work the
    /// driver was given, and that is NOT the work that hung - it is merely the last entry that got
    /// recorded before the fault. Because a lost device is reported ASYNCHRONOUSLY, several command
    /// buffers are in flight at once: the guard in MasterSemaphore::Refresh measured
    /// current_tick 3834 against gpu_tick 3831, i.e. THREE command buffers the GPU had started and
    /// not finished. Naming only the newest made the same very common shader (cs_0xa911a841) look
    /// guilty in five consecutive runs; capping every one of its loops changed nothing, which is how
    /// the misdirection was caught. Anything less than the whole in-flight set is a guess.
    ///
    /// Cheap by construction: a range per submit, not a tick per entry - the last command buffer
    /// alone held 4553 entries, so stamping each one would cost that much work at every flush.
    struct SubmitRecord {
        u64 tick{};     ///< the timeline value this command buffer signals on completion
        u64 seq_end{};  ///< journal seq just past this command buffer's last entry
        u64 cmdbuf{};
        /// ⚠ WHICH TIMELINE the tick belongs to. Ticks are per-Scheduler, so they are NOT comparable
        /// across schedulers: the draw scheduler was at 3637 while the present one was at 2581. The
        /// first version of this record omitted the index, so resolving a tick's seq range scanned
        /// this ring for "the newest record with a SMALLER tick" and happily matched a record from a
        /// DIFFERENT scheduler - which is why the present scheduler's range came back identical to
        /// the draw scheduler's, and why every present/flip census was really a copy of the draw
        /// work. Match on the PAIR or the range is meaningless.
        u32 timeline{};
    };
    /// MEASURED (runs 42-44): the device loss is noticed ~10,000 submits after the stall, so at
    /// 512 the oldest unfinished tick's record was gone in every post-mortem and the hung work
    /// could not be named. 16384 reaches past the largest pile-up seen (10,023). 32 bytes a record
    /// = 512 KB, paid once. The live GT_STALL_DUMP detector is the primary instrument; this is the
    /// belt to its braces.
    static constexpr u32 SubmitHistory = 16384;
    SubmitRecord submits[SubmitHistory]{};
    std::atomic<u64> next_submit{0};

    /// Warn-once bookkeeping, kept here rather than left to the logger: spdlog's duplicate filter
    /// only collapses CONSECUTIVE identical lines and is off by default, so a runaway shader would
    /// print once per frame. A linear scan of at most 32 hashes caps it at one line per shader.
    u64 warned_hashes[MaxWarned]{};
    u32 warned_count{0};
    /// Invocations, cached once at construction. 0 disables the warning. NEVER read the setting
    /// per draw.
    u64 warn_threshold{0};
};

class Instance {
public:
    explicit Instance(bool validation = false, bool crash_diagnostic = false);
    explicit Instance(Frontend::WindowSDL& window, s32 physical_device_index,
                      bool enable_validation = false, bool enable_crash_diagnostic = false);
    ~Instance();

    /// Returns a formatted string for the driver version
    std::string GetDriverVersionName();

    /// Gets a compatibility format if the format is not supported.
    [[nodiscard]] vk::Format GetSupportedFormat(vk::Format format,
                                                vk::FormatFeatureFlags2 flags) const;

    /// Returns the Vulkan instance
    vk::Instance GetInstance() const {
        return *instance;
    }

    /// Returns the current physical device
    vk::PhysicalDevice GetPhysicalDevice() const {
        return physical_device;
    }

    /// Returns the Vulkan device
    vk::Device GetDevice() const {
        return *device;
    }

    /// Returns the VMA allocator handle
    VmaAllocator GetAllocator() const {
        return allocator;
    }

    /// Returns a list of the available physical devices
    std::span<const vk::PhysicalDevice> GetPhysicalDevices() const {
        return physical_devices;
    }

    /// Retrieve queue information
    u32 GetGraphicsQueueFamilyIndex() const {
        return queue_family_index;
    }

    u32 GetPresentQueueFamilyIndex() const {
        return queue_family_index;
    }

    vk::Queue GetGraphicsQueue() const {
        return graphics_queue;
    }

    vk::Queue GetPresentQueue() const {
        return present_queue;
    }

    TracyVkCtx GetProfilerContext() const {
        return profiler_context;
    }

    /// Returns true if anisotropic filtering is supported
    bool IsAnisotropicFilteringSupported() const {
        return features.samplerAnisotropy;
    }

    /// Returns true if depth bounds testing is supported
    bool IsDepthBoundsSupported() const {
        return features.depthBounds;
    }

    /// Returns true if 16-bit floats are supported in shaders
    bool IsShaderFloat16Supported() const {
        return vk12_features.shaderFloat16;
    }

    /// Returns true if 64-bit floats are supported in shaders
    bool IsShaderFloat64Supported() const {
        return features.shaderFloat64;
    }

    /// Returns true if 64-bit ints are supported in shaders
    bool IsShaderInt64Supported() const {
        return features.shaderInt64;
    }

    /// Returns true if 16-bit ints are supported in shaders
    bool IsShaderInt16Supported() const {
        return features.shaderInt16;
    }

    /// Returns true if 8-bit ints are supported in shaders
    bool IsShaderInt8Supported() const {
        return vk12_features.shaderInt8;
    }

    /// Returns true if VK_KHR_maintenance8 is supported
    bool IsMaintenance8Supported() const {
        return maintenance_8;
    }

    /// Returns true if VK_EXT_attachment_feedback_loop_layout is supported
    bool IsAttachmentFeedbackLoopLayoutSupported() const {
        return attachment_feedback_loop;
    }

    /// Returns true when VK_EXT_custom_border_color is supported
    bool IsCustomBorderColorSupported() const {
        return custom_border_color;
    }

    /// Returns true when VK_EXT_shader_stencil_export is supported
    bool IsShaderStencilExportSupported() const {
        return shader_stencil_export;
    }

    /// Returns true when VK_EXT_depth_clip_control is supported
    bool IsDepthClipControlSupported() const {
        return depth_clip_control;
    }

    /// Returns true when VK_EXT_depth_clip_enable is supported
    bool IsDepthClipEnableSupported() const {
        return depth_clip_enable;
    }

    /// Returns true when VK_EXT_depth_range_unrestricted is supported
    bool IsDepthRangeUnrestrictedSupported() const {
        return depth_range_unrestricted;
    }

    /// Returns true when VK_EXT_extended_dynamic_state3 is supported
    bool IsExtendedDynamicState3Supported() const {
        return dynamic_state_3;
    }

    /// Returns true when the extendedDynamicState3ColorWriteMask feature of
    /// VK_EXT_extended_dynamic_state3 is supported.
    bool IsDynamicColorWriteMaskSupported() const {
        return dynamic_state_3 && dynamic_state_3_features.extendedDynamicState3ColorWriteMask;
    }

    /// Returns true when VK_EXT_vertex_input_dynamic_state is supported.
    bool IsVertexInputDynamicState() const {
        return vertex_input_dynamic_state;
    }

    /// Returns true when VK_KHR_fragment_shader_barycentric is supported.
    bool IsFragmentShaderBarycentricSupported() const {
        return fragment_shader_barycentric;
    }

    /// Returns true when VK_AMD_shader_explicit_vertex_parameter is supported.
    bool IsAmdShaderExplicitVertexParameterSupported() const {
        return amd_shader_explicit_vertex_parameter;
    }

    /// Returns true when VK_EXT_primitive_topology_list_restart is supported for regular lists.
    bool IsListRestartSupported() const {
        return list_restart && list_restart_features.primitiveTopologyListRestart;
    }

    /// Returns true when VK_EXT_primitive_topology_list_restart is supported for patch lists.
    bool IsPatchListRestartSupported() const {
        return list_restart && list_restart_features.primitiveTopologyPatchListRestart;
    }

    /// Returns true when VK_EXT_provoking_vertex is supported.
    bool IsProvokingVertexSupported() const {
        return provoking_vertex;
    }

    /// Returns true when VK_AMD_shader_image_load_store_lod is supported.
    bool IsImageLoadStoreLodSupported() const {
        return image_load_store_lod;
    }

    /// Returns true when VK_AMD_gcn_shader is supported.
    bool IsAmdGcnShaderSupported() const {
        return amd_gcn_shader;
    }

    /// Returns true when VK_AMD_shader_trinary_minmax is supported.
    bool IsAmdShaderTrinaryMinMaxSupported() const {
        return amd_shader_trinary_minmax;
    }

    /// Returns true when the shaderBufferFloat32AtomicMinMax feature of
    /// VK_EXT_shader_atomic_float2 is supported.
    bool IsShaderAtomicFloatBuffer32MinMaxSupported() const {
        return shader_atomic_float2 &&
               shader_atomic_float2_features.shaderBufferFloat32AtomicMinMax;
    }

    /// Returns true when the shaderImageFloat32AtomicMinMax feature of
    /// VK_EXT_shader_atomic_float2 is supported.
    bool IsShaderAtomicFloatImage32MinMaxSupported() const {
        return shader_atomic_float2 && shader_atomic_float2_features.shaderImageFloat32AtomicMinMax;
    }

    /// Returns true if 64-bit integer atomic operations can be used on buffers
    bool IsBufferInt64AtomicsSupported() const {
        return vk12_features.shaderBufferInt64Atomics;
    }

    /// Returns true if 64-bit integer atomic operations can be used on shared memory
    bool IsSharedInt64AtomicsSupported() const {
        return vk12_features.shaderSharedInt64Atomics;
    }

    /// Returns true if the subgroup size can be set to match guest subgroup size
    bool IsSubgroupSize64Supported() const {
        return vk13_features.subgroupSizeControl && vk13_props.maxSubgroupSize >= 64;
    }

    /// Returns true when VK_KHR_workgroup_memory_explicit_layout is supported.
    bool IsWorkgroupMemoryExplicitLayoutSupported() const {
        return workgroup_memory_explicit_layout &&
               workgroup_memory_explicit_layout_features.workgroupMemoryExplicitLayout16BitAccess;
    }

    /// Returns true if VK_NV_framebuffer_mixed_samples or
    /// VK_AMD_mixed_attachment_samples is supported
    bool IsMixedDepthSamplesSupported() const {
        return nv_framebuffer_mixed_samples || amd_mixed_attachment_samples;
    }

    /// Returns true if VK_AMD_mixed_attachment_samples is supported
    bool IsMixedAnySamplesSupported() const {
        return amd_mixed_attachment_samples;
    }

    /// Returns true when geometry shaders are supported by the device
    bool IsGeometryStageSupported() const {
        return features.geometryShader;
    }

    /// Returns true when tessellation is supported by the device
    bool IsTessellationSupported() const {
        return features.tessellationShader;
    }

    /// Returns the vendor ID of the physical device
    u32 GetVendorID() const {
        return properties.vendorID;
    }

    /// Returns the device ID of the physical device
    u32 GetDeviceID() const {
        return properties.deviceID;
    }

    /// Returns the driver ID.
    vk::DriverId GetDriverID() const {
        return driver_id;
    }

    /// Returns the current driver version provided in Vulkan-formatted version numbers.
    u32 GetDriverVersion() const {
        return properties.driverVersion;
    }

    /// Returns the current Vulkan API version provided in Vulkan-formatted version numbers.
    u32 ApiVersion() const {
        return properties.apiVersion;
    }

    /// Returns the vendor name reported from Vulkan.
    std::string_view GetVendorName() const {
        return vendor_name;
    }

    /// Returns the list of available extensions.
    std::span<const std::string> GetAvailableExtensions() const {
        return available_extensions;
    }

    /// Returns the device name.
    std::string_view GetModelName() const {
        return properties.deviceName;
    }

    /// Returns if the device is an integrated GPU.
    bool IsIntegrated() const {
        return properties.deviceType == vk::PhysicalDeviceType::eIntegratedGpu;
    }

    /// Returns the pipeline cache unique identifier
    const auto GetPipelineCacheUUID() const {
        return properties.pipelineCacheUUID;
    }

    /// Returns the minimum required alignment for uniforms
    vk::DeviceSize UniformMinAlignment() const {
        return properties.limits.minUniformBufferOffsetAlignment;
    }

    ///  Returns the maximum size of uniform buffers.
    vk::DeviceSize UniformMaxSize() const {
        return properties.limits.maxUniformBufferRange;
    }

    /// Returns the minimum required alignment for storage buffers
    vk::DeviceSize StorageMinAlignment() const {
        return properties.limits.minStorageBufferOffsetAlignment;
    }

    /// Returns the minimum alignemt required for accessing host-mapped device memory
    vk::DeviceSize NonCoherentAtomSize() const {
        return properties.limits.nonCoherentAtomSize;
    }

    /// Returns the subgroup size of the selected physical device.
    u32 SubgroupSize() const {
        return vk11_props.subgroupSize;
    }

    /// Returns the maximum size of compute shared memory.
    u32 MaxComputeSharedMemorySize() const {
        return properties.limits.maxComputeSharedMemorySize;
    }

    /// Returns the maximum sampler LOD bias.
    float MaxSamplerLodBias() const {
        return properties.limits.maxSamplerLodBias;
    }

    /// Returns the maximum sampler anisotropy.
    float MaxSamplerAnisotropy() const {
        return properties.limits.maxSamplerAnisotropy;
    }

    /// Returns the maximum number of push descriptors.
    u32 MaxPushDescriptors() const {
        return push_descriptor_props.maxPushDescriptors;
    }

    /// Returns the vulkan 1.2 physical device properties.
    const vk::PhysicalDeviceVulkan12Properties& GetVk12Properties() const noexcept {
        return vk12_props;
    }

    /// Returns the memory properties of the physical device.
    const vk::PhysicalDeviceMemoryProperties& GetMemoryProperties() const noexcept {
        return memory_properties;
    }

    /// Returns true if shaders can declare the ClipDistance attribute
    bool IsShaderClipDistanceSupported() const {
        return features.shaderClipDistance;
    }

    /// Returns the maximim viewport width.
    u32 GetMaxViewportWidth() const {
        return properties.limits.maxViewportDimensions[0];
    }

    /// Returns the maximum viewport height.
    u32 GetMaxViewportHeight() const {
        return properties.limits.maxViewportDimensions[1];
    }

    /// Returns the maximum render area width.
    u32 GetMaxFramebufferWidth() const {
        return properties.limits.maxFramebufferWidth;
    }

    /// Returns the maximum render area height.
    u32 GetMaxFramebufferHeight() const {
        return properties.limits.maxFramebufferHeight;
    }

    /// Returns the maximum number of samplers that can be allocated at once.
    u32 GetMaxSamplerAllocationCount() const {
        if (driver_id == vk::DriverId::eMesaKosmickrisp) {
            // FIXME: KosmicKrisp has an internal 1024 unique sampler limit before
            // vkCreateSampler starts returning VK_ERROR_OUT_OF_HOST_MEMORY. Work
            // around this for now by reducing the value to 1024.
            return 1024;
        }
        return properties.limits.maxSamplerAllocationCount;
    }

    /// Returns the sample count flags supported by color buffers.
    vk::SampleCountFlags GetColorSampleCounts() const {
        return properties.limits.framebufferColorSampleCounts;
    }

    /// Returns the sample count flags supported by depth buffer.
    vk::SampleCountFlags GetDepthSampleCounts() const {
        return properties.limits.framebufferDepthSampleCounts &
               properties.limits.framebufferStencilSampleCounts;
    }

    /// Returns true if logic ops are supported by the device.
    bool IsLogicOpSupported() const {
        return features.logicOp;
    }

    /// Returns whether VK_IMAGE_CREATE_BLOCK_TEXEL_VIEW_COMPATIBLE_BIT is supported on compressed
    /// images.
    bool IsBlockTexelViewSupported() const {
        return supports_block_texel_view;
    }

    /// Returns whether VK_IMAGE_CREATE_2D_VIEW_COMPATIBLE_BIT_EXT is supported on 3D images
    bool Is2dViewOf3dSupported() const {
        return image_2d_view_of_3d && image_2d_view_of_3d_features.image2DViewOf3D &&
               image_2d_view_of_3d_features.sampler2DViewOf3D;
    }

    /// Returns whether VK_EXT_image_view_min_lod is supported.
    bool IsImageViewMinLodSupported() const {
        return image_view_min_lod;
    }

    /// Returns whether the device can report memory usage.
    bool CanReportMemoryUsage() const {
        return supports_memory_budget;
    }

    /// Returns whether VK_EXT_device_fault is supported and was enabled.
    bool IsDeviceFaultSupported() const {
        return device_fault;
    }

    /// Asks the driver what actually killed the device after a VK_ERROR_DEVICE_LOST.
    /// Call this *before* aborting, from whichever thread saw the error. Safe to call from
    /// several threads and more than once: only the first call queries and reports.
    void LogDeviceFaultInfo() const;

    /// Records one unit of work handed to the GPU, and warns immediately if it is monstrous.
    /// Cheap by construction - plain stores plus one relaxed increment, no allocation, no lock, no
    /// Vulkan call, no barrier - so unlike CDL and the validation layers it physically cannot move
    /// the GPU timeline and hide the race we are hunting.
    void RecordGpuWork(const GpuWorkPayload& payload) const;

    /// Returns the sequence number of the newest recorded work, to be passed to
    /// MarkGpuWorkSubmitted only after the submit it belongs to has SUCCEEDED.
    [[nodiscard]] u64 PeekGpuWorkSeq() const {
        return gpu_work_journal.next_seq.load(std::memory_order_relaxed);
    }

    /// Newest work sequence already handed to the driver. PeekGpuWorkSeq() equal to this
    /// means the open command buffer holds NO recorded work - an end-of-pipe fence signed
    /// right now orders against nothing, so GT_DEFER_EOP signs it eagerly instead of
    /// deferring (deferral on an empty queue bought nothing and raced GT7's boot: the
    /// FWRKR null-read, 2 of 5 boots).
    [[nodiscard]] u64 SubmittedUptoGpuWorkSeq() const {
        return gpu_work_journal.submitted_upto_seq.load(std::memory_order_relaxed);
    }

    /// Marks work up to `upto` as genuinely handed to the driver. ⚠ Call this AFTER a successful
    /// vkQueueSubmit, never before: a submit that returns VK_ERROR_DEVICE_LOST did NOT deliver its
    /// command buffer, and counting it as delivered makes the journal name the wrong submission as
    /// "the last work the driver was given" - which matters precisely because the loss is reported
    /// asynchronously and the guilty work is an EARLIER one.
    /// `tick` is the timeline value the command buffer will signal, and `cmdbuf` its handle, so the
    /// dump can name every command buffer that was IN FLIGHT rather than only the newest recorded.
    /// `semaphore` identifies WHICH timeline the tick counts on - required, because ticks from two
    /// schedulers are different numbers in different sequences and confusing them silently produces
    /// a plausible-looking range over the wrong command buffer.
    void MarkGpuWorkSubmitted(u64 upto, u64 tick, u64 cmdbuf,
                              const MasterSemaphore* semaphore) const;

    /// Records a buffer destruction at the moment the deferred erase actually ran. Host-side only:
    /// no Vulkan call, no GPU command, so it cannot perturb the race being hunted. Fills in the
    /// all-timelines fields itself, so the caller only supplies what it alone knows.
    void RecordBufferDeath(GpuBufferDeath death) const;

    /// Registers a Scheduler's timeline so a lifetime gate can consult ALL of them. Called from the
    /// Scheduler constructor; every Scheduler holds the Instance by reference and so cannot outlive
    /// it. Registration is idempotent.
    void RegisterTimeline(MasterSemaphore* semaphore) const;

    /// Captures the current logical tick of every registered timeline. A deletion queued now is only
    /// safe once EVERY one of these has been reached, because the resource may be referenced by a
    /// command buffer on any Scheduler.
    ///
    /// `recording_owner` (the caller's own scheduler) is snapshotted at its RECORDING tick - its
    /// open command buffer accumulates cache-resource references between submits. Every OTHER
    /// timeline is snapshotted at its last SUBMITTED tick (CurrentTick - 1), because run 120
    /// measured the recording-tick gate starving on the flip scheduler: gate 622 / known 621 /
    /// current 622 held 1112 corpses (6.6 GB) - a scheduler that does not submit during a
    /// streaming phase can never satisfy a gate on its open tick, and no counter refresh can help
    /// (the tick was never signaled). Verified against vk_presenter.cpp before weakening: the
    /// present/flip schedulers' recording sessions are begin-record-Flush within ONE function and
    /// touch ONLY frame/swapchain images (plus ImGui's own pools) - never a cache buffer - so
    /// their open command buffers cannot reference the dying resource. ⚠ IF ANYONE EVER RECORDS A
    /// CACHE BUFFER ON THE PRESENT OR FLIP SCHEDULER, this assumption breaks silently; the
    /// tripwire is the run-60-63 signature (device lost naming innocent draw shaders) plus a
    /// validation VUID-vkDestroyBuffer naming a present/flip cmdbuf in the ownership dump.
    [[nodiscard]] GpuTimelineSet SnapshotTimelines(const MasterSemaphore* recording_owner) const;

    /// True only when every timeline in `set` has genuinely been passed by its GPU. Returns false if
    /// any timeline has reported the device lost, because a tick sampled after that is meaningless.
    [[nodiscard]] bool AllTimelinesPast(const GpuTimelineSet& set) const;

    /// How many of `set`'s timelines have been passed. For the journal: `< count` on an entry proves
    /// the gate let a resource go while another Scheduler was still using it.
    [[nodiscard]] u32 CountTimelinesPast(const GpuTimelineSet& set) const;

    /// Queries every registered timeline's semaphore counter once (MasterSemaphore::Refresh is a
    /// forward-only CAS and vkGetSemaphoreCounterValue needs no external synchronization, so this
    /// is safe from any thread). Run 119's OOM: IsFree() reads a CACHED gpu_tick that only its own
    /// Scheduler's activity advances - the death gate read stale present/flip values from the draw
    /// thread and 4495 corpses (16 GB) piled up waiting for progress the GPU had long made.
    /// Call once per drain pass, never per corpse: three queries, not three-per-death.
    void RefreshTimelines() const;

    /// Index of the first timeline in `set` that has NOT been passed (0=draw, 1=present, 2=flip in
    /// vk_presenter construction order), with its gate/known/current ticks - so a graveyard that
    /// will not drain can NAME the scheduler holding it. Returns set.count when all passed.
    u32 FirstUnmetTimeline(const GpuTimelineSet& set, u64& gate_tick, u64& known_tick,
                           u64& current_tick) const;

    [[nodiscard]] u32 GetNumTimelines() const {
        return num_timelines.load(std::memory_order_acquire);
    }

    /// True once any timeline has reported the device lost - after which no tick is a guarantee.
    [[nodiscard]] bool AnyTimelineLost() const;

    /// Records that `cmdbuf` belongs to the Scheduler owning `semaphore`.
    ///
    /// ⚠ This exists because every TICK-BASED measure of the lifetime gate is degenerate. Comparing
    /// against the caller's own tick can only ever answer "sound" (it is the very comparison that is
    /// insufficient); comparing against another Scheduler's CurrentTick can only ever answer
    /// "unsound", because CurrentTick is the tick of a command buffer that has NOT been submitted and
    /// KnownGpuTick is at most CurrentTick-1. The first version of this journal reported 0 of 256
    /// violations, the second 689 of 689, on runs that were no different.
    ///
    /// The question that is actually decidable is one of OWNERSHIP: the validation layer names the
    /// VkCommandBuffer holding a destroyed resource, and this table says which Scheduler that handle
    /// belongs to. If it is not the one BufferCache and TextureCache are bound to, the gate is
    /// provably consulting the wrong timeline - and no threshold has to be guessed to say so.
    void RegisterCommandBuffer(u64 cmdbuf, const MasterSemaphore* semaphore) const;

    /// Returns the amount of memory used.
    [[nodiscard]] u64 GetDeviceMemoryUsage() const;

    /// VMA's own totals - what OUR caches allocated, as opposed to GetDeviceMemoryUsage's
    /// whole-process heap figure. The difference is the driver's/implicit share. Added for the
    /// memory-pressure hunt: three device-losts (runs 60-62) at 9-11 GB used could not say WHO
    /// owned the memory.
    void GetVmaStatistics(u64& used_bytes, u32& alloc_count) const;

    /// Returns the total memory budget available to the device.
    [[nodiscard]] u64 GetTotalMemoryBudget() const {
        return total_memory_budget;
    }

    /// Determines if a format is supported for a set of feature flags.
    [[nodiscard]] bool IsFormatSupported(vk::Format format, vk::FormatFeatureFlags2 flags) const;

private:
    /// Creates the logical device opportunistically enabling extensions
    bool CreateDevice();

    /// Creates the VMA allocator handle
    void CreateAllocator();

    /// Collects various information from the device.
    void CollectDeviceParameters();
    void CollectPhysicalMemoryInfo();
    void CollectImageFormatInfo();
    void CollectToolingInfo() const;

    /// Gets the supported feature flags for a format.
    [[nodiscard]] vk::FormatFeatureFlags2 GetFormatFeatureFlags(vk::Format format) const;

public:
    /// Prints the work journal. Runs on an already-dead device, so cost does not matter.
    void DumpGpuWorkJournal() const;

    /// Prints the VK_NV_device_diagnostic_checkpoints markers the driver still holds, i.e. WHICH
    /// recorded draw or dispatch each queue had reached when the device died.
    void LogQueueCheckpoints() const;

private:
    vk::UniqueInstance instance;
    vk::PhysicalDevice physical_device;
    vk::UniqueDevice device;
    vk::PhysicalDeviceProperties properties;
    vk::PhysicalDeviceMemoryProperties memory_properties;
    vk::PhysicalDeviceVulkan11Properties vk11_props;
    vk::PhysicalDeviceVulkan12Properties vk12_props;
    vk::PhysicalDeviceVulkan13Properties vk13_props;
    vk::PhysicalDevicePushDescriptorPropertiesKHR push_descriptor_props;
    vk::PhysicalDeviceFeatures features;
    vk::PhysicalDeviceVulkan12Features vk12_features;
    vk::PhysicalDeviceVulkan13Features vk13_features;
    vk::PhysicalDeviceExtendedDynamicState3FeaturesEXT dynamic_state_3_features;
    vk::PhysicalDeviceShaderAtomicFloat2FeaturesEXT shader_atomic_float2_features;
    vk::PhysicalDeviceWorkgroupMemoryExplicitLayoutFeaturesKHR
        workgroup_memory_explicit_layout_features;
    vk::PhysicalDeviceImage2DViewOf3DFeaturesEXT image_2d_view_of_3d_features;
    vk::PhysicalDevicePrimitiveTopologyListRestartFeaturesEXT list_restart_features;
    vk::DriverIdKHR driver_id;
    vk::UniqueDebugUtilsMessengerEXT debug_callback{};
    std::string vendor_name;
    VmaAllocator allocator{};
    vk::Queue present_queue;
    vk::Queue graphics_queue;
    std::vector<vk::PhysicalDevice> physical_devices;
    std::vector<std::string> available_extensions;
    std::unordered_map<vk::Format, vk::FormatProperties3> format_properties;
    TracyVkCtx profiler_context{};
    u32 queue_family_index{0};
    bool custom_border_color{};
    bool fragment_shader_barycentric{};
    bool amd_shader_explicit_vertex_parameter{};
    bool depth_clip_control{};
    bool depth_clip_enable{};
    bool dynamic_state_3{};
    bool depth_range_unrestricted{};
    bool vertex_input_dynamic_state{};
    bool list_restart{};
    bool provoking_vertex{};
    bool shader_stencil_export{};
    bool image_load_store_lod{};
    bool amd_gcn_shader{};
    bool amd_shader_trinary_minmax{};
    bool nv_framebuffer_mixed_samples{};
    bool amd_mixed_attachment_samples{};
    bool shader_atomic_float{};
    bool shader_atomic_float2{};
    bool workgroup_memory_explicit_layout{};
    bool maintenance_8{};
    bool attachment_feedback_loop{};
    bool image_2d_view_of_3d{};
    bool image_view_min_lod{};
    bool supports_memory_budget{};
    bool supports_block_texel_view{};
    bool device_fault{};
    bool diagnostic_checkpoints{};
    bool device_fault_vendor_binary{};
    mutable std::once_flag device_fault_once;
    /// Separate from device_fault_once so the journal is still printed on a device that does not
    /// support VK_EXT_device_fault, where LogDeviceFaultInfo returns before that flag is reached.
    mutable std::once_flag gpu_work_dump_once;
    mutable GpuWorkJournal gpu_work_journal{};
    mutable GpuBufferDeathRing gpu_buffer_deaths{};
    /// Every Scheduler's timeline, so a lifetime gate can wait on all of them instead of one.
    mutable MasterSemaphore* timelines[GpuTimelineSet::MaxTimelines]{};
    mutable std::atomic<u32> num_timelines{0};
    mutable std::mutex timelines_mutex;
    /// Which Scheduler owns which command buffer handle. A pool hands out a small fixed set and
    /// recycles them, so this saturates quickly and stays tiny.
    static constexpr u32 MaxTrackedCmdBufs = 32;
    mutable u64 tracked_cmdbufs[MaxTrackedCmdBufs]{};
    mutable u32 tracked_cmdbuf_owner[MaxTrackedCmdBufs]{};
    mutable std::atomic<u32> num_tracked_cmdbufs{0};
    /// Set the first time the fault is logged. Anything recorded afterwards is post-mortem: the
    /// teardown flush runs the pending-operation queues on a dead GPU, and those entries used to
    /// overwrite the ones that mattered in a 256-deep ring after 764 deletions.
    mutable std::atomic<bool> fault_already_logged{false};
    u64 total_memory_budget{};
    std::vector<size_t> valid_heaps;
};

} // namespace Vulkan
