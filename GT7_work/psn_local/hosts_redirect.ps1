# hosts_redirect.ps1 - point GT7's Polyphony domains at 127.0.0.1 so the game's own
# server connection FAILS FAST (connection refused) instead of hanging forever in the
# stubbed sceSsl TLS handshake. PSN (shadNet) is unaffected - it already runs locally.
#
# Must run ELEVATED (writes C:\Windows\System32\drivers\etc\hosts).
#   hosts_redirect.ps1          add the entries (idempotent)
#   hosts_redirect.ps1 -Undo    remove them again
# ASCII only.

param([switch]$Undo)

$marker = '# GT7-shadPS4 local redirect'
$domains = @(
    'asset.gt7.game.gran-turismo.com',
    'portal.gt7.game.gran-turismo.com'
    # !! api.develop-stable.vegas.granturismo-online.net REMOVED (18 Aug): redirecting it to
    # 127.0.0.1 made the refusal INSTANT (microseconds) and GT7's FWRKR download worker
    # races its own init on that error path -> null-read boot crash, 5 of 9 boots (runs
    # 32/37-40). It never crashed in 31 runs while this name resolved to the real AWS
    # (TCP connects, no TLS bytes flow - sceSsl is a stub - the game closes and moves on).
)

$diag = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) 'hosts_apply_log.txt'
('run at ' + (Get-Date -Format 'HH:mm:ss') + ' undo=' + $Undo + ' domains=' + $domains.Count) |
    Out-File $diag -Append -Encoding ascii

$h = Join-Path $env:SystemRoot 'System32\drivers\etc\hosts'
$lines = @(Get-Content $h -ErrorAction Stop)
('read ' + $lines.Count + ' line(s) from ' + $h) | Out-File $diag -Append -Encoding ascii

# strip every line we ever added (marker-tagged), then re-add unless -Undo.
# @() everywhere: this machine's hosts file is EMPTY, and piping an empty array through
# Where-Object returns $null - then += does STRING concatenation and both entries land on
# ONE line, where the first entry's '#' comment swallows the second (portal never resolved).
$lines = @($lines | Where-Object { $_ -notmatch [regex]::Escape($marker) })
if (-not $Undo) {
    foreach ($d in $domains) { $lines = @($lines) + ('127.0.0.1 ' + $d + '   ' + $marker) }
}
('writing ' + $lines.Count + ' line(s); last: [' + $lines[-1] + ']') | Out-File $diag -Append -Encoding ascii
Set-Content -Path $h -Value $lines -Encoding ASCII
('write done, exists=' + (Test-Path $h)) | Out-File $diag -Append -Encoding ascii
ipconfig /flushdns | Out-Null

Write-Host ("hosts file now contains:")
Get-Content $h | Select-String 'gran-turismo' | ForEach-Object { Write-Host ("  " + $_.Line) }
if ($Undo) { Write-Host "redirect REMOVED." } else { Write-Host "redirect ACTIVE - GT7 server connects will be refused locally." }
Start-Sleep -Seconds 2
