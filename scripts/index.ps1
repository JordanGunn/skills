#
# index.ps1 — Generate a skill index from all SKILL.md files
#
# Usage: .\index.ps1 [skills_dir] [output_file]
#   skills_dir:  Directory to scan (default: .codex/skills)
#   output_file: Output index file (default: .codex/skills/INDEX.md)
#

param(
    [Parameter(Position=0)]
    [string]$SkillsDir,
    [Parameter(Position=1)]
    [string]$OutputFile
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path "$ScriptDir\..\..").Path

if (-not $SkillsDir) { $SkillsDir = Join-Path $RepoRoot ".codex\skills" }
if (-not $OutputFile) { $OutputFile = Join-Path $SkillsDir "INDEX.md" }

# Data collections
$QuickRef = @()
$Skillsets = @()
$Standalone = @()
$Keywords = @{}
$SkillsetNames = @()

function Get-YamlValue {
    param([string]$FilePath, [string]$Key)
    
    $content = Get-Content $FilePath -Raw
    if ($content -match "(?m)^${Key}:\s*[>|]?\s*(.+?)$") {
        return $Matches[1].Trim()
    }
    return ""
}

function Get-YamlDescription {
    param([string]$FilePath)
    
    $content = Get-Content $FilePath -Raw
    if ($content -match '(?ms)^description:\s*[>|]?\s*\n?\s*(.+?)(?:\n[a-z]|\nmetadata:)') {
        $desc = $Matches[1].Trim() -split "`n" | Select-Object -First 1
        return $desc.Substring(0, [Math]::Min(100, $desc.Length))
    }
    return ""
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

function Get-YamlKeywords {
    param([string]$FilePath)
    
    $content = Get-Content $FilePath -Raw
    $keywords = @()
    
    if ($content -match '(?ms)keywords:\s*\n((?:\s+-\s+.+\n?)+)') {
        $listBlock = $Matches[1]
        $listBlock -split "`n" | ForEach-Object {
            if ($_ -match '^\s+-\s+(.+)$') {
                $keywords += $Matches[1].Trim().Trim('"', "'")
            }
        }
    }
    return $keywords
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

Write-Host "Scanning $SkillsDir for SKILL.md files..."

# Get all SKILL.md files
$skillFiles = Get-ChildItem -Path $SkillsDir -Recurse -Filter "SKILL.md" | Sort-Object FullName

# Pass 1: Identify skillsets
foreach ($skillFile in $skillFiles) {
    $relPath = $skillFile.FullName.Substring($SkillsDir.Length + 1)
    $skillDir = Split-Path $relPath -Parent
    
    if ($skillDir -eq "index-skills" -or $skillDir -eq "index") { continue }
    
    $name = Get-YamlValue -FilePath $skillFile.FullName -Key "name"
    if (-not $name) { continue }
    
    if (Test-IsSkillset -FilePath $skillFile.FullName) {
        $script:SkillsetNames += $name
    }
}

# Pass 2: Process all skills
foreach ($skillFile in $skillFiles) {
    $relPath = $skillFile.FullName.Substring($SkillsDir.Length + 1)
    $skillDir = Split-Path $relPath -Parent
    
    if ($skillDir -eq "index-skills" -or $skillDir -eq "index") { continue }
    
    $name = Get-YamlValue -FilePath $skillFile.FullName -Key "name"
    $desc = Get-YamlDescription -FilePath $skillFile.FullName
    
    if (-not $name) { continue }
    
    # Collect keywords
    $kws = Get-YamlKeywords -FilePath $skillFile.FullName
    foreach ($kw in $kws) {
        if (-not $script:Keywords.ContainsKey($kw)) {
            $script:Keywords[$kw] = @()
        }
        $script:Keywords[$kw] += $name
    }
    
    if (Test-IsSkillset -FilePath $skillFile.FullName) {
        $script:QuickRef += [PSCustomObject]@{
            Name = $name
            Path = $skillDir
            Type = "skillset"
            Desc = $desc
        }
        
        $members = Get-SkillsetMembers -FilePath $skillFile.FullName
        $pipeline = Get-DefaultPipeline -FilePath $skillFile.FullName
        
        $script:Skillsets += [PSCustomObject]@{
            Name = $name
            Path = $skillDir
            Desc = $desc
            Members = $members
            Pipeline = $pipeline
        }
    }
    elseif ($name -match '^([a-z]+)-' -and $script:SkillsetNames -contains $Matches[1]) {
        $script:QuickRef += [PSCustomObject]@{
            Name = $name
            Path = $skillDir
            Type = "member"
            Desc = $desc
        }
    }
    else {
        $script:QuickRef += [PSCustomObject]@{
            Name = $name
            Path = $skillDir
            Type = "standalone"
            Desc = $desc
        }
        
        $script:Standalone += [PSCustomObject]@{
            Name = $name
            Path = $skillDir
            Desc = $desc
            Keywords = $kws -join ", "
        }
    }
}

# Generate INDEX.md
$output = @"
# Skill Index

> Auto-generated. Do not edit manually.
> Regenerate with: ``.codex/scripts/index.sh`` or ``.codex/scripts/index.ps1``

---

## Quick Reference

| Skill | Path | Type |
|-------|------|------|
"@

foreach ($skill in $QuickRef | Sort-Object Name) {
    $output += "`n| ``$($skill.Name)`` | ``$($skill.Path)/`` | $($skill.Type) |"
}

$output += @"

---

## Skillsets

"@

foreach ($ss in $Skillsets | Sort-Object Name) {
    $output += @"

### ``$($ss.Name)``

**Path:** ``$($ss.Path)/``
"@
    if ($ss.Desc) {
        $output += "`n> $($ss.Desc)"
    }
    $output += "`n"
    
    $membersStr = ($ss.Members | ForEach-Object { "``$_``" }) -join ", "
    $output += "`n**Members:** $membersStr"
    
    if ($ss.Pipeline) {
        $output += "`n**Default Pipeline:** $($ss.Pipeline)"
    }
    $output += "`n"
    
    $output += "`n#### Members`n"
    
    foreach ($member in $QuickRef | Where-Object { $_.Type -eq "member" -and $_.Name -like "$($ss.Name)-*" } | Sort-Object Name) {
        $output += "`n- **``$($member.Name)``** — $($member.Desc)"
    }
    
    $output += "`n`n---`n"
}

$output += @"

## Standalone Skills

"@

foreach ($skill in $Standalone | Sort-Object Name) {
    $output += @"

### ``$($skill.Name)``

**Path:** ``$($skill.Path)/``
"@
    if ($skill.Desc) {
        $output += "`n> $($skill.Desc)"
    }
    $output += "`n"
    
    if ($skill.Keywords) {
        $kwsStr = ($skill.Keywords -split ", " | ForEach-Object { "``$_``" }) -join ", "
        $output += "`n**Keywords:** $kwsStr"
    }
    $output += "`n`n---`n"
}

$output += @"

## Keyword Index

| Keyword | Skills |
|---------|--------|
"@

foreach ($kw in $Keywords.Keys | Sort-Object) {
    $skillsStr = ($Keywords[$kw] | ForEach-Object { "``$_``" }) -join ", "
    $output += "`n| ``$kw`` | $skillsStr |"
}

$output += "`n"

Set-Content -Path $OutputFile -Value $output -Encoding UTF8

Write-Host "Generated: $OutputFile"
