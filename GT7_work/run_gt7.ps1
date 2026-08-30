# ASCII ONLY + 8.3 SHORT PATHS - the user name is Greek; PowerShell 5.1 reads .ps1 as ANSI and
# mangles it, and the mangled path then does not exist. Never put the real path in this file.
#
# WHY THIS EXISTS (17 Aug):
#   shadPS4QtLauncher OVERWRITES %APPDATA%\shadPS4\config.json at the moment it spawns the game,
#   from its OWN settings model - proven by timestamps: config.json written 18:40:29, game started
#   18:40:29, launcher started 18:40:25 (i.e. AFTER the config was edited at 18:37, so it had read
#   the new values and wrote defaults anyway). Every diagnostic written into config.json was
#   silently reverted before the emulator ever read it, twice.
#
# So this bypasses the launcher: writes the diagnostics, then starts the emulator directly.
#
#   .\run_gt7.ps1              log filter + NO Vulkan layers  <- device-fault run, no perturbation
#   .\run_gt7.ps1 -Sync        + synchronization validation (races / missing barriers)
#   .\run_gt7.ps1 -GpuAV       + GPU-assisted validation (out-of-bounds in shaders; VERY slow)
#   .\run_gt7.ps1 -Plain       known-good, no diagnostics at all
#   .\run_gt7.ps1 -Net         local PSN: starts psn_local\shadnet_local_server.py, points
#                              shadNet at 127.0.0.1:31313, marks the network connected ->
#                              the game boots SIGNED IN (use GT7_PSN.bat). Default runs
#                              force these OFF so the device-lost hunt keeps its baseline.
#   .\run_gt7.ps1 -WhatIfOnly  write the config, do not launch
#
# !! BUG FIXED 17 Aug 19:5x - THIS SCRIPT NEVER WROTE `vkvalidation_enabled`.
# That key is the MASTER: it is the only thing that puts VK_LAYER_KHRONOS_validation into the
# instance layer list (vk_platform.cpp:236 <- vk_presenter.cpp:498). The sub-keys
# vkvalidation_core/sync/gpu_enabled only CONFIGURE the layer (vk_platform.cpp:305-307); they
# cannot load it. So runs 17 and 18 set sync=true / gpu=true, the layer was never loaded, and both
# "ZERO findings" results were the silence of an absent layer - proven by the emulator's own boot
# lines in both logs: "Vulkan vkValidation: false".
# And the script printed "sync valid. = True", i.e. it verified the value it had just written
# instead of the one that decides anything. Same family as "never judge a build by its exit code".

param([switch]$Plain, [switch]$WhatIfOnly, [switch]$CDL, [switch]$GpuAV, [switch]$Sync,
      [switch]$DumpShaders, [switch]$Net, [switch]$Offline, [switch]$Dma)

function Set-GtDefault([string]$name, [string]$value) {
if (-not (Test-Path ("env:" + $name))) { Set-Item -Path ("env:" + $name) -Value $value }
}


$exe  = 'C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\Build\X64-CL~1\shadps4.exe'
$game = 'C:\Users\3E30~1\Desktop\SHADPS~1.0\ps4games\CUSA24~1\eboot.bin'
$cfg  = 'C:\Users\3E30~1\AppData\Roaming\shadPS4\CONFIG~1.JSO'
$log  = 'C:\Users\3E30~1\AppData\Roaming\shadPS4\log\shad_log.txt'

foreach ($p in @($exe, $game, $cfg)) {
    if (-not (Test-Path $p)) { Write-Host "MISSING: $p" -ForegroundColor Red; exit 1 }
}

$running = Get-Process | Where-Object { $_.ProcessName -match 'shadps4|shadPS4QtLauncher' }
if ($running) {
    Write-Host "Close these first (they will overwrite config.json):" -ForegroundColor Yellow
    $running | Select-Object ProcessName, Id | Format-Table -AutoSize
    exit 1
}

# TRIPWIRE (25 Aug): config.json once grew to 2.14 GB - a non-ASCII install_dirs path
# ("Nikos" in Greek) was re-encoded slightly worse by SOME writer on every run, roughly
# doubling per cycle, until Get-Content -Raw died with OutOfMemoryException and the run
# script silently stopped working ("it dont run"). The repair made the config pure ASCII
# (8.3 path), which starves the loop - but the mangling WRITER was never identified, so
# if any path with non-ASCII characters ever gets back in, this catches cycle #1 loudly
# instead of cycle #30 killing the tooling.
$cfgSize = (Get-Item $cfg).Length
if ($cfgSize -gt 5MB) {
    Write-Host "config.json is $([math]::Round($cfgSize/1MB)) MB - the mojibake growth loop is back." -ForegroundColor Red
    Write-Host "Fix: replace the non-ASCII path in install_dirs with its 8.3 form (see" -ForegroundColor Red
    Write-Host "HANDOFF_RENDERING_ACT2.md Act 11 addendum). Refusing to run on a corrupt config." -ForegroundColor Red
    exit 1
}

# Silence the two classes that are 90% of the log, raise the ones that can explain a spin-wait,
# and raise the network/NP classes because GT7 is always-online and INITIALIZING is where the
# real console talks to Polyphony. Syntax from log.cpp:285 - "Class:level" separated by SPACES.
# Kernel.Vmm went :info for run 89 only and ANSWERED its question: GT7 grows its heap by
# serial 2 MB sceKernelMapNamedDirectMemory blocks (0x203800000, 0x203a00000, ...), and the
# run-88 guest write AV at 0x205bffffc was the LAST DWORD of such a block - torn-tracking
# family, not a mapping hole. Vmm logging is also a real per-allocation I/O tax the user
# felt as "slow", so it is back OFF.
# Lib.SaveData raised to debug (run 107): GT7 saves through SaveDataMemory (the 32 MiB
# memory.dat) and that file has been FROZEN SINCE AUG 13 - no save has persisted across
# six days of play, the user re-runs initial setup every session, and the recurring
# textless error dialog + the post-dialog crash live on the save path. Every sceSaveData*
# call in this HLE logs at DEBUG, so at *:info the whole subsystem was invisible.
$filter = '*:info Kernel.Vmm:off Lib.Pad:off Kernel.Pthread:debug Lib.Kernel:debug ' +
          'Kernel.Event:debug Lib.GnmDriver:debug Lib.Net:debug Lib.NetCtl:debug ' +
          'Lib.NpManager:debug Lib.Ssl:debug Lib.SaveData:debug'

$j = Get-Content $cfg -Raw | ConvertFrom-Json
if ($Plain) { $j.Log.filter = '' } else { $j.Log.filter = $filter }

# A validation layer adds synchronization, exactly like the CDL layer did - and the CDL layer made
# "Device lost" DISAPPEAR. So a layer is never on by default: the default run is the one that can
# still reproduce the device loss, now that VK_EXT_device_fault explains it without perturbing
# anything (the driver fills in nothing until the device is actually lost).
$wantSync = $Sync  -and -not $Plain
$wantGpu  = $GpuAV -and -not $Plain
$j.Vulkan.vkvalidation_enabled      = ($wantSync -or $wantGpu)   # THE MASTER - see header
$j.Vulkan.vkvalidation_sync_enabled = $wantSync
$j.Vulkan.vkvalidation_gpu_enabled  = $wantGpu
# pipeline cache: RETRIAL since run 92 (user pivot to fps/graphics). The "true made it die
# much earlier" verdict is from the device-lost era - the same era whose DMA and stub
# verdicts were both overturned this week. With the cache ON, a session skips recompiling
# the ~2000 shaders it already met, which is the single biggest in-play stutter source.
# If early deaths return, flip back to $false and note WHICH crash - do not just revert.
# OFF for run 98 ONLY: a warm cache skips CompileModule entirely, so a GT_STUB_SHADERS
# substitution test NEVER APPLIES to already-cached pipelines (run 97 proved it: stub listed,
# 0 substitutions, fault unchanged - an INVALID test, not an acquittal). Flip back to $true
# after the substitution question is answered.
# ...but NOT under GPU-assisted validation: run 102 hard-aborted (exit 255, 267 log lines,
# no crash record) instrumenting the whole warm cache's preload at once. GpuAV runs are
# diagnostic one-offs; they compile what they touch.
$j.Vulkan.pipeline_cache_enabled = (-not $wantGpu)

# Shader dumping is a CPU-side file write at COMPILE time - it does not change what the GPU
# executes, so unlike a validation layer it cannot hide the device lost. Dumps land in
# <user>\shader\dumps and shadPS4 will read a replacement back out of <user>\shader\patch,
# which is how a suspect shader gets tested by substitution (vk_pipeline_cache.cpp:723,740).
if ($null -ne $j.GPU) { $j.GPU.dump_shaders = [bool]$DumpShaders }

# DIRECT MEMORY ACCESS: OFF EVERYWHERE (18 Aug, after runs 37-40 + 5 probes). DMA is the
# semantically correct fix for the producer shaders' dynamic ReadConst (they read flatbuf[0]
# garbage without it) - but with DMA ON, GT7's BOOT crashes 7 runs out of 9 (FWRKR guest
# thread reads null, IP ~0x..273d) regardless of fence deferral or the vegas hosts entry
# (every one of those theories was tested and died). Suspect: shadPS4's DMA fault handler
# racing guest CPU reads. Until that is understood, DMA stays off and the 19x-compile zone
# remains a ~50% coin flip per attempt (garbage-fed producer dispatches sometimes park).
# RETRY THE RUN when it device-losts around 19x compiles - it passes every other try.
# 19 Aug postscript: those boot crashes predate the gt.idx FILE-SHARING fix (the real boot
# killer) - that DMA verdict is CONTAMINATED and the handoff prescribes a retrial.
# -Dma = the retrial: DMA on AND GT_BINDLESS_LOWER=1, so an untrackable bindless
# ReadConstBuffer lowers to a GPU-time BDA read instead of stubbing the whole shader.
if ($null -ne $j.GPU) { $j.GPU.direct_memory_access_enabled = [bool]$Dma }
# GT_BINDLESS_LOWER moved to the -Net env block (19 Aug, run 74 verdict): the lowering
# is now SELECTIVE-DMA - the lowered reads carry their own flag bit and only those
# shaders pay the BDA cost, so it no longer needs (or wants) the global DMA setting.
# -Dma stays as the pure global-DMA experiment: it BOOTS AND PLAYS (run 74 killed the
# old contaminated crash verdict) but is unplayably slow - the rasterizer re-syncs all
# mapped ranges on the CPU for every draw whose stage has any ReadConst.

# CDL (LunarG Crash Diagnostic Layer) is OFF by default now. Three measured reasons:
#  1. It has NEVER produced a dump - 0 files in CDL_OUTPUT_PATH across runs 10, 11, 13.
#  2. run11 disproved the idea that it hides the device lost: with the layer loaded AND
#     instrumentation restored, "Device lost during waiting for a frame" happened anyway.
#  3. Launched from a .bat there is a CONSOLE attached, and the layer floods it with thousands of
#     lines per second ("Completed sequence number has impossible value: -1 submitted: 28848").
#     Console writes on Windows are slow and synchronous, so the diagnostic was distorting the
#     very CPU measurements it was there to inform. The QtLauncher had no console, so this
#     confound was introduced by the direct-launch script.
# Pass -CDL to turn it back on when a dump is actually wanted.
$j.Vulkan.vkcrash_diagnostic_enabled = [bool]$CDL

# --- PSN / shadNet, 18 Aug (-Net) -----------------------------------------------------------
# GT7 shows the PSN error because sceNpGetState answers SignedOut and netctl answers
# DISCONNECTED. The emulator carries a complete fake-PSN CLIENT ("shadNet", the RPCN
# analog) - it only lacks a server. psn_local\shadnet_local_server.py IS that server, on
# 127.0.0.1:31313: the emulator logs in to it at boot and every NP call flips to SignedIn.
# No emulator code was touched.
#   -Net     : point shadNet at the local server, mark the network connected, enable the
#              shadNet user (users.json), start the server if it is not already listening.
#   default  : both flags forced FALSE - the device-lost hunt keeps its exact baseline and
#              can never inherit network state left over from a -Net run.
# GOTCHA: shadnet_server EMPTY makes the probe fail SILENTLY and everything stays SignedOut
# with the very same "shadNet disabled" log line - the server address must be set too.
$users = 'C:\Users\3E30~1\AppData\Roaming\shadPS4\users.json'
if ($Net) {
    $j.General.shad_net_enabled      = $true
    $j.General.connected_to_network  = $true
    $j.General.shadnet_server        = '127.0.0.1:31313'
    $j.General.shadnet_webapi_server = 'http://127.0.0.1:31315'   # keep NP WebAPI local too
} else {
    $j.General.shad_net_enabled      = $false
    $j.General.connected_to_network  = $false
}
if (Test-Path $users) {
    # users.json has NO BOM (checked 18 Aug) - write ASCII, not PS5.1's BOM-ed UTF8.
    # ConnectUserById REQUIRES non-empty npid AND password or it skips the user silently.
    $uj = Get-Content $users -Raw | ConvertFrom-Json
    $u1 = $uj.Users.user | Where-Object { $_.user_id -eq 1000 }
    if ($u1) {
        $u1.shadnet_enabled = [bool]$Net
        if ($Net -and -not $u1.shadnet_npid)     { $u1.shadnet_npid     = 'Nikos' }
        if ($Net -and -not $u1.shadnet_password) { $u1.shadnet_password = 'local' }
        $uj | ConvertTo-Json -Depth 10 | Set-Content $users -Encoding ASCII
    } else {
        Write-Host "users.json: user_id 1000 not found - shadNet login will not happen" -ForegroundColor Red
    }
}

$j | ConvertTo-Json -Depth 10 | Set-Content $cfg -Encoding UTF8

# Read back from disk - a write that "succeeded" is not a value that landed
$v = Get-Content $cfg -Raw | ConvertFrom-Json
$master = [bool]$v.Vulkan.vkvalidation_enabled
Write-Host ("filter        = '" + $v.Log.filter + "'")
Write-Host ("VALIDATION LAYER = " + $master + "   <- the master; without it the next two do NOTHING")
Write-Host ("  sync valid.    = " + $v.Vulkan.vkvalidation_sync_enabled + "   (-Sync)")
Write-Host ("  core valid.    = " + $v.Vulkan.vkvalidation_core_enabled)
Write-Host ("  GPU-assisted   = " + $v.Vulkan.vkvalidation_gpu_enabled + "   (-GpuAV; VERY slow)")
Write-Host ("pipeline cache= " + $v.Vulkan.pipeline_cache_enabled)
Write-Host ("CDL layer     = " + $v.Vulkan.vkcrash_diagnostic_enabled + "   (-CDL to enable)")
Write-Host ("dump shaders  = " + $v.GPU.dump_shaders + "   (-DumpShaders; does NOT perturb the GPU)")
Write-Host ("PSN/shadNet   = " + $v.General.shad_net_enabled + ", network = " + $v.General.connected_to_network + ", server = '" + $v.General.shadnet_server + "'   (-Net)")
if (-not $master -and ($v.Vulkan.vkvalidation_sync_enabled -or $v.Vulkan.vkvalidation_gpu_enabled)) {
    Write-Host "WARNING: a sub-key is on while the master is off - those settings are INERT." -ForegroundColor Yellow
}
if ($master) {
    Write-Host "NOTE: the layer adds synchronization and may HIDE the device lost (CDL did)." -ForegroundColor Yellow
}

if ($WhatIfOnly) { Write-Host "config written, not launching."; exit 0 }

# --- local shadNet server autostart (-Net) --------------------------------------------------
# The emulator probes the server SYNCHRONOUSLY during boot (NpHandler::Initialize), so the
# server must be listening BEFORE the exe starts. If the port already answers, an instance
# is running (the server itself exits quietly on a busy port) - reuse it.
if ($Net) {
    $psnSrv = 'C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\psn_local\shadnet_local_server.py'
    $listening = $false
    try {
        $tc = New-Object Net.Sockets.TcpClient
        $iar = $tc.BeginConnect('127.0.0.1', 31313, $null, $null)
        if ($iar.AsyncWaitHandle.WaitOne(300) -and $tc.Connected) { $listening = $true }
        $tc.Close()
    } catch {}
    if (-not $listening) {
        if (-not (Test-Path $psnSrv)) { Write-Host "MISSING: $psnSrv" -ForegroundColor Red; exit 1 }
        Start-Process -WindowStyle Hidden -FilePath 'python' -ArgumentList ('"' + $psnSrv + '"')
        for ($i = 0; $i -lt 30 -and -not $listening; $i++) {
            Start-Sleep -Milliseconds 100
            try {
                $tc = New-Object Net.Sockets.TcpClient
                $iar = $tc.BeginConnect('127.0.0.1', 31313, $null, $null)
                if ($iar.AsyncWaitHandle.WaitOne(200) -and $tc.Connected) { $listening = $true }
                $tc.Close()
            } catch {}
        }
    }
    if ($listening) { Write-Host "shadNet local server: LISTENING on 127.0.0.1:31313" -ForegroundColor Green }
    else { Write-Host "shadNet local server DID NOT START - the game will boot SignedOut" -ForegroundColor Red }
}

# GT_SPLIT_DISPATCH: submit after every Nth dispatch so each gets its OWN timeline tick, which
# shrinks the device-fault census from "a whole 6400-entry command buffer" to "the ~dozen entries
# between two dispatches". The env var is read by DispatchDirect/DispatchIndirect in
# vk_rasterizer.cpp; hundreds of extra submits a frame is real overhead, so remove this line the
# moment it has answered its question.
# THE N-SCAN. What is known: split-every-1 PASSES the wall, a full memory barrier per dispatch
# (same single submission) does NOT - so the cure is something the SUBMIT does, not visibility of
# compute writes. Two candidates survive, and N separates them:
#   - the hung buffer is too big for one uninterrupted submission (TDR/preemption story), or the
#     host-side work a submit triggers (label writes, download processing) must happen mid-buffer
#     because the GAME builds later commands from GPU results it reads back;
#   - one SPECIFIC pair of dispatches must land in different submissions.
# Passing at a large N says the exact boundary does not matter (points to the first family);
# hanging at a large N and passing at a small one brackets a critical distance.
# A completely unsplit buffer reached 9,276 recorded operations in run 174 and TDR'd.
# N=1 is the stable diagnostic but expensive; run 176 passed both prior walls at N=64.
Set-GtDefault 'GT_SPLIT_DISPATCH' '64'
$env:GT_DISPATCH_BARRIER = '0'
# THE ROOT-CAUSE CANDIDATE, alone. EOP/EOS fences used to be signed at PARSE time - the game was
# told "the GPU finished" about work not yet handed to the driver, recycled its memory, and the
# real work read the recycled bytes. This defers the fence to the real GPU tick. NO splitting, NO
# barriers: if the wall falls with only this, the mechanism is proven.
$env:GT_DEFER_EOP = '1'
# GT_STORE_CLAMP is a shader correctness guard, not a network-mode experiment. Runs
# 139/147/149 traced device faults to cs_6421a7b6 using stale SRT data as an unchecked
# storage-buffer index. Keep it enabled for baseline, offline, and local-PSN runs alike.
Set-GtDefault 'GT_STORE_CLAMP' '1'
# -Net env (18 Aug, evening): HONEST FENCES, NO SPLIT.
#   GT_DEFER_EOP=1 now defers gfx EOP/EOS *AND* the compute queues' ReleaseMem fences (the
#   half-finished step from the handoff). This is the root-cause experiment: run 29 was
#   SPLIT=0 + gfx-only deferral and died at 97; this run differs by exactly ONE variable -
#   the ReleaseMem deferral. PASSING the 182-wall here proves the eager-fence hypothesis
#   and drops the split-per-dispatch overhead (hundreds of extra submits/frame = FPS).
#   If it hangs at/before the wall: set SPLIT=1/DEFER=0 back (the run-26 config that passes
#   the wall probabilistically) and the hypothesis is dead.
# GT_BINDLESS_STUB=1: GT7's GPU-driven compute reads descriptors through dynamically indexed
#   buffers (bindless) - untrackable, used to UNREACHABLE at compile #203 (death at track
#   load). The stub swaps a NO-OP module instead; the log names every stubbed hash
#   ("substituting a NO-OP module"). Default runs keep the old fatal behavior.
# THE SURVIVING COMBINATION (18 Aug, probes A/B after runs 32-39):
#   SPLIT=1        polling shaders never starve waiting for a deferred signal (no deadlock)
#   DEFER_EOP=1    honest gfx frame fences - the settings checkerboards rendered correctly
#                  the moment this went in (user-verified visual fix)
#   DEFER_RELEASEMEM=0  ⚠ deferring ASC fences WITH DMA crashes GT7's boot 4/4 (FWRKR
#                  null-read); each alone boots. Split switches; eager ASC + DMA is fine.
#   DMA=true       (config, set above) the GPU-driven producer shaders read REAL guest
#                  memory instead of flatbuf[0] garbage - kills the 19x-compile hang at
#                  the root instead of stubbing producers (run 35 proved stubs starve
#                  their consumers -> BindBuffers assert)
#   BINDLESS_STUB=1  cs_0xa95f906e (compile #203) is untranslatable - no-op module
# 18 Aug, evening: HONEST FENCES ARE BACK ON for -Net. The FWRKR boot crash that forced them
# off was PROVEN UNRELATED (guest opened /app0/contents/gt.idx from two threads; the emulator's
# _SH_DENYWR default failed the second open EACCES; fixed in host_fs.cpp with ShareReadWrite -
# run 46: 0 open failures, boot clean). The 195-wall's hung dispatch was then NAMED by the live
# stall dump: cs_0xda05e7f8, one dispatch parked among thousands of identical successes = a
# race, exactly the recycled-memory story eager fences create. SPLIT=1 + BOTH defers + no stubs
# is the one config cell never tried (run 35's version had producer stubs, whose CPU assert
# died first and never hung).
# -Offline (24 Aug, run 134): the -Net ENV block WITHOUT the network. Runs 133/134 froze at
# the main-game load polling Np/NetCtl forever - the fake PSN says "online" so GT7 commits to
# its game-server sync (Vegas/portal.gt7) which can never complete here, and it never takes
# the offline branch (the cold runs passed only by timing). A plain no-switch run is NOT the
# A/B: several vars below are COMPILE-AFFECTING (BINDLESS_STUB/LOWER/IMG/IMGARRAY,
# DYNRC_WINDOW), so dropping them would invalidate the warm cache (run-117 law). -Offline
# keeps codegen byte-identical and flips ONLY the JSON network flags to signed-out.
if ($Net -or $Offline) {
    # N=1 was the device-hang isolation mode and submits after every compute dispatch. It
    # answered that question, but its hundreds of extra queue submissions per frame caused the
    # persistent 4-10 FPS and audio slowdown during normal GT7 testing. Honor the caller or the
    # stable N=64 default above instead.
    $env:GT_DEFER_EOP = '1'
    $env:GT_DEFER_RELEASEMEM = '1'
    $env:GT_BINDLESS_STUB = '1'
    # GT_STALL_DUMP: dump the work journal the moment the GPU stalls (completed tick frozen
    # >700 ms with >256 submits piled up) instead of at device-lost time, when the rings have
    # wrapped and the hung work cannot be named. Read-only diagnostic - the run continues.
    $env:GT_STALL_DUMP = '1'
    # GT_IMG_TRACE: one log line per image binding of the traced shaders, joined to the
    # stall dump by journal seq - names the exact image the parked dispatch was touching.
    # OFF since run 87 (72,171 CRITICAL lines in run 86 - the log-spam trap on record).
    # RE-ARMED for the RUN-125 data-problem campaign: the hash filter now also covers the two
    # WINDOWED consumers (0xa95f906e red map / 0x3e50e1 post-FX), which were untraceable while
    # only the producers were listed. Comment out again when the data question closes.
    # '0' since 25 Aug night: its diagnostic job is done (the user correlated the wash
    # episodes with cs_da05e7f8's bursts LIVE, using exactly these lines) and at ~20
    # Critical lines per probe-rebake dispatch it wrote ~90k log lines in one session -
    # a real fps drag. Re-arm per run from the shell when an image question needs it.
    Set-GtDefault 'GT_IMG_TRACE' '0'
    # GT_DYNRC_GPU (RUN-125 campaign, experiment - default OFF): route the WINDOWED dynamic
    # ReadConsts through the GPU-time read_const_dynamic (BDA walk) instead of the walker's
    # record-time flatbuf snapshot, WITHOUT global DMA - only window-carrying shaders (the ~3
    # producers) pay the per-draw re-sync. The A/B for "the producers compute from stale
    # windows". ⚠ COMPILE-AFFECTING: flipping it needs a cache wipe (run-117 law).
    Set-GtDefault 'GT_DYNRC_GPU' '0'
    # GT_SOFT_CLAMP: a torn GPU-driven descriptor (unmapped V#/T#) null-binds for one frame with
    # a [softclamp] log line instead of killing the process (run 49: ClampRangeSize assert, 0x24).
    $env:GT_SOFT_CLAMP = '1'
    # GT_BUFFER_GC: upstream's BufferCache::RunGarbageCollector defines its clean_up lambda and
    # never calls it - the buffer GC has NEVER freed a buffer, so GT7's streaming fills VRAM until
    # vmaCreateBuffer (WITHIN_BUDGET_BIT) refuses = the ErrorOutOfDeviceMemory at ~650 compiles
    # (runs 55/56, both at the controller-selection screen). '1' wires the missing
    # ForEachItemBelow call. Log proof: "[buffergc] freed N stale buffer(s)".
    # ⚠ A/B EXPERIMENT (run 64): GC OFF. The draw-scheduler device losts started on run 60 -
    # the first run with the buffer GC live - and DeleteBuffer gates the erase on the DRAW
    # scheduler's tick only, while present/flip cmdbufs can still reference the buffer (the
    # journal's own cross-queue warning). If run 64 reaches the welcome WITHOUT a device lost,
    # the GC's cross-queue use-after-free is the killer and the fix is gating on all three
    # semaphores. THAT FIX EXISTS NOW (run 100+): DeleteBuffer queues into pending_deaths
    # with a snapshot of ALL timelines and ProcessPendingDeaths erases only once every one
    # has passed - so the GC is ON BY DEFAULT (unset = on). Set '0' to opt back out if a
    # use-after-free family returns (validation VUID-vkDestroyBuffer lines name it).
    # $env:GT_BUFFER_GC = '0'
    # GT_STUB_SHADERS: comma list of program hashes force-substituted with NO-OP modules.
    # 0xacec97cd = the windowed fs material that parked the DRAW scheduler in run 60 (4 normal
    # DrawIndexed calls, then device lost). One missing material beats a dead device.
    # + 78bfb00e: the SECOND fs that parked the draw scheduler (run 61, counts 420x1 - a tiny
    # draw, so the hang is a loop in the shader on wrong data, not draw size).
    # EMPTY since run 90 (user report: whole scene washed white + solid red preview RT).
    # Both stubs were fs suspected of parking the draw scheduler in runs 60/61 - but the
    # buffer GC was later proven to be that killer (run 64 A/B), so the handoff queued
    # exactly this retrial. A missing fs pass IS a washed screen; put them back if the
    # draw scheduler parks again (the run-60/61 signature: a handful of DrawIndexed then
    # device lost naming an innocent shader).
    # run 97 SUBSTITUTION TEST: with the pipeline cache warm, runs 95/96 die at a
    # BYTE-IDENTICAL fault (IP 0x2000f1330, ReadInvalid 0x300100000 - attributed by the BDA
    # registry to NO live buffer) with cs_da05e7f8 in flight - the GPU-driven producer whose
    # mip-fallback descriptor array is indexed by flatbuf[29]. Stub it for ONE run: fault
    # gone = guilty named; fault stays = the set is innocent. Then EMPTY this again.
    # run 98 VERDICT: stubbing da05e7f8 removed the deterministic ReadInvalid pair (guilty)
    # but resurfaced the OLD parked-IP hang family - it is the PRODUCER, its consumers hang
    # on unfed data, so it must RUN. The real defect (unclamped DynamicIndex mip descriptor
    # read) is now clamped in emit_spirv_image.cpp. Stubs empty again.
    Set-GtDefault 'GT_STUB_SHADERS' ''
    # GT_TEX_GC A/B verdict (run 101): the ReadInvalid 0x300100000 SURVIVED with the
    # texture GC off - image deletion is INNOCENT of that fault. The gate stays available
    # ('0' = off) but unset = on, the correct long-term state.
    # GT_BINDLESS_LOWER=1 (19 Aug): an untrackable bindless ReadConstBuffer becomes a
    # GPU-time BDA read (SrtBindlessFlagBit) instead of stubbing the whole shader.
    # Run 74 (global DMA) proved the mechanism: vs_0x2df86cf8 compiled fully and 109
    # loads lowered across the stubbed set. Selective since run 75: global DMA off,
    # only the bindless shaders carry the pagetable/fault machinery.
    # GT_ENV_OVERRIDE (19 Aug): a value already set in the parent shell WINS. Same family as
    # the vkvalidation bug at the top of this file - an A/B the script silently overwrites is
    # an experiment that never happened. Set the variable, then run this.

    Set-GtDefault 'GT_BINDLESS_LOWER' '1'
    # GT_BINDLESS_IMG / GT_BINDLESS_STORES: back ON since run 88. The bisect that turned
    # them off blamed them for the boot device-faults of runs 83/84 - but the morning-after
    # postmortem found the REAL cause in all three fatal runs (83/84/86): a torn V# with
    # base 0x24 -> CreateBuffer dummy at cpu_addr 0x4000 -> Buffer::Offset u32 UNDERFLOW ->
    # a ~4 GiB descriptor offset on a 16 KiB buffer = the IP+WriteInvalid family. Run 86
    # even reproduced it with ZERO bindless shaders compiled, exonerating the whole feature.
    # The chain is now cut in BindBuffers (guest floor/ceiling null-bind + backing-size
    # descriptor clamp), and run 87 (loads-only, 290k lines, 2.6x longer than any fatal run)
    # had ZERO device faults. Also note: STORES=0 silently NO-OPs every shader that carries
    # a bindless store (has_bindless_sharp -> whole-module stub) - loads-only was never free.
    Set-GtDefault 'GT_BINDLESS_IMG' '1'
    Set-GtDefault 'GT_BINDLESS_STORES' '1'
    # GT_BINDLESS_IMGARRAY (20 Aug): the windowed image descriptor array - the LAST TWO stubs
    # (cs_3e50e1 ImageSampleRaw, cs_a95f906e ImageWrite) fetch their T# at a RUNTIME index
    # (WorkgroupId.z / a GPU-computed record number), which no CPU-time deref can resolve.
    # The CPU binds N consecutive table slots as one descriptor array and the shader indexes
    # it, OpUMin-clamped, NonUniform-decorated. Value = window size; 0 = off (stub fallback,
    # exactly the pre-20-Aug behavior). Log proof: "lowered to a windowed descriptor array".
    # Same cache warning as GT_DYNRC_WINDOW below: flipping this needs a cache wipe.
    # '16' SINCE RUN 123 (20 Aug evening): the VRAM graveyard fix (commit cbda7834) carried
    # runs 121/122 past every earlier wall - run 122 reached 682k submissions and died as a
    # GPU hang on cs_6421a7b6, the junk-V# producer whose fix IS the real-bindless work.
    # The cache wipe came free: the post-commit rebuild changed the cache generation.
    # USER CHECKS for this config: post-FX smears gone (3e50e1), track preview not red
    # (a95f906e). '0' = the stub fallback if a new fault family appears.
    Set-GtDefault 'GT_BINDLESS_IMGARRAY' '16'
    # GT_IMGARRAY_SYNC (25 Aug, Act 11 - the unwritten-LUT wash fix): the windowed T# tables
    # are GPU-written by producers recorded earlier in the SAME command buffer, so the
    # record-time read in BindTextures sees zeros and the LUT/map bakes write into null
    # descriptors. '2' = synchronous proof mode (flush+wait+readback per bake dispatch -
    # single-digit fps, ONE verification run only); '1' = async memo (playable); '3' = sync
    # on READ windows too; '0' = off. Record-time only: flipping this needs NO cache wipe.
    # Log proof: "[imgsync] ... valid a/n -> b/n". GT_IMGARRAY_SYNC_MAX caps the sync count.
    Set-GtDefault 'GT_IMGARRAY_SYNC' '0'
    Set-GtDefault 'GT_IMGARRAY_SYNC_MAX' '64'
    # GT_LUT_IDENT (25 Aug, Act 11 step 2): seed 64^3 RGBA16F volumes with an IDENTITY grading
    # LUT instead of uploading uninitialized guest RAM. Measured on three captures of one
    # PAUSED frame: identical texture inputs, output min 0.005 -> 0.054 -> 0.42 - the game
    # lerps every pixel toward the (garbage) LUT with a per-frame weight. Identity makes that
    # blend a no-op: kills the white wash, the pulsing and the solid-red track map in one move.
    # Proof run: GT7_lutident.bat. GT_WATCH_VA / GT_WATCH_SIZE (hex) arm the [vawatch]/[lut3d]
    # loggers that hunt whatever SHOULD write the LUT; GT_INVAL_IMG_ON_SSBO=1 additionally
    # propagates plain (non-formatted) SSBO writes into the texture cache's GpuDirty marking.
    # All runtime-only: flipping any of these needs NO cache wipe.
    Set-GtDefault 'GT_LUT_IDENT' '0'
    Set-GtDefault 'GT_INVAL_IMG_ON_SSBO' '0'
    # GT_LUT_DUMP=1: at a READ bind of a 64^3 RGBA16F volume, drain the GPU and print 8
    # diagonal texels ("[lutdump]"). Exists because run 163 proved the seed RUNS ([lutident]
    # on both LUTs) while the screen stayed washed and the map stayed red - so the question
    # is what the transform actually samples. 12 dumps per session, each a full drain.
    Set-GtDefault 'GT_LUT_DUMP' '0'
    # GT_IMGWRITE_SCRUB (25 Aug, late): ON by default from now on. The emitter-side NaN
    # containment for storage-image writes (emit_spirv_image.cpp) existed since the dump
    # analysis named cs_da05e7f8 a NaN factory (normalize(0) per probe mip -> the frame
    # ramps to white over 2-3 s) - but NO script ever set it, so it has been OFF for every
    # run to date. The user then correlated it live: the wash episodes coincide exactly
    # with da05e7f8's [imgtrace] bursts. ⚠ Changes emitted SPIR-V: only takes effect on
    # modules compiled AFTER the flip - the pipeline cache must be cold (a commit bumps the
    # cache generation; GT7_lutident.bat also wipes it explicitly).
    Set-GtDefault 'GT_IMGWRITE_SCRUB' '1'
    # GT_RT_SCRUB (29 Aug): contain poisoned fragment outputs from the measured GT7 foliage
    # shader. RenderDoc capture 4 proved fs_92126594 turns 10,563 tree pixels into the exact
    # 65000 HDR ceiling in one draw; the shader's guest clamp has already converted the source
    # NaNs to that finite ceiling before the MRT store. Bloom then spreads them into the visible
    # white wash. A hash list keeps every other shader untouched. This changes emitted SPIR-V,
    # and the full selector is part of the pipeline-cache ABI.
    Set-GtDefault 'GT_RT_SCRUB' '92126594'
    # GT_HASH_BASELINE (26 Aug): runtime A/B gate for the reupload-clobber fix (commit
    # 134b9428 - record the per-mip guest hash on EVERY upload of a GpuModified image).
    # '1' = the fix (default); '0' = the upstream rule (record only when !is_gpu_dirty).
    # Added because runs 166/167 stalled at GT7's init phase with the fix as the only
    # binary delta vs the last boot that reached the menu. Runtime-only (RefreshImage
    # control flow, no emitted SPIR-V), so flipping it needs NO cache wipe.
    Set-GtDefault 'GT_HASH_BASELINE' '1'
    # GT_DYNRC_WINDOW (18 Aug, afternoon - the designed fix from HANDOFF_RENDERING.md):
    # the three GPU-driven producer shaders (cs_0xda05e7f8 / 0x18256c0 / 0x2a0cfcd2) carry
    # ReadConst with RUNTIME offsets; without DMA those used to read flatbuf[0] = garbage =
    # the 19x-zone device-lost coin flip. Now the SRT walker bulk-copies an 8 KiB window of
    # each base pointer into the flatbuf and the shader indexes inside it (clamped). '1' =
    # default 2048 dwords; a number = that many dwords; '0' = old behavior. Log proof:
    # "dynamic ReadConst windowed" per shader. ⚠ Shaders already in the pipeline cache keep
    # their old modules - delete the cache once when flipping this, or the three producers
    # stay garbage-fed and the experiment reads as "no change".
    Set-GtDefault 'GT_DYNRC_WINDOW' '1'
} else {
    # Baseline for wall experiments stays byte-identical.
    $env:GT_DYNRC_WINDOW = '0'
}
Write-Host "launching (launcher bypassed), GT_SPLIT_DISPATCH=$env:GT_SPLIT_DISPATCH, GT_STORE_CLAMP=$env:GT_STORE_CLAMP ..." -ForegroundColor Green
& $exe $game

# The REAL checks all read the LOG, i.e. what the emulator itself says it did. What this script
# wrote into config.json is not evidence of anything - that mistake cost runs 17 and 18.
if (Test-Path $log) {
    Write-Host ""

    # 1. Did the log filter reach the emulator? Kernel.Vmm must be 0.
    $vmm = (Select-String -Path $log -Pattern 'Kernel.Vmm' -SimpleMatch).Count
    if ($Plain) { Write-Host "Kernel.Vmm lines: $vmm (plain run, expected non-zero)" }
    elseif ($vmm -eq 0) { Write-Host "FILTER APPLIED (Kernel.Vmm = 0)" -ForegroundColor Green }
    else { Write-Host "FILTER DID NOT APPLY - Kernel.Vmm = $vmm" -ForegroundColor Red }

    # 2. What the emulator itself printed about validation. THIS is the line that decides whether
    #    any "0 findings" result means anything at all.
    Write-Host ""
    Write-Host "--- what the emulator says it ran with ---"
    Select-String -Path $log -Pattern 'Vulkan vkValidation|Vulkan vkCrashDiagnostic' |
        ForEach-Object { Write-Host ("  " + ($_.Line -replace '^.*Run: ', '')) }
    $layerLoaded = (Select-String -Path $log -Pattern 'KHRONOS_validation' -SimpleMatch).Count -gt 0
    if ($wantSync -or $wantGpu) {
        if ($layerLoaded) { Write-Host "VALIDATION LAYER LOADED - a '0 findings' result is now meaningful." -ForegroundColor Green }
        else { Write-Host "LAYER NOT LOADED - ignore any '0 findings'; the test did not happen." -ForegroundColor Red }
    }

    # 3. VK_EXT_device_fault: is it on, and did it say anything?
    Write-Host ""
    $faultOn = (Select-String -Path $log -Pattern 'Device fault reporting enabled' -SimpleMatch).Count -gt 0
    if ($faultOn) { Write-Host "device fault reporting: ON" -ForegroundColor Green }
    else { Write-Host "device fault reporting: OFF (extension missing, or an older exe)" -ForegroundColor Yellow }
    $fault = Select-String -Path $log -Pattern '==== DEVICE FAULT|^.*address\[|^.*vendor\[|Driver description:|reported NO records'
    if ($fault) {
        Write-Host "DEVICE FAULT REPORTED:" -ForegroundColor Red
        $fault | ForEach-Object { Write-Host ("  " + ($_.Line -replace '^.*Run(DeviceFault)?: ', '')) }
    }
    $lost = (Select-String -Path $log -Pattern 'Device lost' -SimpleMatch).Count
    Write-Host ("'Device lost' lines: " + $lost)
    Write-Host ("log lines total: " + (Get-Content $log).Count)

    # 4. The vendor crash dump - the richest evidence there is, and it silently failed to write
    #    until 17 Aug (FileAccessMode::Write means "open existing" in this codebase, not "create").
    $dump = Join-Path (Split-Path $log) 'device_fault.bin'
    if (Test-Path $dump) {
        Write-Host ("vendor crash dump: " + (Get-Item $dump).Length + " bytes at " + $dump) -ForegroundColor Green
    } else {
        Write-Host "vendor crash dump: NOT written" -ForegroundColor Yellow
    }

    # 5. The suspect compute shader. It is the ONLY shader in the log the recompiler admits it
    #    could not fully translate ("ReadConst has non-immediate offset" = unresolved buffer
    #    address), and the fault records say the GPU died executing shader code.
    $rc = (Select-String -Path $log -Pattern 'ReadConst has non-immediate offset' -SimpleMatch).Count
    Write-Host ("unresolved ReadConst warnings: " + $rc + "  (suspect cs 0xda05e7f8)")
    $dumps = 'C:\Users\3E30~1\AppData\Roaming\shadPS4\shader\dumps'
    if (Test-Path $dumps) {
        $sus = Get-ChildItem $dumps -Filter '*da05e7f8*' -ErrorAction SilentlyContinue
        Write-Host ("shader dumps: " + (Get-ChildItem $dumps).Count + " files; suspect files: " + $sus.Count)
        $sus | ForEach-Object { Write-Host ("  " + $_.Name + "  " + $_.Length + " bytes") }
    }

    # 6. PSN / shadNet (-Net runs): judge from the LOG, same rule as everything above.
    if ($Net) {
        Write-Host ""
        Write-Host "--- PSN / shadNet ---"
        Select-String -Path $log -Pattern 'ServerInfo OK|Logged in npid|signed in npid|Bearer token captured|Server features:|is offline|probe:|protocol version mismatch' |
            ForEach-Object { Write-Host ("  " + $_.Line.Substring([Math]::Min(60, $_.Line.Length))) }
        $signedOut = (Select-String -Path $log -Pattern 'shadNet disabled,SignedOut' -SimpleMatch).Count
        $signedIn  = (Select-String -Path $log -Pattern 'signed in npid' -SimpleMatch).Count
        if ($signedIn -gt 0 -and $signedOut -eq 0) {
            Write-Host "PSN: SIGNED IN (0 SignedOut answers)" -ForegroundColor Green
        } else {
            Write-Host ("PSN: signed-in lines = " + $signedIn + ", SignedOut answers = " + $signedOut) -ForegroundColor Yellow
        }
        $ipObt = (Select-String -Path $log -Pattern 'eventType = 3' -SimpleMatch).Count
        $disc  = (Select-String -Path $log -Pattern 'eventType = 1' -SimpleMatch).Count
        Write-Host ("netctl events: IPOBTAINED(3) = " + $ipObt + ", DISCONNECTED(1) = " + $disc)
        $stubbed = Select-String -Path $log -Pattern 'substituting a NO-OP module' -SimpleMatch
        Write-Host ("bindless shaders stubbed: " + ($stubbed | Measure-Object).Count)
        $stubbed | Select-Object -First 5 | ForEach-Object { Write-Host ("  " + ($_.Line -replace '^.*CompileModule: ', '')) }
        # what GT7's own downloader tried now that the network is "up"
        Select-String -Path $log -Pattern 'sceNetResolverStartNtoa' -SimpleMatch |
            Select-Object -First 5 | ForEach-Object { Write-Host ("  " + ($_.Line -replace '^.*Ntoa: ', 'resolver: ')) }
    }
}
