# Required Fields

### `name`

- **Type:** String
- **Constraints:**
  - 1-64 characters
  - Lowercase letters, numbers, and hyphens only
  - Must not start or end with hyphen
  - Must not contain consecutive hyphens
  - Must match parent directory name
- **Example:** `plan-create`

### `description`

- **Type:** String (can use YAML multiline)
- **Constraints:**
  - 1-1024 characters
  - Should describe what the skill does and when to use it
- **Example:**

  ```yaml
  description: >
    Materialize the current conversation into a new docs/planning/phase-N plan
    (root plan plus sub-plans and task files).
  ```

