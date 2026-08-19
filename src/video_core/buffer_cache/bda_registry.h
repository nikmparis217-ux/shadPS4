// SPDX-FileCopyrightText: Copyright 2026 shadPS4 Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#pragma once

#include <string>
#include "common/types.h"

namespace VideoCore {

// A process-wide map of every live VkBuffer's device-address range (buffers created with
// eShaderDeviceAddress - which in this project is every buffer-cache buffer, the BDA
// pagetable and the fault buffer). It exists for ONE consumer: the VK_EXT_device_fault
// handler in vk_instance.cpp, which until now printed raw GPU addresses nothing could be
// joined against (runs 83/84/86: "WriteInvalid 0x3fa37f000" with no way to name the buffer).
// Registration happens in Buffer's constructor, removal in ~UniqueBuffer - the object that
// actually owns the VkBuffer's lifetime, including cache-deferred deletions.

void RegisterBdaRange(u64 bda_addr, u64 size, VAddr guest_addr);
void UnregisterBdaRange(u64 bda_addr);

// For a faulting device address: name the containing buffer if any, else the nearest
// neighbours on both sides, each with its guest range and the delta from the fault.
// Returns one preformatted line per finding, ready for LOG_CRITICAL.
std::string DescribeBdaAddressForFault(u64 device_addr);

} // namespace VideoCore
