param(
  [string]$Root = "docs/planning"
)

$ErrorActionPreference = "Stop"

New-Item -ItemType Directory -Force -Path $Root | Out-Null

$maxN = 0
Get-ChildItem -Path $Root -Directory | ForEach-Object {
  if ($_.Name -match '^phase-(\d+)$') {
    $n = [int]$Matches[1]
    if ($n -gt $maxN) { $maxN = $n }
  }
}

$nextN = $maxN + 1
$phaseDir = Join-Path $Root "phase-$nextN"

if (Test-Path $phaseDir) {
  Write-Error "ERROR: $phaseDir already exists. Refusing to overwrite."
  exit 2
}

New-Item -ItemType Directory -Path $phaseDir | Out-Null
Write-Output $phaseDir
