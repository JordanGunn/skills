# Optional Fields

### `license`

- **Type:** String
- **Purpose:** License identifier
- **Example:** `MIT`, `Apache-2.0`, `Proprietary`

### `compatibility`

- **Type:** String
- **Constraints:** Max 500 characters
- **Purpose:** Environment requirements
- **Example:** `Requires git, docker, and internet access`

### `allowed-tools`

- **Type:** String (space-delimited list)
- **Purpose:** Pre-approved tools (experimental)
- **Example:** `Bash(git:*) Bash(jq:*) Read`

### `metadata`

- **Type:** Object
- **Purpose:** Additional metadata and skill resources
- **Fields:**
  - `author`: Author name or organization
  - `version`: Semantic version string
  - `references`: List of reference file paths
  - `scripts`: List of script file paths
  - `keywords`: List of keywords for discovery
  - `skillset`: Skillset configuration (for orchestrator skills only)

