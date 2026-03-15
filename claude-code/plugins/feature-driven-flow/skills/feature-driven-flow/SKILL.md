---
name: feature-driven-flow
description: Coordinate a structured 7-phase feature delivery workflow for non-trivial feature development. Use when a task needs scoped intent, repository behavior tracing, ambiguity resolution, design choices, controlled implementation, assurance, and end-state reporting.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

Task: $ARGUMENTS

FDF plugin root: ${CLAUDE_SKILL_DIR}/../..
Resolve shared FDF runtime assets from the first available root in this order:
1. project-local `./fdf/` at the target project root
2. global Claude home `fdf/` directory (for example `%USERPROFILE%\.claude\fdf` on Windows or `~/.claude/fdf` on macOS/Linux)
3. bundled plugin `fdf/` under the resolved plugin root
When running shell reads in PowerShell, wrap filesystem paths in single quotes, especially absolute paths that may contain spaces.
If `rg` is unavailable, fall back to PowerShell-native discovery such as `Get-ChildItem -Recurse -File` and `Select-String`.
Read `${CLAUDE_SKILL_DIR}/behavior.md` and follow it exactly.
