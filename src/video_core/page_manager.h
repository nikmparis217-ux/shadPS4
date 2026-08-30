// SPDX-FileCopyrightText: Copyright 2024 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#pragma once

#include <atomic>
#include <cstddef>
#include <cstdlib>
#include <memory>
#include "common/alignment.h"
#include "common/types.h"
#include "video_core/buffer_cache//region_definitions.h"

namespace Vulkan {
class Rasterizer;
}

namespace VideoCore {

/// GT_FRAME_PROF instrumentation (run 210): the page-protection bill, split by caller.
/// Run 209's [spanprof] put 150-830 ms/2s in the span walk's "cpu" bucket and only 4-12 ms
/// in recording, so the suspects left inside that bucket are the staging memcpy and the
/// write-protect machinery - on Windows every Protect is a regions-map walk plus a
/// VirtualQueryEx plus a VirtualProtectEx (TLB shootdown included). in_span_walk attributes
/// the Protect calls made under ForEachUploadRange (the GPU-thread upload path) separately
/// from everything else (fault-handler unprotects on the game thread, texture cache,
/// registration). Counters are read+reset by the buffer cache's 2 s [protprof] flush.
namespace GtProtProf {
inline std::atomic<u64> span_calls{0};
inline std::atomic<u64> span_ns{0};
inline std::atomic<u64> other_calls{0};
inline std::atomic<u64> other_ns{0};
inline std::atomic<u64> faults_write{0};
inline std::atomic<u64> faults_read{0};
// The whole UpdatePageWatchers* body (IsMapped lookup + range locks + page loop + the
// Protect calls above), timed at the UpdateProtection call site in region_manager.h and
// attributed the same way. protect syscalls = span_ns; watcher machinery AROUND them =
// watch_span_ns - span_ns; the bitset walk itself = spanprof cpu - memcpy - watch_span_ns.
inline std::atomic<u64> watch_span_ns{0};
inline std::atomic<u64> watch_other_ns{0};
inline thread_local bool in_span_walk = false;

inline bool Enabled() {
    static const bool enabled = [] {
        const char* v = std::getenv("GT_FRAME_PROF");
        return v && std::atoi(v) != 0;
    }();
    return enabled;
}
} // namespace GtProtProf

class PageManager {
    // PAGE_SIZE and PAGE_BITS conflicts with machine/param.h definitions on freebsd!
    // Use the same page size as the tracker.
    static constexpr size_t PM_PAGE_BITS = TRACKER_PAGE_BITS;
    static constexpr size_t PM_PAGE_SIZE = TRACKER_BYTES_PER_PAGE;

    // Keep the lock granularity the same as region granularity. (since each regions has
    // itself a lock)
    static constexpr size_t PAGES_PER_LOCK = NUM_PAGES_PER_REGION;

public:
    explicit PageManager(Vulkan::Rasterizer* rasterizer);
    ~PageManager();

    /// Register a range of mapped gpu memory.
    void OnGpuMap(VAddr address, size_t size);

    /// Unregister a range of gpu memory that was unmapped.
    void OnGpuUnmap(VAddr address, size_t size);

    /// Updates watches in the pages touching the specified region.
    template <bool track>
    void UpdatePageWatchers(VAddr addr, u64 size) const;

    /// Updates watches in the pages touching the specified region using a mask.
    template <bool track, bool is_read = false>
    void UpdatePageWatchersForRegion(VAddr base_addr, RegionBits& mask) const;

    /// Returns page aligned address.
    static constexpr VAddr GetPageAddr(VAddr addr) {
        return Common::AlignDown(addr, PM_PAGE_SIZE);
    }

    /// Returns address of the next page.
    static constexpr VAddr GetNextPageAddr(VAddr addr) {
        return Common::AlignUp(addr + 1, PM_PAGE_SIZE);
    }

private:
    struct Impl;
    std::unique_ptr<Impl> impl;
};

} // namespace VideoCore
