#!/usr/bin/env bash
# Validate the loaded persona spec against schema
# Usage: validate.sh
# Exit codes: 0=valid, 1=invalid, 2=empty

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MIMIC_ROOT="$SCRIPT_DIR/.."
SLOT_FILE="$MIMIC_ROOT/assets/persona/spec.yaml"
SCHEMA_FILE="$MIMIC_ROOT/assets/schema.yaml"

# Check if slot is empty
if [[ ! -f "$SLOT_FILE" ]]; then
    echo "empty"
    exit 2
fi

# Required fields for a valid persona spec
required_fields=("name" "identity" "rules" "bits" "hooks" "budget")

valid=true
for field in "${required_fields[@]}"; do
    value=$(yq -r ".$field // empty" "$SLOT_FILE")
    if [[ -z "$value" ]]; then
        echo "invalid: missing required field '$field'" >&2
        valid=false
    fi
done

# Check nested required fields
if [[ $(yq -r '.rules.always // empty' "$SLOT_FILE") == "" ]]; then
    echo "invalid: missing rules.always" >&2
    valid=false
fi
if [[ $(yq -r '.rules.never // empty' "$SLOT_FILE") == "" ]]; then
    echo "invalid: missing rules.never" >&2
    valid=false
fi
if [[ $(yq -r '.hooks.init // empty' "$SLOT_FILE") == "" ]]; then
    echo "invalid: missing hooks.init" >&2
    valid=false
fi
if [[ $(yq -r '.hooks.exit // empty' "$SLOT_FILE") == "" ]]; then
    echo "invalid: missing hooks.exit" >&2
    valid=false
fi

if [[ "$valid" == "true" ]]; then
    name=$(yq -r '.name' "$SLOT_FILE")
    echo "valid: $name"
    exit 0
else
    echo "invalid"
    exit 1
fi
