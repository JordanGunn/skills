# cursor.ps1 - Generate Cursor command files from skills
#
# Usage: cursor.ps1 [project_root]
#
# If project_root is provided, runs from that directory.
# Otherwise, attempts to find project root from script location.

param(
    [string]$ProjectRoot
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Resolve project root
if ($ProjectRoot) {
    $ResolvedRoot = Resolve-Path $ProjectRoot
} else {
    # Navigate up from .codex\scripts\install\windows\ to project root
    $ResolvedRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..\..")
}

$AdapterScript = Join-Path $ResolvedRoot ".codex\scripts\adapter\cursor.ps1"

if (-not (Test-Path $AdapterScript)) {
    Write-Error "Adapter script not found: $AdapterScript"
    exit 1
}

& $AdapterScript
