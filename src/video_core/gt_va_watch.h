// SPDX-FileCopyrightText: Copyright 2025-2026 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#pragma once

// GT_WATCH_VA / GT_WATCH_SIZE: comma-separated hex guest ranges watched across a whole
// session (a single value keeps the old single-range behavior). Parsed once, shared by the
// bind-site logs ([vawatch]/[lut3d], vk_rasterizer.cpp) and the upload-site log ([aewatch],
// texture_cache.cpp) so both ends of the story - who binds a range on the GPU and what
// bytes the texture cache uploads into it - come from the SAME range list. Grew a second
// range the day the AE hunt needed the 1x1 R8 exposure state (0x1000e33200) and the 16x1
// R16F transmittance strip (0x10b19a1700) watched in ONE run.

#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>
#include "common/types.h"

namespace VideoCore {

struct GtWatchedRange {
    u64 base;
    u64 size;
};

inline std::vector<u64> GtParseHexList(const char* v) {
    std::vector<u64> out;
    if (!v || v[0] == '\0') {
        return out;
    }
    const std::string s{v};
    size_t pos = 0;
    while (pos <= s.size()) {
        const size_t comma = s.find(',', pos);
        const std::string tok =
            s.substr(pos, comma == std::string::npos ? std::string::npos : comma - pos);
        if (!tok.empty()) {
            out.push_back(std::strtoull(tok.c_str(), nullptr, 16));
        }
        if (comma == std::string::npos) {
            break;
        }
        pos = comma + 1;
    }
    return out;
}

inline const std::vector<GtWatchedRange>& GtWatchRanges() {
    static const std::vector<GtWatchedRange> ranges = [] {
        std::vector<GtWatchedRange> r;
        const auto bases = GtParseHexList(std::getenv("GT_WATCH_VA"));
        const auto sizes = GtParseHexList(std::getenv("GT_WATCH_SIZE"));
        for (size_t i = 0; i < bases.size(); ++i) {
            if (bases[i] == 0) {
                continue;
            }
            const u64 size = i < sizes.size() && sizes[i] != 0 ? sizes[i] : 0x200000;
            r.push_back({bases[i], size});
        }
        return r;
    }();
    return ranges;
}

inline const GtWatchedRange* GtWatchHit(u64 base, u64 size) {
    for (const auto& w : GtWatchRanges()) {
        if (base < w.base + w.size && w.base < base + size) {
            return &w;
        }
    }
    return nullptr;
}

} // namespace VideoCore
