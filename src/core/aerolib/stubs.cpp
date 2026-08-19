// SPDX-FileCopyrightText: Copyright 2024 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#include "common/logging/log.h"
#include "core/aerolib/aerolib.h"
#include "core/aerolib/stubs.h"

namespace Core::AeroLib {

// Helper to provide stub implementations for missing functions
//
// This works by pre-compiling generic stub functions ("slots"), and then
// on lookup, setting up the nid_entry they are matched with
//
// If it runs out of stubs with name information, it will return
// a default implementation without function name details

// 8192 ran out on GT7: the linker does not LOG stub creation for libc/libSceFios2 (thousands of
// nids), so UsedStubEntries blows past the cap while the log shows only ~2.7k "Stub resolved"
// lines - and every later miss gets the anonymous UnknownStub, which is how the update-check
// freeze spent a run as "Returning zero to 0xed7e90a" with no function name.
constexpr u32 MAX_STUBS = 16384;

u64 UnresolvedStub() {
    LOG_ERROR(Core, "Returning zero to {}", __builtin_return_address(0));
    return 0;
}

static u64 UnknownStub() {
    LOG_ERROR(Core, "STUB SLOTS EXHAUSTED ({}) - nameless stub, returning zero to {}", MAX_STUBS,
              __builtin_return_address(0));
    return 0;
}

static const NidEntry* stub_nids[MAX_STUBS];
static std::string stub_nids_unknown[MAX_STUBS];

static u64 CommonStub(int stub_index, void* addr) {
    auto entry = stub_nids[stub_index];
    if (entry) {
        LOG_ERROR(Core, "Stub: {} (nid: {}) called, returning zero to {}", entry->name, entry->nid,
                  addr);
    } else {
        LOG_ERROR(Core, "Stub: Unknown (nid: {}) called, returning zero to {}",
                  stub_nids_unknown[stub_index], addr);
    }
    return 0;
}

template <int stub_index>
static u64 CommonStubTemplate() {
    return CommonStub(stub_index, __builtin_return_address(0));
}

template <size_t... Is>
consteval auto MakeStubArray(std::index_sequence<Is...>) {
    return std::array<u64 (*)(), sizeof...(Is)>{&CommonStubTemplate<Is>...};
}

constexpr auto stub_handlers = MakeStubArray(std::make_index_sequence<MAX_STUBS>{});
static u32 UsedStubEntries;

u64 GetStub(const char* nid) {
    // One slot per UNIQUE nid, not per resolution: every module importing the same missing
    // symbol used to burn a fresh slot, which is how GT7 exhausted 16384 of them and the
    // update-check freeze logged as a nameless "STUB SLOTS EXHAUSTED" with no way to see
    // which function the game was polling.
    static std::unordered_map<std::string, u64> stub_by_nid;
    if (const auto it = stub_by_nid.find(nid); it != stub_by_nid.end()) {
        return it->second;
    }
    if (UsedStubEntries >= MAX_STUBS) {
        return (u64)&UnknownStub;
    }

    const auto entry = FindByNid(nid);
    if (!entry) {
        stub_nids_unknown[UsedStubEntries] = nid;
    } else {
        stub_nids[UsedStubEntries] = entry;
    }

    const u64 addr = (u64)stub_handlers[UsedStubEntries++];
    stub_by_nid.emplace(nid, addr);
    return addr;
}

} // namespace Core::AeroLib
