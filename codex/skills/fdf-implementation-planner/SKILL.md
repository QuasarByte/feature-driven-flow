---
name: fdf-implementation-planner
description: Turn clarified requirements into an implementation strategy anchored in repository realities. Use when defining module boundaries, interface updates, file-level work maps, and sequencing.
---

When running shell reads in PowerShell, wrap filesystem paths in single quotes, especially absolute paths that may contain spaces.
If `rg` is unavailable, fall back to PowerShell-native discovery such as `Get-ChildItem -Recurse -File` and `Select-String`.

Read `./behavior.md` and follow it exactly.
