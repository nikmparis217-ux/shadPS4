# Reads shadPS4's device_fault.bin with Nsight's CLI - no GUI, no clicking.
#
# TRAP: the file is the RAW VK_EXT_device_fault vendor blob, so it starts with a
# VkDeviceFaultVendorBinaryHeaderVersionOneEXT (headerSize is its first u32 - 56 bytes on
# this driver). nv-aftermath-format rejects it as "not a valid nv-gpudmp file" until those
# bytes are stripped AND the copy is named .nv-gpudmp.
param(
    [string]$Bin  = "$env:APPDATA\shadPS4\log\device_fault.bin",
    [string]$Out  = "$PSScriptRoot\logs\fault_latest.txt",
    [switch]$Json
)
$ngfx = "C:\Program Files\NVIDIA Corporation\Nsight Graphics 2026.3.1\host\windows-desktop-nomad-x64\nv-aftermath-format.exe"
if (-not (Test-Path $Bin))  { Write-Host "no dump at $Bin"; exit 1 }
if (-not (Test-Path $ngfx)) { Write-Host "Nsight CLI not found: $ngfx"; exit 1 }

$bytes  = [System.IO.File]::ReadAllBytes($Bin)
$hdr    = [System.BitConverter]::ToUInt32($bytes, 0)      # headerSize, per the Vulkan spec
$dump   = Join-Path $env:TEMP "shadps4_fault.nv-gpudmp"
[System.IO.File]::WriteAllBytes($dump, $bytes[$hdr..($bytes.Length - 1)])
Write-Host ("dump {0:N0} bytes, stripped a {1}-byte vendor header" -f $bytes.Length, $hdr)

$args = @($dump); if ($Json) { $args = @("--json") + $args }
& $ngfx @args | Tee-Object -FilePath $Out
Write-Host "`nwritten to $Out"
