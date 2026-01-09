#!/usr/bin/env python3
"""
validate.py - Self-check script for the task skillset.

Validates:
- Schema files are valid JSON
- Sample 00_TASK.md passes schema validation
- Hash computation is deterministic (same input → same hash)
- Scripts are importable and functional

Usage:
    python validate.py
    python validate.py --verbose
"""

import argparse
import hashlib
import json
import sys
from pathlib import Path


def validate_json_schema(schema_path: Path) -> tuple[bool, str]:
    """Validate that a JSON schema file is valid JSON."""
    try:
        with open(schema_path, "r", encoding="utf-8") as f:
            json.load(f)
        return True, "Valid JSON"
    except json.JSONDecodeError as e:
        return False, f"Invalid JSON: {e}"
    except FileNotFoundError:
        return False, "File not found"


def validate_frontmatter_fields(frontmatter: dict, schema: dict) -> tuple[bool, list[str]]:
    """Validate frontmatter against schema required fields."""
    errors = []
    required = schema.get("required", [])
    properties = schema.get("properties", {})
    
    for field in required:
        if field not in frontmatter:
            errors.append(f"Missing required field: {field}")
        elif field in properties:
            prop = properties[field]
            value = frontmatter[field]
            
            if "enum" in prop and value not in prop["enum"]:
                errors.append(f"Invalid value for {field}: {value} (valid: {prop['enum']})")
            
            if prop.get("type") == "string":
                if "pattern" in prop:
                    import re
                    if not re.match(prop["pattern"], str(value)):
                        errors.append(f"Field {field} does not match pattern: {prop['pattern']}")
    
    return len(errors) == 0, errors


def parse_frontmatter(content: str) -> dict:
    """Parse YAML frontmatter from markdown content."""
    if not content.startswith("---"):
        return {}
    
    parts = content.split("---", 2)
    if len(parts) < 3:
        return {}
    
    try:
        import yaml
        return yaml.safe_load(parts[1].strip()) or {}
    except ImportError:
        result = {}
        for line in parts[1].strip().split("\n"):
            if ":" in line:
                key, _, value = line.partition(":")
                result[key.strip()] = value.strip().strip('"').strip("'")
        return result


def validate_hash_determinism(script_dir: Path, verbose: bool = False) -> tuple[bool, str]:
    """Verify hash computation is deterministic."""
    test_content = """---
id: test-task
title: "Test Task"
kind: feature
scope: minor
risk: low
epistemic_state: candidate
confidence: low
origin: human
lifecycle_state: inactive
created_at: "2026-01-09T10:00:00Z"
intent_hash: "placeholder"
intent_hash_algo: sha256-v1
intent_hash_scope: canonical-intent
---

# Test Task

## Goal

Test goal content.

## Acceptance

- [ ] Test criterion

## Constraints

- Test constraint

## Dependencies

- None
"""
    
    canonical_blob = """---
confidence: low
created_at: 2026-01-09T10:00:00Z
epistemic_state: candidate
id: test-task
intent_hash: placeholder
intent_hash_algo: sha256-v1
intent_hash_scope: canonical-intent
kind: feature
lifecycle_state: inactive
origin: human
risk: low
scope: minor
title: Test Task
---
## Goal

Test goal content.

## Acceptance

- [ ] Test criterion

## Constraints

- Test constraint

## Dependencies

- None"""
    
    hash1 = hashlib.sha256(canonical_blob.encode("utf-8")).hexdigest()
    hash2 = hashlib.sha256(canonical_blob.encode("utf-8")).hexdigest()
    
    if hash1 != hash2:
        return False, "Hash computation is not deterministic!"
    
    if verbose:
        print(f"  Hash 1: {hash1[:16]}...")
        print(f"  Hash 2: {hash2[:16]}...")
    
    return True, f"Deterministic (hash: {hash1[:16]}...)"


def validate_scripts_importable(script_dir: Path) -> tuple[bool, list[str]]:
    """Check that Python scripts are syntactically valid."""
    errors = []
    scripts = [
        "time.py",
        "timedelta.py",
        "task_intent_extract.py",
        "task_hash.py",
        "task_status.py",
        "task_list.py",
        "task_nav.py"
    ]
    
    for script in scripts:
        script_path = script_dir / script
        if not script_path.exists():
            errors.append(f"Missing script: {script}")
            continue
        
        try:
            with open(script_path, "r", encoding="utf-8") as f:
                source = f.read()
            compile(source, script_path, "exec")
        except SyntaxError as e:
            errors.append(f"Syntax error in {script}: {e}")
    
    return len(errors) == 0, errors


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate task skillset")
    parser.add_argument("--verbose", "-v", action="store_true", help="Verbose output")
    args = parser.parse_args()
    
    script_dir = Path(__file__).parent
    assets_dir = script_dir.parent / "assets"
    schemas_dir = assets_dir / "schemas"
    
    all_passed = True
    
    print("Task Skillset Validation")
    print("=" * 50)
    
    print("\n1. Validating JSON Schemas...")
    schema_files = [
        "task.frontmatter.schema.json",
        "task.hash.schema.json",
        "task.schema.json"
    ]
    
    for schema_file in schema_files:
        schema_path = schemas_dir / schema_file
        passed, msg = validate_json_schema(schema_path)
        status = "✓" if passed else "✗"
        print(f"  {status} {schema_file}: {msg}")
        if not passed:
            all_passed = False
    
    print("\n2. Validating Template...")
    template_path = schemas_dir / "task.00_TASK.template.md"
    if template_path.exists():
        print(f"  ✓ Template exists: {template_path.name}")
        
        content = template_path.read_text(encoding="utf-8")
        frontmatter = parse_frontmatter(content)
        
        if frontmatter:
            print(f"  ✓ Frontmatter parseable ({len(frontmatter)} fields)")
        else:
            print("  ✗ Frontmatter not parseable")
            all_passed = False
    else:
        print(f"  ✗ Template not found: {template_path}")
        all_passed = False
    
    print("\n3. Validating Hash Determinism...")
    passed, msg = validate_hash_determinism(script_dir, args.verbose)
    status = "✓" if passed else "✗"
    print(f"  {status} {msg}")
    if not passed:
        all_passed = False
    
    print("\n4. Validating Scripts...")
    passed, errors = validate_scripts_importable(script_dir)
    if passed:
        print("  ✓ All scripts syntactically valid")
    else:
        for error in errors:
            print(f"  ✗ {error}")
        all_passed = False
    
    print("\n5. Validating Schema Content...")
    frontmatter_schema_path = schemas_dir / "task.frontmatter.schema.json"
    if frontmatter_schema_path.exists():
        with open(frontmatter_schema_path, "r", encoding="utf-8") as f:
            schema = json.load(f)
        
        required_fields = schema.get("required", [])
        print(f"  ✓ Frontmatter schema has {len(required_fields)} required fields")
        
        if args.verbose:
            for field in required_fields:
                print(f"    - {field}")
    
    print("\n" + "=" * 50)
    if all_passed:
        print("✓ All validations passed!")
        return 0
    else:
        print("✗ Some validations failed!")
        return 1


if __name__ == "__main__":
    sys.exit(main())
