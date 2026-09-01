// SPDX-FileCopyrightText: Copyright 2024 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#include <cstdlib>

#include "common/gt_thread_prof.h"
#include "common/logging/log.h"

#ifdef _WIN32

#include <algorithm>
#include <chrono>
#include <string>
#include <thread>
#include <unordered_map>
#include <vector>

#include "common/types.h"

#include <windows.h>

#include <tlhelp32.h>

#include "common/thread.h"

namespace Common {

namespace {

u64 FileTimeTo100ns(const FILETIME& ft) {
    return (u64(ft.dwHighDateTime) << 32) | ft.dwLowDateTime;
}

std::string NarrowName(const wchar_t* w) {
    if (!w || !*w) {
        return {};
    }
    std::string out;
    for (const wchar_t* p = w; *p; ++p) {
        out += (*p < 128) ? char(*p) : '?';
    }
    return out;
}

void CensusLoop() {
    SetCurrentThreadName("GtThreadProf");
    const DWORD pid = GetCurrentProcessId();
    // tid -> (last kernel+user 100ns, name)
    std::unordered_map<DWORD, u64> prev;
    u64 prev_proc = 0;
    auto prev_wall = std::chrono::steady_clock::now();

    while (true) {
        std::this_thread::sleep_for(std::chrono::milliseconds(5000));

        const auto now = std::chrono::steady_clock::now();
        const double wall_ms =
            std::chrono::duration_cast<std::chrono::microseconds>(now - prev_wall).count() /
            1000.0;
        prev_wall = now;

        // Process totals first, so the per-thread shares have a denominator to be checked
        // against (threads that died mid-window leave the sum short of the process delta).
        FILETIME pc, pe, pk, pu;
        u64 proc_delta_100ns = 0;
        if (GetProcessTimes(GetCurrentProcess(), &pc, &pe, &pk, &pu)) {
            const u64 total = FileTimeTo100ns(pk) + FileTimeTo100ns(pu);
            proc_delta_100ns = total - prev_proc;
            prev_proc = total;
        }

        struct Row {
            DWORD tid;
            double cpu_pct; // of ONE core over the window
            std::string name;
        };
        std::vector<Row> rows;

        HANDLE snap = CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
        if (snap != INVALID_HANDLE_VALUE) {
            THREADENTRY32 te{};
            te.dwSize = sizeof(te);
            if (Thread32First(snap, &te)) {
                do {
                    if (te.th32OwnerProcessID != pid) {
                        continue;
                    }
                    HANDLE h = OpenThread(THREAD_QUERY_LIMITED_INFORMATION, FALSE,
                                          te.th32ThreadID);
                    if (!h) {
                        continue;
                    }
                    FILETIME tc, tx, tk, tu;
                    if (GetThreadTimes(h, &tc, &tx, &tk, &tu)) {
                        const u64 total = FileTimeTo100ns(tk) + FileTimeTo100ns(tu);
                        auto [it, fresh] = prev.try_emplace(te.th32ThreadID, 0);
                        const u64 delta = total - it->second;
                        it->second = total;
                        // A thread first seen mid-run reports its LIFETIME cpu as the first
                        // delta; suppress that first sample instead of printing a lie.
                        if (!fresh && delta > 0) {
                            std::string name;
                            PWSTR desc = nullptr;
                            if (SUCCEEDED(GetThreadDescription(h, &desc)) && desc) {
                                name = NarrowName(desc);
                                LocalFree(desc);
                            }
                            if (name.empty()) {
                                name = "tid" + std::to_string(te.th32ThreadID);
                            }
                            rows.push_back({te.th32ThreadID,
                                            (delta / 10000.0) / wall_ms * 100.0,
                                            std::move(name)});
                        }
                    }
                    CloseHandle(h);
                } while (Thread32Next(snap, &te));
            }
            CloseHandle(snap);
        }

        std::sort(rows.begin(), rows.end(),
                  [](const Row& a, const Row& b) { return a.cpu_pct > b.cpu_pct; });

        std::string line;
        double shown = 0.0;
        u32 count = 0;
        for (const auto& r : rows) {
            if (count >= 14 || r.cpu_pct < 2.0) {
                break;
            }
            line += fmt::format(" | {} {:.0f}%", r.name, r.cpu_pct);
            shown += r.cpu_pct;
            ++count;
        }
        const double proc_pct = (proc_delta_100ns / 10000.0) / wall_ms * 100.0;
        LOG_INFO(Core, "[tprof] win={:.1f}s proc={:.0f}% threads={} shown={:.0f}%{}",
                 wall_ms / 1000.0, proc_pct, rows.size(), shown, line);
    }
}

} // namespace

void StartGtThreadProf() {
    if (std::getenv("GT_THREAD_PROF") == nullptr) {
        return;
    }
    std::thread(CensusLoop).detach();
    LOG_WARNING(Core, "[tprof] thread census armed (GT_THREAD_PROF)");
}

} // namespace Common

#else

namespace Common {
void StartGtThreadProf() {}
} // namespace Common

#endif
