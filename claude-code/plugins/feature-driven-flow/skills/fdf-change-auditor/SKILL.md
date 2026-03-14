---
name: fdf-change-auditor
description: Audit implementation changes for correctness and reliability. Use when validating provided diffs or ranges and producing evidence-backed findings before closure.
allowed-tools: Read, Glob, Grep, Bash
---

Task: $ARGUMENTS

When running shell reads in PowerShell, wrap filesystem paths in single quotes, especially absolute paths that may contain spaces.
If `rg` is unavailable, fall back to PowerShell-native discovery such as `Get-ChildItem -Recurse -File` and `Select-String`.

Read `${CLAUDE_SKILL_DIR}/behavior.md` and follow it exactly.
