#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-docs/planning}"

mkdir -p "$ROOT"

max_n=0
shopt -s nullglob
for d in "$ROOT"/phase-*; do
  base="$(basename "$d")"
  if [[ "$base" =~ ^phase-([0-9]+)$ ]]; then
    n="${BASH_REMATCH[1]}"
    # strip leading zeros safely by forcing base-10
    n=$((10#$n))
    if (( n > max_n )); then
      max_n="$n"
    fi
  fi
done

next_n=$((max_n + 1))
phase_dir="$ROOT/phase-$next_n"

if [[ -e "$phase_dir" ]]; then
  echo "ERROR: $phase_dir already exists. Refusing to overwrite." >&2
  exit 2
fi

mkdir -p "$phase_dir"

echo "$phase_dir"
