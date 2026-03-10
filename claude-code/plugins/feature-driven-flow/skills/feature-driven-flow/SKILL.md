---
name: feature-driven-flow
description: Coordinate a structured 7-phase feature delivery workflow for non-trivial feature development. Use when a task needs scoped intent, repository behavior tracing, ambiguity resolution, design choices, controlled implementation, assurance, and end-state reporting.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

Task: $ARGUMENTS

FDF plugin root: ${CLAUDE_SKILL_DIR}/../..
Read `${CLAUDE_SKILL_DIR}/behavior.md` and follow it exactly.
