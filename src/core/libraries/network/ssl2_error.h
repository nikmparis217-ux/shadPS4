// SPDX-FileCopyrightText: Copyright 2026 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#pragma once

#include "core/libraries/error_codes.h"

constexpr int ORBIS_SSL_ERROR_INVALID_ARGUMENT = 0x8095F007;
// Generic I/O failure for the read/write stubs. Exact firmware code unverified - any
// negative 0x8095Fxxx lands in a game's TLS-failure path, which is what matters: the old
// stubs returned ORBIS_OK for a write that wrote NOTHING, and GT7's downloader retried
// that lie forever (19k+ sceSslWrite calls, boot frozen at the network check - run 15).
constexpr int ORBIS_SSL_ERROR_IO_FAILED = 0x8095F00A;