# Quickstart

The following section describes how to use the skills with various agentic setups.

## Clone the Repo

**Before "installing" the agent skills**, start by cloning the repo:

```bash
git clone https://github.com/JordanGunn/skills
```

---

## Codex

If utilizing codex through the CLI or via an IDE extension, you have two options:

### Instructions

Copy the cloned directory from the `Clone the repo` section to `$HOME/.codex/skills/`.

#### Unix

```bash
cp -r skills $HOME/.codex/skills/
```

#### Windows

```powershell
Copy-Item -Path skills -Destination $env:USERPROFILE\.codex\skills\ -Recurse
```

---

## Windsurf

### Option A: Using `adapter-windsurf` with an existing agent

If you already have the skills installed with an existing agent (e.g. `codex`), simply invoke the `adapter-windsurf` skill.

This will autogenerate Windsurf workflows in the working directory that leverage the existing skills.

### Option B: Running the skill script resource

If you don't have the skills setup with an existing agent, you can run the adapter script directly:

**Unix:**
```bash
skills/adapter/windsurf/scripts/generate.sh
```

**Windows:**
```powershell
skills\adapter\windsurf\scripts\generate.ps1
```

---

## Cursor

### Option A: Using `adapter-cursor` with an existing agent

If you already have the skills installed with an existing agent (e.g. `codex`), simply invoke the `adapter-cursor` skill.

This will autogenerate Cursor commands in the working directory that leverage the existing skills.

### Option B: Running the skill script resource

If you don't have the skills setup with an existing agent, you can run the adapter script directly:

**Unix:**
```bash
skills/adapter/cursor/scripts/generate.sh
```

**Windows:**
```powershell
skills\adapter\cursor\scripts\generate.ps1
```

---

## Next Steps

- Read the [Skills Reference](./02_SKILLS.md) to explore available skills
- Learn about [Skillsets](./03_SKILLSETS.md) for coordinating multiple skills
- Review [Schema Documentation](./04_SCHEMAS.md) to understand skill structure
- Check [Contributing Guidelines](./05_CONTRIBUTING.md) to add your own skills
