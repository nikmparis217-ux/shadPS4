// SPDX-FileCopyrightText: Copyright 2024 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#include "common/logging/log.h"
#include "core/libraries/error_codes.h"
#include "core/libraries/libs.h"
#include "device_service.h"

namespace Libraries::DeviceService {

// Invented error code, deliberately: nothing public documents libSceDeviceService. Any NEGATIVE
// return is enough to break a `while (GetEventState(...) == 0)` poll; if run 62 shows the game
// looping HARDER on a negative (i.e. it polls until the call SUCCEEDS), flip GetEventState to
// return ORBIS_OK and write a zeroed event instead. The arg values are logged for exactly that
// follow-up: they say whether the out pointer is one struct or a (type, out) pair.
constexpr s32 ORBIS_DEVICE_SERVICE_ERROR_NO_EVENT = static_cast<s32>(0x80AC0004);

s32 PS4_SYSV_ABI sceDeviceServiceInitialize(u64 arg0, u64 arg1) {
    LOG_WARNING(Lib_DeviceService, "(DUMMY) called (arg0={:#x} arg1={:#x}) - returning OK", arg0,
                arg1);
    return ORBIS_OK;
}

s32 PS4_SYSV_ABI sceDeviceServiceTerminate() {
    LOG_WARNING(Lib_DeviceService, "(DUMMY) called - returning OK");
    return ORBIS_OK;
}

s32 PS4_SYSV_ABI sceDeviceServiceGetEventState(u64 arg0, u64 arg1) {
    static int logged = 0;
    if (logged < 8) {
        ++logged;
        LOG_WARNING(Lib_DeviceService,
                    "(DUMMY) called (arg0={:#x} arg1={:#x}) - returning NO_EVENT so the update "
                    "poll can finish",
                    arg0, arg1);
    }
    return ORBIS_DEVICE_SERVICE_ERROR_NO_EVENT;
}

s32 PS4_SYSV_ABI sceDeviceServiceQueryDeviceInfo_(u64 arg0, u64 arg1, u64 arg2, u64 arg3) {
    static int logged = 0;
    if (logged < 8) {
        ++logged;
        LOG_WARNING(Lib_DeviceService,
                    "(DUMMY) called (arg0={:#x} arg1={:#x} arg2={:#x} arg3={:#x}) - returning "
                    "NO_EVENT (no devices to update)",
                    arg0, arg1, arg2, arg3);
    }
    return ORBIS_DEVICE_SERVICE_ERROR_NO_EVENT;
}

void RegisterLib(Core::Loader::SymbolsResolver* sym) {
    // The MODULE is libSceMbus, not libSceDeviceService - GT7 imports it that way
    // ("Linker: Stub resolved 9ddRUOV8Q5A ... (lib: libSceDeviceService, mod: libSceMbus)"),
    // and with the module name wrong these four NEVER BOUND: the resolver fell through to
    // the zero-returning CommonStub for every call. That zero is what the Updat thread
    // polls right before the game raises its (textless) error dialog - the whole Act 2
    // "devsvc has logged 0 calls in later runs" mystery was this one word.
    LIB_FUNCTION("84fDxStrG44", "libSceDeviceService", 1, "libSceMbus",
                 sceDeviceServiceInitialize);
    LIB_FUNCTION("Uq8uW74rVpU", "libSceDeviceService", 1, "libSceMbus",
                 sceDeviceServiceTerminate);
    LIB_FUNCTION("9ddRUOV8Q5A", "libSceDeviceService", 1, "libSceMbus",
                 sceDeviceServiceGetEventState);
    LIB_FUNCTION("UNMEa+5lrUA", "libSceDeviceService", 1, "libSceMbus",
                 sceDeviceServiceQueryDeviceInfo_);
};

} // namespace Libraries::DeviceService
