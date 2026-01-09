<#
.SYNOPSIS
    Namespace Integrity Detection Script (Windows)
    Scans a Python package for structural smells

.DESCRIPTION
    Detects utility dumps, stuttery siblings, thin wrappers,
    semantic diffusion, and layer bleeding patterns.

.PARAMETER Target
    Path to the Python package to scan

.PARAMETER Pattern
    Detection pattern to run:
    - utility-dump: Scan for common/, utils/, helpers/ packages
    - stuttery-sibling: Scan for modules with prefix matching sibling packages
    - thin-wrapper: Scan for single-function modules
    - semantic-diffusion: Scan for duplicate module names
    - layer-bleeding: Scan for upward imports across layers
    - all: Run all patterns (default)

.PARAMETER Output
    Optional output file path

.EXAMPLE
    .\detect.ps1 -Target "pulsar\api"

.EXAMPLE
    .\detect.ps1 -Target "pulsar\api" -Pattern "stuttery-sibling"

.EXAMPLE
    .\detect.ps1 -Target "pulsar\api" -Output "report.md"
#>

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Target,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("utility-dump", "stuttery-sibling", "thin-wrapper", "semantic-diffusion", "layer-bleeding", "all")]
    [string]$Pattern = "all",
    
    [Parameter(Mandatory=$false)]
    [string]$Output = ""
)

# Validate target
if (-not (Test-Path $Target -PathType Container)) {
    Write-Error "Target directory does not exist: $Target"
    exit 1
}

# Output helper
$script:Results = @()
function Write-Result {
    param([string]$Text)
    $script:Results += $Text
    if (-not $Output) {
        Write-Host $Text
    }
}

# Pattern: Utility Dump
function Scan-UtilityDump {
    Write-Result "## Utility Dump Candidates"
    Write-Result ""
    
    $found = $false
    $dumpNames = @("common", "utils", "helpers", "core", "shared", "misc", "internal", "lib")
    
    Get-ChildItem -Path $Target -Directory -Recurse | ForEach-Object {
        if ($dumpNames -contains $_.Name) {
            $found = $true
            Write-Result "- ``$($_.FullName)``"
            
            $pyFiles = Get-ChildItem -Path $_.FullName -Filter "*.py" -File
            if ($pyFiles.Count -eq 1 -and $pyFiles[0].Name -eq "__init__.py") {
                Write-Result "  - Contains only ``__init__.py`` (possible obsolete shim)"
            } else {
                Write-Result "  - Contains $($pyFiles.Count) Python files"
            }
        }
    }
    
    if (-not $found) {
        Write-Result "No utility dump packages found."
    }
    Write-Result ""
}

# Pattern: Stuttery Sibling
function Scan-StutterySibling {
    Write-Result "## Stuttery Sibling Candidates"
    Write-Result ""
    
    $found = $false
    
    Get-ChildItem -Path $Target -Directory -Recurse | ForEach-Object {
        $dir = $_
        Get-ChildItem -Path $dir.FullName -Filter "*.py" -File | ForEach-Object {
            $file = $_
            $base = $file.BaseName
            if ($base -eq "__init__") { return }
            
            # Extract underscore-delimited prefix
            $prefix = ($base -split '_')[0]
            $siblingPath = Join-Path $dir.FullName $prefix
            
            if (Test-Path $siblingPath -PathType Container) {
                $found = $true
                $suggestedName = $base -replace "^${prefix}_", ""
                Write-Result "- ``$($file.FullName)``"
                Write-Result "  - Sibling package: ``$siblingPath\``"
                Write-Result "  - Suggested move: ``$siblingPath\$suggestedName.py``"
            }
        }
    }
    
    if (-not $found) {
        Write-Result "No stuttery sibling modules found."
    }
    Write-Result ""
}

# Pattern: Thin Wrapper
function Scan-ThinWrapper {
    Write-Result "## Thin Wrapper Candidates"
    Write-Result ""
    
    $found = $false
    
    Get-ChildItem -Path $Target -Filter "*.py" -File -Recurse | ForEach-Object {
        $file = $_
        if ($file.BaseName -eq "__init__") { return }
        
        $content = Get-Content $file.FullName -Raw
        $publicFuncs = ([regex]::Matches($content, "(?m)^def [a-z]")).Count
        $codeLines = ($content -split "`n" | Where-Object { $_ -notmatch "^\s*(#|$)" }).Count
        
        if ($publicFuncs -eq 1 -and $codeLines -lt 50) {
            $found = $true
            Write-Result "- ``$($file.FullName)``"
            Write-Result "  - Public functions: $publicFuncs"
            Write-Result "  - Code lines: $codeLines"
        }
    }
    
    if (-not $found) {
        Write-Result "No thin wrapper modules found."
    }
    Write-Result ""
}

# Pattern: Semantic Diffusion
function Scan-SemanticDiffusion {
    Write-Result "## Semantic Diffusion Candidates"
    Write-Result ""
    
    $found = $false
    $files = Get-ChildItem -Path $Target -Filter "*.py" -File -Recurse | 
             Where-Object { $_.Name -ne "__init__.py" }
    
    $dupes = $files | Group-Object Name | Where-Object { $_.Count -gt 1 }
    
    foreach ($dupe in $dupes) {
        $found = $true
        Write-Result "- ``$($dupe.Name)`` appears in multiple locations:"
        foreach ($loc in $dupe.Group) {
            Write-Result "  - ``$($loc.FullName)``"
        }
    }
    
    if (-not $found) {
        Write-Result "No duplicate module names found."
    }
    Write-Result ""
}

# Pattern: Layer Bleeding
function Scan-LayerBleeding {
    Write-Result "## Layer Bleeding Candidates"
    Write-Result ""
    
    $found = $false
    
    # Check io importing from processor or engine
    $ioPath = Join-Path $Target "io"
    if (Test-Path $ioPath) {
        $violations = Get-ChildItem -Path $ioPath -Filter "*.py" -File -Recurse | ForEach-Object {
            $content = Get-Content $_.FullName -Raw
            if ($content -match "from.*\.processor") {
                "processor import in: $($_.FullName)"
            }
            if ($content -match "from.*\.engine" -and $content -notmatch "engine\.plan\.load") {
                "engine import in: $($_.FullName)"
            }
        }
        
        if ($violations) {
            $found = $true
            Write-Result "### io/ importing from higher layers"
            Write-Result "``````"
            $violations | ForEach-Object { Write-Result $_ }
            Write-Result "``````"
            Write-Result ""
        }
    }
    
    if (-not $found) {
        Write-Result "No obvious layer bleeding found."
    }
    Write-Result ""
}

# Main execution
Write-Result "# Namespace Integrity Scan Results"
Write-Result ""
Write-Result "**Target:** ``$Target``"
Write-Result "**Pattern:** $Pattern"
Write-Result "**Date:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Result ""
Write-Result "---"
Write-Result ""

switch ($Pattern) {
    "utility-dump"       { Scan-UtilityDump }
    "stuttery-sibling"   { Scan-StutterySibling }
    "thin-wrapper"       { Scan-ThinWrapper }
    "semantic-diffusion" { Scan-SemanticDiffusion }
    "layer-bleeding"     { Scan-LayerBleeding }
    "all" {
        Scan-UtilityDump
        Scan-StutterySibling
        Scan-ThinWrapper
        Scan-SemanticDiffusion
        Scan-LayerBleeding
    }
}

Write-Result "---"
Write-Result ""
Write-Result "Scan complete. Review candidates and consult skill references for analysis guidance."

# Write to file if specified
if ($Output) {
    $script:Results | Out-File -FilePath $Output -Encoding UTF8
    Write-Host "Report written to: $Output"
}
