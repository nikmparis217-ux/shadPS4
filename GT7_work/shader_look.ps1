# ASCII ONLY + 8.3 SHORT PATHS - the user name is Greek and PS 5.1 reads .ps1 as ANSI.
#
# Read a dumped shader. Written for the device-fault hunt of 17 Aug: the fault records were 11
# shader instruction pointers inside 592 bytes with NO bad memory access, which reads as a HANG,
# and the only shader the recompiler admits it mis-translated is compute 0xda05e7f8
# ("ReadConst has non-immediate offset" = it could not resolve a buffer address).
#
# So what we are looking for in the output is A LOOP WHOSE EXIT CONDITION COMES FROM A BUFFER
# READ - if the address was not resolved, that value is garbage and the loop may never end.
#
#   .\shader_look.ps1                 -> list what has been dumped
#   .\shader_look.ps1 da05e7f8        -> disassemble + decompile + control flow for that hash
#
# Needs `-DumpShaders` on a previous run (GT7_dump.bat). Dumps are written as BOTH .bin (the
# original PS4 GCN bytecode) and .spv (what the recompiler produced) - vk_pipeline_cache.cpp:611.

param([string]$Hash)

$sdk    = 'C:\VulkanSDK\1.4.357.0\Bin'
$dumps  = 'C:\Users\3E30~1\AppData\Roaming\shadPS4\shader\dumps'
$outdir = 'C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\shaders'

if (-not (Test-Path $dumps)) {
    Write-Host "No dumps at $dumps - run GT7_dump.bat first." -ForegroundColor Yellow
    exit 1
}

if (-not $Hash) {
    $all = Get-ChildItem $dumps -Filter *.spv -ErrorAction SilentlyContinue
    Write-Host ("dumped .spv shaders: " + $all.Count)
    $all | Sort-Object Length -Descending | Select-Object -First 25 Name, Length | Format-Table -AutoSize
    Write-Host "Pass a hash, e.g.  .\shader_look.ps1 da05e7f8"
    exit 0
}

$files = Get-ChildItem $dumps -Filter "*$Hash*.spv" -ErrorAction SilentlyContinue
if (-not $files) {
    Write-Host "Nothing matching *$Hash*.spv in $dumps" -ForegroundColor Yellow
    Get-ChildItem $dumps -Filter "*$Hash*" | Select-Object Name, Length | Format-Table -AutoSize
    exit 1
}

if (-not (Test-Path $outdir)) { New-Item -ItemType Directory $outdir | Out-Null }

foreach ($f in $files) {
    $base = [IO.Path]::GetFileNameWithoutExtension($f.Name)
    Write-Host ""
    Write-Host ("=== " + $f.Name + "  (" + $f.Length + " bytes) ===") -ForegroundColor Cyan

    # 1. SPIR-V assembly - exact, and what OpLoopMerge shows is the loop structure.
    & "$sdk\spirv-dis.exe" $f.FullName > "$outdir\$base.spvasm" 2>&1
    # 2. GLSL - far easier to read the actual loop condition out of.
    & "$sdk\spirv-cross.exe" $f.FullName --output "$outdir\$base.glsl" 2>&1 | Out-Null
    # 3. Control flow graph (dot). A loop with no reachable exit is visible here.
    & "$sdk\spirv-cfg.exe" $f.FullName > "$outdir\$base.dot" 2>&1

    $asm = "$outdir\$base.spvasm"
    if (Test-Path $asm) {
        $loops = (Select-String -Path $asm -Pattern 'OpLoopMerge' -SimpleMatch).Count
        $loads = (Select-String -Path $asm -Pattern 'OpLoad' -SimpleMatch).Count
        Write-Host ("  loops (OpLoopMerge): " + $loops + "    OpLoad count: " + $loads)
        Write-Host ("  wrote: " + $base + ".spvasm / .glsl / .dot  in GT7_work\shaders")
        if ($loops -gt 0) {
            Write-Host "  --- loop headers and their conditions ---"
            Select-String -Path $asm -Pattern 'OpLoopMerge' -Context 0,6 |
                ForEach-Object { $_.Line; $_.Context.PostContext } |
                ForEach-Object { Write-Host ("    " + $_) }
        } else {
            Write-Host "  NO LOOP in this shader - then a hang cannot come from here." -ForegroundColor Yellow
        }
    } else {
        Write-Host "  spirv-dis produced nothing - is the .spv complete?" -ForegroundColor Yellow
    }
}
