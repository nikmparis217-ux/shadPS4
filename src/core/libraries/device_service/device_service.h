// SPDX-FileCopyrightText: Copyright 2024 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#pragma once

#include "common/types.h"

namespace Core::Loader {
class SymbolsResolver;
}

namespace Libraries::DeviceService {

// libSceDeviceService: system service for peripheral device (firmware) updates. GT7's "Updat"
// thread polls it at the "Welcome to Gran Turismo 7" screen; with the aerolib stub returning 0
// and never touching the out params, the game polled sceDeviceServiceGetEventState forever and
// the whole boot froze on that dialog (runs 59-61). The semantics below are the MINIMAL guess
// that lets a poll loop conclude: "service is up, there are no device events, no devices need
// an update". If the game keeps looping, invert the GetEventState experiment (see the .cpp).

s32 PS4_SYSV_ABI sceDeviceServiceInitialize(u64 arg0, u64 arg1);
s32 PS4_SYSV_ABI sceDeviceServiceTerminate();
s32 PS4_SYSV_ABI sceDeviceServiceGetEventState(u64 arg0, u64 arg1);
s32 PS4_SYSV_ABI sceDeviceServiceQueryDeviceInfo_(u64 arg0, u64 arg1, u64 arg2, u64 arg3);

void RegisterLib(Core::Loader::SymbolsResolver* sym);

} // namespace Libraries::DeviceService
