# Outputs

## Success

On successful creation, output:

```
Created task: {id}
  Path: {root}/{id}/
  Created: {created_at}
  Hash: {intent_hash_short}...
  State: candidate / inactive
```

## Failure Modes

### Invalid ID

```
Error: Invalid task ID '{id}'
  - Must be lowercase letters, numbers, and hyphens
  - Must not start or end with hyphen
  - Must be 1-64 characters
```

### Conflict

```
Error: Task directory already exists: {root}/{id}/
  - Use a different ID or remove existing task
```

### Missing Required Field

```
Error: Missing required field: {field}
  - Required fields: id, title, kind, scope, risk, origin
```

### Invalid Enum Value

```
Error: Invalid value for '{field}': '{value}'
  - Valid values: {enum_values}
```
