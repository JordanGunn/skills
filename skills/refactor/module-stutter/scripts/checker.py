
#!/usr/bin/env python3
from __future__ import annotations

import argparse
import ast
import re
import subprocess
import sys
from collections.abc import Iterable
from dataclasses import dataclass
from pathlib import Path
from typing import Optional


@dataclass(frozen=True)
class Finding:
    path: str
    lineno: int
    col: int
    kind: str  # "class" | "function"
    name: str
    module_base: str
    prefix: str
    suggestion: str
    severity: str  # "Strongly Recommended" | "Suggestions"
    stutter_type: str  # "prefix" | "infix" | "suffix"


_CAMEL_SPLIT = re.compile(r"[_\-]+")


def to_camel(module_base: str) -> str:
    parts = [p for p in _CAMEL_SPLIT.split(module_base) if p]
    return "".join(p[:1].upper() + p[1:] for p in parts)


def git_changed_files() -> list[str]:
    # Works in most CI contexts; fall back gracefully.
    try:
        out = subprocess.check_output(
            ["git", "diff", "--name-only", "--diff-filter=ACMRTUXB", "HEAD"],
            stderr=subprocess.DEVNULL,
            text=True,
        ).strip()
        if not out:
            # maybe running locally with unstaged changes
            out = subprocess.check_output(
                ["git", "diff", "--name-only", "--diff-filter=ACMRTUXB"],
                stderr=subprocess.DEVNULL,
                text=True,
            ).strip()
        return [line for line in out.splitlines() if line.endswith(".py")]
    except Exception:
        return []


def read_text(path: Path) -> Optional[str]:
    try:
        return path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        # Some repos have odd encodings; skip safely.
        return None
    except FileNotFoundError:
        return None


def extract_dunder_all(tree: ast.AST) -> Optional[set[str]]:
    """
    If __all__ is defined as a list/tuple of string literals, return that set.
    Handles starred expressions like __all__ = [*classes, *funcs] by resolving
    module-level variable references.
    Otherwise None (meaning: check all top-level public defs).
    """
    if not isinstance(tree, ast.Module):
        return None

    # First pass: collect module-level string list assignments
    string_lists: dict[str, set[str]] = {}
    for node in tree.body:
        if isinstance(node, ast.Assign) and len(node.targets) == 1:
            target = node.targets[0]
            if isinstance(target, ast.Name) and isinstance(node.value, (ast.List, ast.Tuple)):
                strings: set[str] = set()
                all_strings = True
                for elt in node.value.elts:
                    if isinstance(elt, ast.Constant) and isinstance(elt.value, str):
                        strings.add(elt.value)
                    else:
                        all_strings = False
                        break
                if all_strings:
                    string_lists[target.id] = strings

    # Second pass: find __all__ and resolve it
    for node in tree.body:
        if isinstance(node, ast.Assign):
            for target in node.targets:
                if isinstance(target, ast.Name) and target.id == "__all__":
                    val = node.value
                    if isinstance(val, (ast.List, ast.Tuple)):
                        items: set[str] = set()
                        for elt in val.elts:
                            if isinstance(elt, ast.Constant) and isinstance(elt.value, str):
                                items.add(elt.value)
                            elif isinstance(elt, ast.Starred):
                                # Handle [*classes, *funcs] pattern
                                if isinstance(elt.value, ast.Name):
                                    ref_name = elt.value.id
                                    if ref_name in string_lists:
                                        items.update(string_lists[ref_name])
                                    else:
                                        return None  # Can't resolve reference
                                else:
                                    return None
                            else:
                                return None
                        return items
                    return None
    return None


def is_public(name: str) -> bool:
    return not name.startswith("_")


def should_ignore_symbol(name: str, ignore_symbol_regex: list[re.Pattern[str]]) -> bool:
    return any(rx.search(name) for rx in ignore_symbol_regex)


def to_snake(module_base: str) -> str:
    """Convert module basename to snake_case for matching."""
    return module_base.lower().replace("-", "_")


def detect_stutter(
    name: str, module_base: str, camel_prefix: str
) -> tuple[bool, str, str]:
    """
    Detect if name contains module stutter in any position.
    Returns (is_stutter, stutter_type, matched_pattern) where stutter_type is 'prefix'|'infix'|'suffix'.
    """
    snake = to_snake(module_base)
    name_lower = name.lower()

    # Prefix check: CamelCase prefix (e.g., FragmentWriter)
    if name.startswith(camel_prefix) and len(name) > len(camel_prefix):
        return True, "prefix", camel_prefix

    # Snake_case patterns in function names
    # Infix: write_from_batch, process_fragment_data
    if f"_{snake}_" in name_lower:
        return True, "infix", snake

    # Suffix: create_fragment, build_fragment
    if name_lower.endswith(f"_{snake}"):
        return True, "suffix", snake

    # CamelCase infix: WriteFragmentData, ProcessFragmentBatch
    if camel_prefix in name and not name.startswith(camel_prefix):
        return True, "infix", camel_prefix

    # CamelCase suffix: WriteBatch where module is batch.py
    if name.endswith(camel_prefix) and len(name) > len(camel_prefix):
        return True, "suffix", camel_prefix

    return False, "", ""


def suggest_rename(name: str, stutter_type: str, matched_pattern: str) -> str:
    """
    Suggest a renamed symbol by removing the stuttering module name.
    """
    if stutter_type == "prefix":
        rest = name[len(matched_pattern):]
        return rest.lstrip("_") or name

    if stutter_type == "suffix":
        # Handle snake_case suffix: create_fragment -> create
        if name.lower().endswith(f"_{matched_pattern.lower()}"):
            return name[: -(len(matched_pattern) + 1)]  # +1 for underscore
        # Handle CamelCase suffix: WriteBatch -> Write
        if name.endswith(matched_pattern):
            return name[: -len(matched_pattern)] or name

    if stutter_type == "infix":
        # Handle snake_case infix: write_from_batch -> write_from_batch
        snake_pattern = matched_pattern.lower()
        name_lower = name.lower()
        if f"_{snake_pattern}_" in name_lower:
            idx = name_lower.find(f"_{snake_pattern}_")
            return name[:idx] + name[idx + len(snake_pattern) + 1 :]
        # Handle CamelCase infix: WriteFragmentData -> WriteData
        if matched_pattern in name:
            return name.replace(matched_pattern, "", 1)

    return name


def iter_top_level_defs(tree: ast.Module) -> Iterable[tuple[str, str, int, int]]:
    """
    Yield (kind, name, lineno, col) for top-level class/function defs.
    kind: "class" | "function"
    """
    for node in tree.body:
        if isinstance(node, ast.ClassDef):
            yield ("class", node.name, node.lineno, node.col_offset)
        elif isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
            yield ("function", node.name, node.lineno, node.col_offset)


def iter_reexported_names(
    tree: ast.Module, exported: Optional[set[str]]
) -> Iterable[tuple[str, str, int, int]]:
    """
    Yield (kind, name, lineno, col) for names imported and re-exported via __all__.
    Used for __init__.py files that re-export from submodules.
    kind: "reexport"
    """
    if exported is None:
        return

    # Collect all imported names with their locations
    imported: dict[str, tuple[int, int]] = {}
    for node in tree.body:
        if isinstance(node, ast.ImportFrom):
            for alias in node.names:
                name = alias.asname if alias.asname else alias.name
                imported[name] = (node.lineno, node.col_offset)

    # Yield names that are both imported and in __all__
    for name in exported:
        if name in imported:
            lineno, col = imported[name]
            yield ("reexport", name, lineno, col)


def scan_file(
    path: Path,
    ignore_modules: set[str],
    ignore_symbol_regex: list[re.Pattern[str]],
) -> list[Finding]:
    text = read_text(path)
    if text is None:
        return []

    try:
        tree = ast.parse(text, filename=str(path))
    except SyntaxError:
        # Don't block on broken files; report nothing (or could emit a note).
        return []

    # For __init__.py, use parent directory as the package name
    if path.stem == "__init__":
        module_base = path.parent.name
    else:
        module_base = path.stem  # e.g., work_unit from work_unit.py
    if module_base in ignore_modules:
        return []

    prefix = to_camel(module_base)  # WorkUnit
    exported = extract_dunder_all(tree)  # if present, only enforce on those names

    findings: list[Finding] = []

    # Check top-level definitions (classes, functions)
    for kind, name, lineno, col in iter_top_level_defs(tree):
        if not is_public(name):
            continue
        if exported is not None and name not in exported:
            continue
        if should_ignore_symbol(name, ignore_symbol_regex):
            continue

        is_stutter, stutter_type, matched_pattern = detect_stutter(name, module_base, prefix)
        if is_stutter:
            suggestion = suggest_rename(name, stutter_type, matched_pattern)
            severity = "Strongly Recommended" if exported is not None else "Suggestions"
            findings.append(
                Finding(
                    path=str(path),
                    lineno=lineno,
                    col=col,
                    kind=kind,
                    name=name,
                    module_base=module_base,
                    prefix=prefix,
                    suggestion=suggestion,
                    severity=severity,
                    stutter_type=stutter_type,
                )
            )

    # For __init__.py, also check re-exported names from submodules
    if path.stem == "__init__":
        for kind, name, lineno, col in iter_reexported_names(tree, exported):
            if should_ignore_symbol(name, ignore_symbol_regex):
                continue

            is_stutter, stutter_type, matched_pattern = detect_stutter(
                name, module_base, prefix
            )
            if is_stutter:
                suggestion = suggest_rename(name, stutter_type, matched_pattern)
                findings.append(
                    Finding(
                        path=str(path),
                        lineno=lineno,
                        col=col,
                        kind=kind,
                        name=name,
                        module_base=module_base,
                        prefix=prefix,
                        suggestion=suggestion,
                        severity="Strongly Recommended",  # re-exports are public API
                        stutter_type=stutter_type,
                    )
                )

    return findings


def render_report(findings: list[Finding]) -> str:
    if not findings:
        return (
            "# Module Stutter Audit\n\n"
            "No module/package stutter found in the scanned Python files.\n"
        )

    strongly = [f for f in findings if f.severity == "Strongly Recommended"]
    suggest = [f for f in findings if f.severity == "Suggestions"]

    def section(title: str, items: list[Finding]) -> str:
        if not items:
            return ""
        lines = [f"## {title}\n"]
        for f in items:
            lines.append(f"### {f.path}:{f.lineno} — {f.kind} `{f.name}`\n")
            lines.append(
                f"- **Why**: `{f.name}` repeats the semantic namespace already provided by module `{f.module_base}` "
                f"({f.stutter_type} stutter), creating noise.\n"
            )
            lines.append(
                f"- **Minimal fix**: rename `{f.name}` → `{f.suggestion}` and rely on module context:\n"
                f"  - `import {f.module_base}` → `{f.module_base}.{f.suggestion}(...)` or `{f.module_base}.{f.suggestion}.open(...)`\n"
            )
            lines.append(
                "- **Safe intermediate step** (if rename is risky):\n"
                "  - export an alias at the package boundary (or keep deprecated name temporarily) and migrate callsites gradually.\n"
            )
        return "\n".join(lines) + "\n"

    summary = (
        "# Module Stutter Audit\n\n"
        "This report flags public/top-level Python identifiers that **repeat their module’s semantic namespace** "
        "(e.g., `las.File`). Prefer letting the **import path carry context** (e.g., `las.File`).\n\n"
        f"Scanned findings: **{len(findings)}** (Strongly Recommended: **{len(strongly)}**, Suggestions: **{len(suggest)}**)\n"
    )

    return summary + "\n" + section("Strongly Recommended", strongly) + section("Suggestions", suggest)


def main() -> int:
    p = argparse.ArgumentParser(description="Detect module/package name stutter in Python public symbols.")
    p.add_argument("paths", nargs="*", help="Files or directories to scan. If omitted, use --changed-only or CWD.")
    p.add_argument("--changed-only", action="store_true", help="Scan only git-changed .py files.")
    p.add_argument("--ignore-module", action="append", default=[], help="Ignore a module basename (e.g., utils).")
    p.add_argument(
        "--ignore-symbol-regex",
        action="append",
        default=[],
        help="Ignore symbol names matching regex (repeatable). Example: '^(LAS|LAZ)[A-Z]'",
    )
    p.add_argument("--out", default="", help="Write Markdown report to this file (default: stdout).")
    p.add_argument("--no-fail", action="store_true", help="Always exit 0, even if findings exist.")
    args = p.parse_args()

    ignore_modules = set(args.ignore_module)
    ignore_symbol_regex = [re.compile(r) for r in args.ignore_symbol_regex]

    targets: list[Path] = []

    if args.changed_only:
        changed = git_changed_files()
        targets.extend(Path(x) for x in changed)

    if args.paths:
        for raw in args.paths:
            path = Path(raw)
            if path.is_dir():
                targets.extend(path.rglob("*.py"))
            else:
                targets.append(path)

    if not targets:
        # default scan: current directory python files
        targets = list(Path(".").rglob("*.py"))

    findings: list[Finding] = []
    seen: set[str] = set()
    for t in targets:
        t = t.resolve()
        if str(t) in seen:
            continue
        seen.add(str(t))
        # skip venvs / hidden dirs quickly
        parts = set(t.parts)
        if any(x in parts for x in (".venv", "venv", "__pycache__", ".git")):
            continue
        findings.extend(scan_file(t, ignore_modules, ignore_symbol_regex))

    report = render_report(findings)

    if args.out:
        Path(args.out).write_text(report, encoding="utf-8")
    else:
        sys.stdout.write(report)

    if findings and not args.no_fail:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
