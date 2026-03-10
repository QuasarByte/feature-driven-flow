# FDF Cross-Agent Architecture

Date: 2026-03-08
Status: Current - reflects implemented state

## 1. Purpose

This document explains repository layout, wrapper boundaries, packaging flow, and agent parity for FDF.

Use it for:

1. source layout
2. shared-vs-wrapper asset boundaries
3. packaging and install model
4. cross-agent parity expectations

Use other docs for:

1. runtime behavior and artifact contracts: `docs/specification.md`
2. validation operations: `docs/validation-types-playbook.md`
3. Claude release repo details: `docs/distribution/claude-feature-driven-flow-repo-spec.md`

## 2. Overview

Feature-Driven-Flow (FDF) supports multiple agent runtimes. The first two are **Codex** and **Claude Code**.

The design principle is simple:

1. thin agent-specific wrapper layers
2. one shared runtime asset tree
3. package-time normalization into the runtime layout each agent expects

## 3. Repository Layout

Two repositories are involved.

### 3.1 Development Repository - `feature-driven-flow`

Source of truth for all development. Contains both the Codex and Claude Code implementations.

```text
feature-driven-flow/
│
├── codex/                               ← Codex agent layer
│   ├── skills/
│   │   ├── feature-driven-flow/
│   │   │   ├── SKILL.md                 ← Codex frontmatter
│   │   │   ├── behavior.md              ← Codex-optimized conductor instructions
│   │   │   └── agents/openai.yaml       ← Codex agent config
│   │   ├── fdf-code-explorer/
│   │   ├── fdf-implementation-planner/
│   │   └── fdf-change-auditor/
│   └── prompts/
│       ├── fdf-start.md                 ← Codex main prompt
│       └── fdf-*.md                     ← utility prompts
│
├── claude-code/                         ← Claude marketplace source layer
│   ├── .claude-plugin/
│   │   └── marketplace.json             ← marketplace catalog source
│   ├── plugins/
│   │   └── feature-driven-flow/         ← plugin source subtree
│   │       ├── .claude-plugin/
│   │       │   └── plugin.json          ← plugin manifest
│   │       ├── skills/
│   │       │   ├── feature-driven-flow/
│   │       │   │   ├── SKILL.md         ← Claude frontmatter + allowed-tools
│   │       │   │   └── behavior.md      ← Claude-optimized conductor instructions
│   │       │   ├── fdf-code-explorer/
│   │       │   ├── fdf-implementation-planner/
│   │       │   └── fdf-change-auditor/
│   │       ├── commands/
│   │       │   └── fdf-*.md             ← slash commands
│   │       └── README.md                ← plugin README source
│   └── README.md                        ← marketplace README source
│
├── shared/
│   └── fdf/                             ← shared runtime assets for both agents
│       ├── schemas/
│       ├── skills/feature-driven-flow/
│       │   ├── settings.json
│       │   ├── manifest.json
│       │   ├── extensions/
│       │   ├── packs/
│       │   ├── references/
│       │   └── templates/
│       └── scripts/
│           └── convert-effective-instructions.ps1
│
├── tools/                               ← dev tooling
├── docs/                                ← dev documentation
├── distrib/                             ← build output (gitignored)
└── README.md
```

### 3.2 Claude Marketplace Repository - `feature-driven-flow-claude`

Release-only. Marketplace at repo root, with the FDF plugin published from a subdirectory and no dev artifacts or Codex-specific files.

```text
feature-driven-flow-claude/
├── .claude-plugin/marketplace.json
├── plugins/
│   └── feature-driven-flow/
│       ├── .claude-plugin/plugin.json
│       ├── skills/
│       ├── commands/
│       ├── fdf/
│       └── README.md
└── README.md
```

## 4. Layer Responsibilities

The repository has three layers with different responsibilities:

1. `codex/`
   Codex-facing entrypoints and wrapper behavior.
2. `claude-code/`
   Claude-facing entrypoints and wrapper behavior.
3. `shared/fdf/`
   Shared runtime assets reused by both agents.

The shared layer contains the framework-defining assets:

1. schemas
2. settings defaults
3. core rules and profiles
4. packs
5. templates
6. references
7. artifact conversion utilities

## 5. Agent-Specific Layer Design

### 5.1 Why Each Agent Has Its Own Layer

Claude Code and Codex have incompatible entrypoint formats and local conventions.

| Concern | Codex | Claude Code |
|---|---|---|
| Frontmatter fields | `name`, `description` | `description`, `allowed-tools` |
| Agent interface config | `agents/openai.yaml` | none |
| Policy file | `AGENTS.md` | `CLAUDE.md` |
| Local settings path | `.codex/feature-driven-flow/` | `.claude/feature-driven-flow/` |
| User entrypoint | `/prompts:fdf-*` | `/feature-driven-flow:fdf-*` |

### 5.2 `behavior.md` Per Agent

Each agent has its own `behavior.md`. They implement the same seven-phase logic but with agent-specific path and policy conventions.

| Element | Codex `behavior.md` | Claude Code `behavior.md` |
|---|---|---|
| Policy file | `AGENTS.md` | `CLAUDE.md` |
| Local rules path | `.codex/feature-driven-flow/rules/` | `.claude/feature-driven-flow/rules/` |
| Plugin/runtime data path | `fdf/` in project root | `fdf/` in plugin root |
| Specialist invocation style | skill references | slash command references |

### 5.3 Entry Point Format

**Codex** skill entrypoint:

```markdown
---
name: feature-driven-flow
description: Coordinate a structured 7-phase feature delivery workflow...
---

Task: $ARGUMENTS

Read `fdf/skills/feature-driven-flow/behavior.md` and follow it exactly.
```

**Claude Code** skill entrypoint:

```markdown
---
name: feature-driven-flow
description: Coordinate a structured 7-phase feature delivery workflow...
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

Task: $ARGUMENTS

FDF plugin root: ${CLAUDE_SKILL_DIR}/../..
Read `${CLAUDE_SKILL_DIR}/behavior.md` and follow it exactly.
```

## 6. Distribution Self-Containment

In the development repository, shared runtime assets live in `shared/fdf/` and are reused by both agents. The distribution builders package those assets into `fdf/` so each released artifact remains self-contained at runtime.

Why this exists:

1. an earlier shared-top-level layout was awkward for subtree-style distribution
2. Claude releases need a self-contained plugin tree
3. Codex installs also expect a normalized `fdf/` runtime directory

Claude runtime path after install:

```text
~/.claude/plugins/cache/feature-driven-flow/
├── skills/feature-driven-flow/
│   ├── SKILL.md                         ← ${CLAUDE_SKILL_DIR}
│   └── behavior.md
├── fdf/
│   ├── schemas/
│   ├── skills/feature-driven-flow/
│   └── scripts/
└── commands/
```

`${CLAUDE_SKILL_DIR}/../..` resolves to the plugin root at any install location.

## 7. Install Targets

### 7.1 Claude Code Marketplace Install

```bash
/plugin marketplace add QuasarByte/feature-driven-flow-claude
/plugin install feature-driven-flow@quasarbyte-plugins
```

Claude Code adds the repository as a marketplace, then installs `feature-driven-flow` from that marketplace.
The supported marketplace command form is namespaced by plugin id, for example `/feature-driven-flow:fdf-start`.

### 7.2 Codex

Codex has no native plugin model. Install is manual:

```bash
cp -r distrib/feature-driven-flow-codex/skills/* $CODEX_HOME/skills/
cp -r distrib/feature-driven-flow-codex/fdf/ ./fdf/
cp distrib/feature-driven-flow-codex/prompts/*.md $CODEX_HOME/prompts/
```

Settings resolution for Codex:

| Priority | Path |
|---|---|
| 1 | `fdf/skills/feature-driven-flow/settings.json` |
| 2 | `.codex/feature-driven-flow/settings.json` |
| 3 | User-confirmed overrides during Scope |

## 8. Distribution Pipeline

### 8.1 Claude Code

```text
feature-driven-flow  (dev repo)
    │
    │  pwsh tools/build-distribution-claude.ps1 -Version x.y.z -Force
    ▼
distrib/feature-driven-flow-claude/
    │
    │  deploy script + git commit + git push
    ▼
feature-driven-flow-claude  (marketplace repo)
```

The Claude build script:

1. validates Claude wrapper sources and shared runtime sources
2. clears the output directory
3. writes marketplace metadata at repo root from `claude-code/.claude-plugin/`
4. assembles the plugin into `plugins/feature-driven-flow/`
5. optionally patches marketplace and plugin version metadata

### 8.2 Codex

```text
feature-driven-flow  (dev repo)
    │
    │  pwsh tools/build-distribution-codex.ps1 -Version x.y.z -Force
    ▼
distrib/feature-driven-flow-codex/
    │
    │  manual install into $CODEX_HOME + project ./fdf/
    ▼
Codex runtime
```

The Codex build script:

1. validates Codex wrapper sources and shared runtime sources
2. clears the output directory
3. copies `skills/`, `prompts/`, shared `fdf/` assets, `README.md`, and `version.json`
4. rewrites packaged runtime paths where needed
5. optionally patches the package version

## 9. Repo-Local Customization

Users customize FDF in their own project repos, never in the distribution.

| Agent | Settings | Local rules | Local packs |
|---|---|---|---|
| Claude Code | `.claude/feature-driven-flow/settings.json` | `.claude/feature-driven-flow/rules/` | `.claude/feature-driven-flow/packs/` |
| Codex | `.codex/feature-driven-flow/settings.json` | `.codex/feature-driven-flow/rules/` | `.codex/feature-driven-flow/packs/` |

## 10. Behavioral Parity

Both agents implement identical FDF behavior:

1. seven phases in fixed order
2. the same core gates and invariants
3. the same rule/profile system
4. the same artifact formats for matrix and effective instructions
5. cross-agent handoff through reusable artifacts

## 11. Specialist Delegation Policy

Specialist skills and child execution are part of the internal implementation strategy, not the public interface.

Public interface remains:

1. Codex prompts
2. Claude slash commands

Internal delegation policy:

1. Claude Code
   - Specialist skills may be delegated to subagents when the task is bounded, context-heavy, or benefits from tool isolation.
   - Good candidates: repository exploration, implementation planning, and change auditing.
   - Do not delegate by default when the work is trivial or tightly coupled to the conductor's immediate phase state.
2. Codex
   - Specialist skills should remain reusable instruction modules first.
   - Separate child agents make sense only for coarse-grained bounded tasks, not as a blanket one-skill-per-agent architecture.
   - Good candidates: large exploration tasks, diff audits, or alternative implementation branches that can run in parallel.

Why the policy differs:

1. Claude Code has a stronger native subagent model for isolated delegation.
2. Codex benefits from task-level delegation, but specialist skills should not be forced into a one-to-one subagent mapping.

## 12. What This Document Does Not Cover

This document does not restate:

1. detailed workflow semantics
2. artifact JSON shapes
3. validation troubleshooting commands
4. general Claude platform capabilities

Use these instead:

1. `docs/specification.md`
2. `docs/validation-types-playbook.md`
3. `docs/distribution/claude-feature-driven-flow-repo-spec.md`
4. `docs/platform/claude-code/*.md` platform references

## 13. Dev Tools

| Tool | Purpose |
|---|---|
| `tools/build-distribution-claude.ps1` | Build `distrib/feature-driven-flow-claude/` |
| `tools/build-distribution-codex.ps1` | Build `distrib/feature-driven-flow-codex/` |
| `tools/deploy-distribution-codex.ps1` | Mirror Codex distribution into a release repo checkout |
| `tools/generate-fdf-manifest.ps1` | Regenerate manifest files |
| `tools/validate-fdf-assets.ps1` | Validate rules, profiles, packs, schemas, settings |
| `tools/run-validation-cycle.ps1` | Run the full validation suite |
