# ARCHITECTURE.md

This file is the short, stable architecture entrypoint for the `feature-driven-flow` repository.

Use the detailed architecture reference for full layout and packaging details:
[docs/fdf-cross-agent-architecture.md](./docs/fdf-cross-agent-architecture.md)

## Purpose

This repository develops one framework for multiple AI coding runtimes.

Current supported runtimes:

1. Codex
2. Claude Code

The design goal is behavioral parity with thin runtime-specific wrappers.

## Architectural Model

The repository is organized in three layers:

1. `shared/fdf/`
   Canonical runtime assets: settings, schemas, rules, profiles, packs, references, templates, manifests, and shared scripts.
2. `codex/`
   Codex-specific prompts, skills, and packaging wrapper.
3. `claude-code/`
   Claude Code plugin sources, slash commands, skills, and packaging wrapper.

## Core Invariants

1. Shared framework behavior belongs in `shared/fdf/`, not in runtime wrappers.
2. Codex and Claude wrappers may differ in entrypoint format and local conventions, but should preserve the same seven-phase FDF behavior.
3. Build outputs in `distrib/` are generated artifacts, not source of truth.
4. Runtime-specific maintainer guidance belongs in wrappers only when it cannot be expressed as cross-agent policy in `AGENTS.md`.

## Workflow Invariant

FDF always runs the same seven phases in the same order:

`Scope -> Explore -> Clarify -> Architect -> Implement -> Verify -> Summarize`

## Where To Look Next

1. Cross-agent layout and packaging:
   [docs/fdf-cross-agent-architecture.md](./docs/fdf-cross-agent-architecture.md)
2. Runtime semantics and precedence:
   [docs/specification.md](./docs/specification.md)
3. Validation and release checks:
   [docs/validation-types-playbook.md](./docs/validation-types-playbook.md)
4. Dialog E2E testing:
   [docs/testing/README.md](./docs/testing/README.md)
5. Maintainer contract:
   [AGENTS.md](./AGENTS.md)
