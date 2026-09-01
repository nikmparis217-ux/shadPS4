# ASCII ONLY - PowerShell 5.1 reads .ps1 as ANSI and Greek comments break the parser.
#
# Restores the CDL env vars. History:
#   17 Aug 18:52 - REMOVED because INSTRUMENT_ALL_COMMANDS burned ~5 cores while the emulator
#                  compiled 182 shader modules every run.
#   17 Aug 19:1x - RESTORED because pipeline_cache_enabled=true dropped compilation to ZERO,
#                  so the CPU cost is affordable again, AND removing them brought back
#                  "Device lost during waiting for a frame" (vk_presenter.cpp:1136).
#
# CDL_OUTPUT_PATH is never touched here - the layer must always be able to dump.
# To go the other way (fast, but device lost returns), pass -Off.

param([switch]$Off)

if ($Off) {
    [Environment]::SetEnvironmentVariable('CDL_INSTRUMENT_ALL_COMMANDS', $null, 'User')
    [Environment]::SetEnvironmentVariable('CDL_TRACK_SEMAPHORES',        $null, 'User')
} else {
    [Environment]::SetEnvironmentVariable('CDL_INSTRUMENT_ALL_COMMANDS', '1', 'User')
    [Environment]::SetEnvironmentVariable('CDL_TRACK_SEMAPHORES',        '1', 'User')
}

# Read back from the registry, not from the call above
'CDL_OUTPUT_PATH','CDL_INSTRUMENT_ALL_COMMANDS','CDL_TRACK_SEMAPHORES' | ForEach-Object {
    $v = [Environment]::GetEnvironmentVariable($_, 'User')
    "{0,-30} = {1}" -f $_, $(if ($null -eq $v) { '<not set>' } else { $v })
}
Write-Host "Close the launcher COMPLETELY and reopen - env vars are inherited at process start."
