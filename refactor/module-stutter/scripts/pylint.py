from __future__ import annotations

import re
from typing import Optional

from pylint.checkers import BaseChecker
from pylint.interfaces import IAstroidChecker


_SPLIT = re.compile(r"[_\-]+")


def to_camel(s: str) -> str:
    parts = [p for p in _SPLIT.split(s) if p]
    return "".join(p[:1].upper() + p[1:] for p in parts)


class ModuleStutterChecker(BaseChecker):
    __implements__ = IAstroidChecker

    name = "module-stutter"
    priority = -1
    msgs = {
        "C9001": (
            "Public symbol '%s' stutters module '%s' (prefer %s.%s)",
            "module-name-stutter",
            "Avoid repeating the module/package name in exported identifiers.",
        )
    }

    options = (
        (
            "module_stutter_ignore",
            {
                "default": (),
                "type": "csv",
                "metavar": "<name1,name2,...>",
                "help": "Comma-separated module basenames to ignore (e.g. api,core,utils).",
            },
        ),
        (
            "module_stutter_ignore_symbol_regex",
            {
                "default": (),
                "type": "csv",
                "metavar": "<regex1,regex2,...>",
                "help": "Comma-separated regex patterns for symbol names to ignore.",
            },
        ),
    )

    def open(self):
        self._ignore_rx = [re.compile(r) for r in self.config.module_stutter_ignore_symbol_regex]

    def _module_basename(self, node) -> Optional[str]:
        mod = getattr(node.root(), "name", None)
        if not mod:
            return None
        return mod.split(".")[-1]

    def _is_public(self, name: str) -> bool:
        return not name.startswith("_")

    def _ignore_symbol(self, name: str) -> bool:
        return any(rx.search(name) for rx in self._ignore_rx)

    def visit_classdef(self, node):
        self._check(node, node.name)

    def visit_functiondef(self, node):
        # only module-level
        if node.parent and node.parent.__class__.__name__ == "ClassDef":
            return
        self._check(node, node.name)

    def _check(self, node, sym_name: str) -> None:
        mod = self._module_basename(node)
        if not mod:
            return
        if mod in self.config.module_stutter_ignore:
            return
        if not self._is_public(sym_name):
            return
        if self._ignore_symbol(sym_name):
            return

        prefix = to_camel(mod)
        if sym_name.startswith(prefix) and len(sym_name) > len(prefix):
            suggestion = sym_name[len(prefix):] or sym_name
            self.add_message(
                "module-name-stutter",
                node=node,
                args=(sym_name, mod, mod, suggestion),
            )


def register(linter):
    linter.register_checker(ModuleStutterChecker(linter))
