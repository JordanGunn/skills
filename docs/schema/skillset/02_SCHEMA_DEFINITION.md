# Schema Definition
```yaml
metadata:
  skillset:
    name: string                    # Required: Skillset identifier
    schema_version: integer         # Required: Currently 1
    skills: [string]                # Required: Member skill names
    resources:                      # Optional: Shared resources
      root: string                  # Resources directory path
      assets: [string]              # Shared asset files
      scripts: [string]             # Shared script files
      references: [string]          # Shared reference files
    pipelines:                      # Required: Execution pipelines
      default: [string]             # Default execution order
      allowed: [[string]]           # Valid skill sequences
    requires: [string]              # Optional: Dependencies (TBD)
```
