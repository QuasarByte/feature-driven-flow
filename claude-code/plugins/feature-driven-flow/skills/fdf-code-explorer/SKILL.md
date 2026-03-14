---
name: fdf-code-explorer
description: Trace how the current repository behaves for a target feature. Use for discovery/behavior tracing of trigger points, execution paths, data contracts, system boundaries, and must-read files before changing code.
allowed-tools: Read, Glob, Grep
---

Task: $ARGUMENTS

When running shell reads in PowerShell, wrap filesystem paths in single quotes, especially absolute paths that may contain spaces.
If `rg` is unavailable, fall back to PowerShell-native discovery such as `Get-ChildItem -Recurse -File` and `Select-String`.

Read `${CLAUDE_SKILL_DIR}/behavior.md` and follow it exactly.
