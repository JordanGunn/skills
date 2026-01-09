#
# status.ps1 — Display plan execution status by parsing frontmatter
#
# Usage: .\status.ps1 [phase-number]
#   If no phase number is provided, uses the highest-numbered phase.
#

param(
    [Parameter(Position=0)]
    [string]$PhaseNum
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path "$ScriptDir\..\..\..\..\..").Path
$PlanningDir = Join-Path $RepoRoot "docs\planning"

# Determine phase number
if (-not $PhaseNum) {
    $phases = Get-ChildItem -Path $PlanningDir -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match '^phase-(\d+)$' } |
        ForEach-Object { [int]($_.Name -replace 'phase-', '') } |
        Sort-Object -Descending
    
    if ($phases.Count -eq 0) {
        Write-Host "No phases found in $PlanningDir"
        exit 1
    }
    $PhaseNum = $phases[0]
}

$PhaseDir = Join-Path $PlanningDir "phase-$PhaseNum"

if (-not (Test-Path $PhaseDir)) {
    Write-Host "Phase directory not found: $PhaseDir"
    exit 1
}

# Extract status from frontmatter
function Get-Status {
    param([string]$FilePath)
    
    if (-not (Test-Path $FilePath)) {
        return "missing"
    }
    
    $content = Get-Content $FilePath -Raw
    if ($content -match '(?ms)^---\s*\n.*?^status:\s*(\w+).*?\n---') {
        return $Matches[1]
    }
    return "unknown"
}

# Status symbol
function Get-StatusSymbol {
    param([string]$Status)
    
    switch ($Status) {
        "complete" { return [char]0x2713 }      # ✓
        "in_progress" { return [char]0x25CF }   # ●
        "pending" { return [char]0x25CB }       # ○
        default { return "?" }
    }
}

Write-Host ""
Write-Host "Phase $PhaseNum Status"
Write-Host "----------------"

# Get root plan status
$rootStatus = Get-Status (Join-Path $PhaseDir "plan.md")
$rootSymbol = Get-StatusSymbol $rootStatus
Write-Host "plan.md       $rootSymbol $rootStatus"
Write-Host ""

# Track counts
$total = 0
$complete = 0
$inProgress = 0
$pending = 0
$activeTask = ""

# Iterate through sub-plans
$subplanDirs = Get-ChildItem -Path $PhaseDir -Directory |
    Where-Object { $_.Name -match '^[a-z]$' } |
    Sort-Object Name

foreach ($subplanDir in $subplanDirs) {
    $letter = $subplanDir.Name
    
    # Get task files (roman numerals only)
    $taskFiles = Get-ChildItem -Path $subplanDir.FullName -File -Filter "*.md" |
        Where-Object { $_.Name -match '^(i|ii|iii|iv|v|vi|vii|viii|ix|x)\.md$' } |
        Sort-Object { 
            $roman = $_.BaseName
            switch ($roman) {
                "i" { 1 }
                "ii" { 2 }
                "iii" { 3 }
                "iv" { 4 }
                "v" { 5 }
                "vi" { 6 }
                "vii" { 7 }
                "viii" { 8 }
                "ix" { 9 }
                "x" { 10 }
                default { 99 }
            }
        }
    
    foreach ($taskFile in $taskFiles) {
        $taskStatus = Get-Status $taskFile.FullName
        $symbol = Get-StatusSymbol $taskStatus
        
        $marker = ""
        if ($taskStatus -eq "in_progress") {
            $marker = " <- active"
            $activeTask = "$letter/$($taskFile.Name)"
        }
        
        $displayName = "$letter/$($taskFile.Name)"
        Write-Host ("{0,-12} {1} {2}{3}" -f $displayName, $symbol, $taskStatus, $marker)
        
        $total++
        switch ($taskStatus) {
            "complete" { $complete++ }
            "in_progress" { $inProgress++ }
            "pending" { $pending++ }
        }
    }
}

Write-Host ""

# Calculate progress
if ($total -gt 0) {
    $pct = [math]::Floor($complete * 100 / $total)
    Write-Host "Progress: $complete/$total tasks ($pct%)"
} else {
    Write-Host "Progress: No tasks found"
}

if ($activeTask) {
    Write-Host "Active: $activeTask"
}

Write-Host ""
