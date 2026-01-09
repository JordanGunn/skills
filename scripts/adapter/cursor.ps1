#
# cursor.ps1 — Generate Cursor commands from agent skills
#
# Usage: .\cursor.ps1 [skills_dir] [commands_dir]
#   skills_dir:   Directory containing skills (default: skills/)
#   commands_dir: Output directory for commands (default: .cursor/commands)
#

param(
    [Parameter(Position=0)]
    [string]$SkillsDir,
    [Parameter(Position=1)]
    [string]$CommandsDir
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path "$ScriptDir\..\..").Path

if (-not $SkillsDir) { $SkillsDir = Join-Path $RepoRoot "skills" }
if (-not $CommandsDir) { $CommandsDir = Join-Path $RepoRoot ".cursor\commands" }

# Ensure output directory exists
if (-not (Test-Path $CommandsDir)) {
    New-Item -ItemType Directory -Path $CommandsDir -Force | Out-Null
}

# Skip patterns
$SkipPatterns = @("^index$", "index-skills", "adapter")

function Get-YamlValue {
    param([string]$FilePath, [string]$Key)
    
    $content = Get-Content $FilePath -Raw
    if ($content -match "(?ms)^---\s*\n.*?^${Key}:\s*[>|]?\s*(.+?)(?:\n[a-z]|\n---)" ) {
        return $Matches[1].Trim()
    }
    if ($content -match "(?m)^${Key}:\s*(.+)$") {
        return $Matches[1].Trim()
    }
    return ""
}

function Get-YamlDescription {
    param([string]$FilePath)
    
    $content = Get-Content $FilePath -Raw
    if ($content -match '(?ms)^---\s*\n.*?^description:\s*[>|]?\s*\n?\s*(.+?)(?:\n[a-z]|\nmetadata:)') {
        $desc = $Matches[1].Trim() -split "`n" | Select-Object -First 1
        return $desc
    }
    return ""
}

function Get-YamlList {
    param([string]$FilePath, [string]$ListName)
    
    $content = Get-Content $FilePath -Raw
    $items = @()
    
    if ($content -match "(?ms)${ListName}:\s*\n((?:\s+-\s+.+\n?)+)") {
        $listBlock = $Matches[1]
        $listBlock -split "`n" | ForEach-Object {
            if ($_ -match '^\s+-\s+(.+)$') {
                $items += $Matches[1].Trim().Trim('"', "'")
            }
        }
    }
    return $items
}

function Get-SkillsetMembers {
    param([string]$FilePath)
    
    $content = Get-Content $FilePath -Raw
    $members = @()
    
    if ($content -match '(?ms)skillset:\s*\n.*?skills:\s*\n((?:\s+-\s+[a-z]+-[a-z]+.*\n?)+)') {
        $listBlock = $Matches[1]
        $listBlock -split "`n" | ForEach-Object {
            if ($_ -match '^\s+-\s+([a-z]+-[a-z]+(?:-[a-z]+)*)') {
                $members += $Matches[1]
            }
        }
    }
    return $members
}

function Get-DefaultPipeline {
    param([string]$FilePath)
    
    $content = Get-Content $FilePath -Raw
    $pipeline = @()
    
    if ($content -match '(?ms)pipelines:\s*\n\s+default:\s*\n((?:\s+-\s+[a-z]+-[a-z]+.*\n?)+)') {
        $listBlock = $Matches[1]
        $listBlock -split "`n" | ForEach-Object {
            if ($_ -match '^\s+-\s+([a-z]+-[a-z]+(?:-[a-z]+)*)') {
                $pipeline += $Matches[1]
            }
        }
    }
    return $pipeline -join " -> "
}

function Test-IsSkillset {
    param([string]$FilePath)
    
    $content = Get-Content $FilePath -Raw
    return ($content -match 'skillset:') -and ($content -match '\s+skills:')
}

function New-Command {
    param(
        [string]$SkillFile,
        [string]$SkillDir
    )
    
    $name = Get-YamlValue -FilePath $SkillFile -Key "name"
    if (-not $name) { return }
    
    $desc = Get-YamlDescription -FilePath $SkillFile
    $commandFile = Join-Path $CommandsDir "$name.md"
    
    $keywords = (Get-YamlList -FilePath $SkillFile -ListName "keywords") -join ", "
    $refs = Get-YamlList -FilePath $SkillFile -ListName "references"
    
    $scriptsDir = Join-Path (Split-Path $SkillFile -Parent) "scripts"
    $hasScripts = Test-Path $scriptsDir
    
    # Plain markdown, no frontmatter for Cursor
    $content = @"
# $name

$desc

## Instructions

1. Read the skill manifest: ``.codex/skills/$SkillDir/SKILL.md``
2. Read all references in order:
"@

    foreach ($ref in $refs) {
        $content += "`n   - ``references/$ref``"
    }
    
    if ($hasScripts) {
        $content += @"

3. If scripts are present in ``scripts/``, follow automated steps first
4. Execute the skill procedure as documented
5. Produce output in the format specified by the skill
"@
    } else {
        $content += @"

3. Execute the skill procedure as documented
4. Produce output in the format specified by the skill
"@
    }
    
    $content += @"

## Skill Location

**Path:** ``.codex/skills/$SkillDir/``
"@

    if (Test-IsSkillset -FilePath $SkillFile) {
        $members = (Get-SkillsetMembers -FilePath $SkillFile) -join ", "
        $pipeline = Get-DefaultPipeline -FilePath $SkillFile
        
        $content += @"

## Skillset

This is an orchestrator skill with member skills.

- **Members:** $members
"@
        if ($pipeline) {
            $content += "`n- **Default Pipeline:** $pipeline"
        }
        $content += "`n"
    }
    
    if ($keywords) {
        $content += @"

## Keywords

$keywords
"@
    }
    
    $content += "`n"
    
    Set-Content -Path $commandFile -Value $content -Encoding UTF8
    Write-Host "Generated: $commandFile"
}

Write-Host "Generating Cursor commands from agent skills..."
Write-Host "  Skills: $SkillsDir"
Write-Host "  Output: $CommandsDir"
Write-Host ""

$count = 0
Get-ChildItem -Path $SkillsDir -Recurse -Filter "SKILL.md" | ForEach-Object {
    $skillFile = $_.FullName
    $relPath = $skillFile.Substring($SkillsDir.Length + 1)
    $skillDir = Split-Path $relPath -Parent
    
    # Check skip patterns
    $skip = $false
    foreach ($pattern in $SkipPatterns) {
        if ($skillDir -match $pattern) {
            Write-Host "Skipping: $skillDir (meta-skill)"
            $skip = $true
            break
        }
    }
    
    if (-not $skip) {
        New-Command -SkillFile $skillFile -SkillDir $skillDir
        $script:count++
    }
}

Write-Host ""
Write-Host "Generated $count command(s)"
