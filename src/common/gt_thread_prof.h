// SPDX-FileCopyrightText: Copyright 2024 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#pragma once

namespace Common {

// GT7 lane instrument: when the GT_THREAD_PROF env var is set, starts a background thread that
// every 5 seconds walks all threads of the process (names via GetThreadDescription, CPU via
// GetThreadTimes) and logs the top consumers as one "[tprof]" line. Exists to answer, with a
// measurement, WHICH threads peg 11-12 cores while the GPU idles at 20% (the FPS-decay front).
// No-op when the env var is absent, and on non-Windows platforms.
void StartGtThreadProf();

} // namespace Common
