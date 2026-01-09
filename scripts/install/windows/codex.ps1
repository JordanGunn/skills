# codex.ps1 - Install skills to codex home or target directory
#
# Usage: codex.ps1 [target_dir]
#
# If target_dir is provided:
#   - Checks if target_dir\.codex or target_dir\.codex\skills exists
#   - Copies skills to target_dir\.codex\skills\
#
# If no argument:
#   - Installs to $env:USERPROFILE\.codex\skills\

param(
    [string]$TargetDir
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..\..") 
$SourceSkills = Join-Path $ProjectRoot ".codex\skills"

if (-not (Test-Path $SourceSkills)) {
    Write-Error "Source skills directory not found: $SourceSkills"
    exit 1
}

# Determine destination
if ($TargetDir) {
    # Normalize: remove trailing backslash
    $TargetDir = $TargetDir.TrimEnd('\')
    
    # Check if target already has .codex structure
    if ($TargetDir -like "*\.codex\skills") {
        # User passed full path including .codex\skills
        $DestSkills = $TargetDir
    } elseif ($TargetDir -like "*\.codex") {
        # User passed path including .codex
        $DestSkills = Join-Path $TargetDir "skills"
    } else {
        # User passed project root
        $DestSkills = Join-Path $TargetDir ".codex\skills"
    }
} else {
    # Default: install to user home
    $DestSkills = Join-Path $env:USERPROFILE ".codex\skills"
}

# Create destination if needed
if (-not (Test-Path $DestSkills)) {
    New-Item -ItemType Directory -Path $DestSkills -Force | Out-Null
}

Write-Host "Installing skills..."
Write-Host "  Source: $SourceSkills"
Write-Host "  Destination: $DestSkills"
Write-Host ""

# Copy skills (excluding .git and __pycache__)
$ExcludePatterns = @('.git', '__pycache__', '*.pyc')

Get-ChildItem -Path $SourceSkills -Directory | ForEach-Object {
    $SkillName = $_.Name
    $SkillSource = $_.FullName
    $SkillDest = Join-Path $DestSkills $SkillName
    
    Write-Host "  Copying: $SkillName"
    
    # Remove existing and copy fresh
    if (Test-Path $SkillDest) {
        Remove-Item -Path $SkillDest -Recurse -Force
    }
    
    Copy-Item -Path $SkillSource -Destination $SkillDest -Recurse -Force
    
    # Clean up excluded items
    Get-ChildItem -Path $SkillDest -Recurse -Include $ExcludePatterns -Force -ErrorAction SilentlyContinue | 
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "Skills installed to: $DestSkills"
