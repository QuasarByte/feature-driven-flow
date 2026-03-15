---
name: feature-driven-flow
description: Coordinate a structured 7-phase feature delivery workflow in Codex for non-trivial work. Use when a task needs scoped intent, repository behavior tracing, ambiguity resolution, design choices, controlled implementation, assurance, and end-state reporting.
---

Resolve shared FDF runtime assets from the first available root in this order:
1. project-local `./fdf/` at the target project root
2. global Codex home `fdf/` directory (for example `%USERPROFILE%\.codex\fdf` on Windows or `~/.codex/fdf` on macOS/Linux)
Never resolve shared schemas or scripts from the installed skill directory itself.
Resolve schema, script, template, reference, and pack paths from the selected `fdf/` runtime root.

Read `./behavior.md` and follow it exactly.
