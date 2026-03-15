---
description: FDF — run the full 7-phase Feature-Driven-Flow workflow for a task
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

Task: $ARGUMENTS

Requirements:
1. Treat this command as the slash-command entrypoint alias for the main `feature-driven-flow` conductor.
2. Invoke the plugin skill `feature-driven-flow:feature-driven-flow` with the provided task and follow that conductor exactly.
3. Execute all 7 phases in fixed order and honor all gates before advancing.
4. Use the same settings, pack resolution, matrix handling, and effective-instructions behavior as the conductor skill.