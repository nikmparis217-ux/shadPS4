# run_game.ps1 - launch ANY installed PS4 game on OUR build of shadPS4.
#
#   .\run_game.ps1                  -> lists the installed games (CUSA ids + titles)
#   .\run_game.ps1 CUSA42350        -> launches that game
#   .\run_game.ps1 patrick          -> substring match on the title works too
#
# Deliberately does NOT set any GT_* env var and does NOT start the shadNet server:
# those are GT7-specific (run_gt7.ps1 owns them). The committed fixes - the VRAM
# graveyard fix, the ReadUdSharp bounds guard, the hull-shader drop - live in the
# binary itself and apply to every title.
#
# 8.3 short paths ONLY inside this file: PowerShell 5.1 reads .ps1 files as ANSI and
# mangles the Greek username (project law, see CLAUDE.md / memory).

param(
    [string]$Game = '',
    [ValidateSet('', 'off', 'relaxed', 'precise')] [string]$Readbacks = '',
    [switch]$Dma,
    [switch]$NoFps
)

$exe   = 'C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\Build\X64-CL~1\shadps4.exe'
$games = 'C:\Users\3E30~1\Desktop\SHADPS~1.0\ps4games'
$log   = 'C:\Users\3E30~1\AppData\Roaming\shadPS4\log\shad_log.txt'

if (-not (Test-Path $exe))   { Write-Host "exe not found: $exe";   exit 1 }
if (-not (Test-Path $games)) { Write-Host "games dir not found: $games"; exit 1 }

# shadPS4 WRITES config.json when it exits, so a second instance would undo the filter we
# set below (same guard as run_gt7.ps1 - this is how a "my setting did nothing" hour starts).
$running = Get-Process shadps4 -ErrorAction SilentlyContinue
if ($running) {
    Write-Host "shadPS4 is already running - close it first (it overwrites config.json on exit):" -ForegroundColor Yellow
    $running | Select-Object ProcessName, Id | Format-Table -AutoSize
    exit 1
}

# Read each game's title out of its param.sfo (TITLE entry, UTF-8).
function Get-SfoTitle([string]$dir) {
    $sfo = Join-Path $dir 'sce_sys\param.sfo'
    if (-not (Test-Path $sfo)) { return '' }
    try {
        $bytes = [IO.File]::ReadAllBytes($sfo)
        $keyTableStart  = [BitConverter]::ToUInt32($bytes, 8)
        $dataTableStart = [BitConverter]::ToUInt32($bytes, 12)
        $count          = [BitConverter]::ToUInt32($bytes, 16)
        for ($i = 0; $i -lt $count; $i++) {
            $e = 20 + 16 * $i
            $keyOff  = [BitConverter]::ToUInt16($bytes, $e)
            $dataLen = [BitConverter]::ToUInt32($bytes, $e + 4)
            $dataOff = [BitConverter]::ToUInt32($bytes, $e + 12)
            $k = $keyTableStart + $keyOff
            $keyEnd = $k
            while ($bytes[$keyEnd] -ne 0) { $keyEnd++ }
            $key = [Text.Encoding]::ASCII.GetString($bytes, $k, $keyEnd - $k)
            if ($key -eq 'TITLE') {
                $t = [Text.Encoding]::UTF8.GetString($bytes, $dataTableStart + $dataOff, $dataLen)
                return $t.TrimEnd([char]0)
            }
        }
    } catch { }
    return ''
}

$installed = @()
Get-ChildItem -Directory $games | Where-Object { Test-Path (Join-Path $_.FullName 'eboot.bin') } | ForEach-Object {
    $installed += [pscustomobject]@{ Id = $_.Name; Title = (Get-SfoTitle $_.FullName); Eboot = (Join-Path $_.FullName 'eboot.bin') }
}

if ($Game -eq '') {
    Write-Host "Installed games in $games :"
    $installed | ForEach-Object { Write-Host ("  {0}  {1}" -f $_.Id, $_.Title) }
    Write-Host ""
    Write-Host "Launch one:  .\run_game.ps1 <CUSAxxxxx | part of the title>"
    exit 0
}

$pick = $installed | Where-Object { $_.Id -ieq $Game }
if (-not $pick) { $pick = $installed | Where-Object { $_.Id -ilike "*$Game*" -or $_.Title -ilike "*$Game*" } }
if (-not $pick) { Write-Host "no installed game matches '$Game'"; exit 1 }
if (@($pick).Count -gt 1) {
    Write-Host "'$Game' matches more than one:"
    $pick | ForEach-Object { Write-Host ("  {0}  {1}" -f $_.Id, $_.Title) }
    exit 1
}

# The log filter in config.json is whatever the LAST run left there, and run_gt7.ps1 leaves a
# GT7-tuned one that contains "Lib.Pad:off" (GT7 polls the pad every frame and buries the log).
# Inherited by another game that is a: a controller problem becomes invisible - the pad calls
# simply are not printed, which reads exactly like a game that never asks for input. So a
# non-GT7 run states its own filter: everything at info, pads VISIBLE, and the two classes
# that are pure volume turned down.
$cfgPath = 'C:\Users\3E30~1\AppData\Roaming\shadPS4\config.json'
if (Test-Path $cfgPath) {
    $j = Get-Content $cfgPath -Raw | ConvertFrom-Json
    $j.Log.filter = '*:info Kernel.Vmm:off Lib.GnmDriver:warning Kernel.Event:warning'

    # The fps counter is the one measurement that tells "black screen because it renders
    # nothing" apart from "black screen because it renders at 0.2 fps" - two problems with
    # opposite fixes. It costs nothing, so a general run always has it unless refused.
    if (-not $NoFps) { $j.General.show_fps_counter = $true }

    if ($Readbacks -ne '') {
        $mode = @{ 'off' = 0; 'relaxed' = 1; 'precise' = 2 }[$Readbacks]
        $j.GPU.readbacks_mode = $mode
        Write-Host ("readbacks = {0} ({1})" -f $Readbacks, $mode)
    }
    if ($PSBoundParameters.ContainsKey('Dma')) { $j.GPU.direct_memory_access_enabled = [bool]$Dma }

    $j | ConvertTo-Json -Depth 20 | Set-Content $cfgPath -Encoding UTF8
    Write-Host ("log filter set for a general run (Lib.Pad visible), fps counter {0}" -f (&{ if ($NoFps) {'off'} else {'ON'} }))
}

Write-Host ("launching {0}  {1}" -f $pick.Id, $pick.Title)
Write-Host ("log: {0}" -f $log)
& $exe $pick.Eboot
$code = $LASTEXITCODE
Write-Host ("exited with code {0}  (3 = emulator died, 5 = crash dump written, 0 = you quit)" -f $code)
exit $code
