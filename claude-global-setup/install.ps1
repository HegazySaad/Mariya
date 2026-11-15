# Installs global routing config into $HOME\.claude. Idempotent; backs up first; never overwrites existing agents.
$ErrorActionPreference = 'Stop'
$src = $PSScriptRoot
$dst = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $HOME '.claude' }
New-Item -ItemType Directory -Force -Path (Join-Path $dst 'agents') | Out-Null
$bk = Join-Path $dst ("backups\routing-" + (Get-Date -Format 'yyyyMMdd-HHmmss'))
New-Item -ItemType Directory -Force -Path $bk | Out-Null
foreach ($f in 'CLAUDE.md','settings.json') { $p = Join-Path $dst $f; if (Test-Path $p) { Copy-Item $p $bk } }
if (Test-Path (Join-Path $dst 'agents')) { Copy-Item (Join-Path $dst 'agents') (Join-Path $bk 'agents') -Recurse }

# CLAUDE.md: replace only our marked block, keep everything else
$cm = Join-Path $dst 'CLAUDE.md'
$block = "<!-- routing:start -->`n" + (Get-Content (Join-Path $src 'CLAUDE.global.md') -Raw).TrimEnd() + "`n<!-- routing:end -->"
$cur = if (Test-Path $cm) { Get-Content $cm -Raw } else { '' }
if ($cur -match '(?s)<!-- routing:start -->.*?<!-- routing:end -->') { $cur = [regex]::Replace($cur, '(?s)<!-- routing:start -->.*?<!-- routing:end -->', { param($m) $block }) }
else { $cur = ($cur.TrimEnd() + "`n`n" + $block + "`n").TrimStart() }
[IO.File]::WriteAllText($cm, $cur, (New-Object Text.UTF8Encoding $false))

# Agents: copy only if absent
foreach ($a in Get-ChildItem (Join-Path $src 'agents') -Filter *.md) {
  $t = Join-Path $dst "agents\$($a.Name)"
  if (-not (Test-Path $t)) { Copy-Item $a.FullName $t } else { Write-Host "kept existing $($a.Name)" }
}

# settings.json: set default model=sonnet ONLY if no model is configured; nothing else touched
$sp = Join-Path $dst 'settings.json'
if (Test-Path $sp) {
  $j = Get-Content $sp -Raw | ConvertFrom-Json
  if (-not $j.PSObject.Properties['model']) {
    $j | Add-Member -NotePropertyName model -NotePropertyValue 'sonnet'
    [IO.File]::WriteAllText($sp, ($j | ConvertTo-Json -Depth 50), (New-Object Text.UTF8Encoding $false))
    Write-Host 'settings.json: model=sonnet added'
  } else { Write-Host "settings.json: model already set ($($j.model)), untouched" }
} else { [IO.File]::WriteAllText($sp, "{`n  `"model`": `"sonnet`"`n}`n", (New-Object Text.UTF8Encoding $false)); Write-Host 'settings.json created' }
Write-Host "Done. Backup: $bk"
