#
# windsurf.ps1 — Generate Windsurf workflows from agent skills
#
# Usage: .\windsurf.ps1 [skills_dir] [workflows_dir]
#   skills_dir:   Directory containing skills (default: skills/)
#   workflows_dir: Output directory for workflows (default: .windsurf/workflows)
#

param(
    [Parameter(Position=0)]
    [string]$SkillsDir,
    [Parameter(Position=1)]
    [string]$WorkflowsDir
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path "$ScriptDir\..\..").Path

if (-not $SkillsDir) { $SkillsDir = Join-Path $RepoRoot "skills" }
if (-not $WorkflowsDir) { $WorkflowsDir = Join-Path $RepoRoot ".windsurf\workflows" }

# Ensure output directory exists
if (-not (Test-Path $WorkflowsDir)) {
    New-Item -ItemType Directory -Path $WorkflowsDir -Force | Out-Null
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
        return $desc.Substring(0, [Math]::Min(80, $desc.Length))
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

function New-Workflow {
    param(
        [string]$SkillFile,
        [string]$SkillDir
    )
    
    $name = Get-YamlValue -FilePath $SkillFile -Key "name"
    if (-not $name) { return }
    
    $desc = Get-YamlDescription -FilePath $SkillFile
    $workflowFile = Join-Path $WorkflowsDir "$name.md"
    
    $keywords = (Get-YamlList -FilePath $SkillFile -ListName "keywords") -join ", "
    $refs = Get-YamlList -FilePath $SkillFile -ListName "references"
    
    $scriptsDir = Join-Path (Split-Path $SkillFile -Parent) "scripts"
    $hasScripts = Test-Path $scriptsDir
    
    $content = @"
---
description: $desc
auto_execution_mode: 1
---

# $name

This workflow delegates to the agent skill at ``.codex/skills/$SkillDir/``.

## Instructions

1. Read the skill manifest: ``.codex/skills/$SkillDir/SKILL.md``
2. Read all references listed in ``metadata.references`` in order:
"@

    foreach ($ref in $refs) {
        $content += "`n   - $ref"
    }
    
    if ($hasScripts) {
        $content += @"

3. If scripts are present in ``scripts/``, follow any automated steps first
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

- **Path:** ``.codex/skills/$SkillDir/``
- **References:** ``references/``
"@

    if ($hasScripts) {
        $content += "`n- **Scripts:** ``scripts/``"
    }
    
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
        $content += @"

To run the full pipeline, invoke this workflow.
To run individual skills, use their specific workflows.
"@
    }
    
    if ($keywords) {
        $content += @"

## Keywords

``$keywords``
"@
    }
    
    $content += "`n"
    
    Set-Content -Path $workflowFile -Value $content -Encoding UTF8
    Write-Host "Generated: $workflowFile"
}

Write-Host "Generating Windsurf workflows from agent skills..."
Write-Host "  Skills: $SkillsDir"
Write-Host "  Output: $WorkflowsDir"
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
        New-Workflow -SkillFile $skillFile -SkillDir $skillDir
        $script:count++
    }
}

Write-Host ""
Write-Host "Generated $count workflow(s)"
