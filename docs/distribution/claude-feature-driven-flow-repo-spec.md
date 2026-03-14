# feature-driven-flow-claude — Marketplace Repository Specification

Repository: https://github.com/QuasarByte/feature-driven-flow-claude

## Purpose

This repository is the release distribution target for the QuasarByte Claude Code marketplace.
It publishes the `feature-driven-flow` plugin through a marketplace catalog rather than as a plugin-at-root repository.

It is not the development repository. Development happens in `feature-driven-flow`; the Claude-specific wrapper layer lives in `claude-code/`, shared runtime assets live in `shared/fdf/`, and marketplace metadata source lives in `claude-code/.claude-plugin/marketplace.json` and the plugin source lives under `claude-code/plugins/feature-driven-flow/` in the dev repo. On each release, those sources are assembled into this marketplace layout.

This document is intentionally narrow. It covers only:

1. the Claude marketplace repository layout
2. the Claude release build and deploy path
3. marketplace and plugin runtime path expectations

For source-layout and cross-agent reasoning, use `docs/fdf-cross-agent-architecture.md`.

## Repository Layout

```text
feature-driven-flow-claude/
├── .claude-plugin/
│   └── marketplace.json
├── LICENSE
├── plugins/
│   └── feature-driven-flow/
│       ├── .claude-plugin/
│       │   └── plugin.json
│       ├── skills/
│       ├── commands/
│       ├── fdf/
│       └── README.md
└── README.md
```

## Design Principles

1. **Marketplace at root.** The repository root is a marketplace, not a plugin payload.
2. **Plugin in subdirectory.** The FDF plugin lives under `plugins/feature-driven-flow/`.
3. **Self-contained plugin payload.** The plugin subdirectory contains all runtime assets needed after installation.
4. **Release-only.** No dev tooling, no specs, no Codex-specific files.
5. **Assembled from source.** The marketplace repo is built from `claude-code/.claude-plugin/marketplace.json`, `claude-code/plugins/feature-driven-flow/`, and `shared/fdf/` from the dev repository.

## Marketplace Install Flow

Add the marketplace:

```text
/plugin marketplace add QuasarByte/feature-driven-flow-claude
```

Install the plugin from that marketplace:

```text
/plugin install feature-driven-flow@quasarbyte-plugins
```

After install, the supported command form is namespaced by plugin id, for example:

```text
/feature-driven-flow:fdf-start <task>
```

Utility commands follow the same pattern, for example `/feature-driven-flow:fdf-export-effective-matrix`.

Bare `/fdf-*` command forms may not be reliable as the public interface for a marketplace-installed plugin.

## Release Process

### Step 1 — Build

```powershell
pwsh -NoProfile -File tools/build-distribution-claude.ps1
pwsh -NoProfile -File tools/build-distribution-claude.ps1 -Version 1.2.1
pwsh -NoProfile -File tools/build-distribution-claude.ps1 -Force
pwsh -NoProfile -File tools/deploy-distribution-claude.ps1 -TargetRepoPath C:\path\to\feature-driven-flow-claude -Build
```

The script:

1. validates marketplace metadata in `claude-code/.claude-plugin/`
2. validates Claude wrapper files in `claude-code/`
3. validates shared runtime files in `shared/fdf/`
4. recreates `distrib/feature-driven-flow-claude/`
5. writes `.claude-plugin/marketplace.json` at marketplace root
6. writes `LICENSE` at marketplace root
7. assembles the plugin into `plugins/feature-driven-flow/`
8. optionally patches marketplace and plugin versions

### Step 2 — Inspect

```powershell
ls distrib/feature-driven-flow-claude
ls distrib/feature-driven-flow-claude/plugins/feature-driven-flow
```

### Step 3 — Deploy

```powershell
pwsh -NoProfile -File tools/deploy-distribution-claude.ps1 -TargetRepoPath C:\path\to\feature-driven-flow-claude -Build
```

## Files Included in Distribution

| Source path in dev repo | Destination path in marketplace repo |
|---|---|
| `claude-code/.claude-plugin/marketplace.json` | `.claude-plugin/marketplace.json` |
| `claude-code/LICENSE` | `LICENSE` |
| `claude-code/plugins/feature-driven-flow/.claude-plugin/` | `plugins/feature-driven-flow/.claude-plugin/` |
| `claude-code/plugins/feature-driven-flow/skills/` | `plugins/feature-driven-flow/skills/` |
| `claude-code/plugins/feature-driven-flow/commands/` | `plugins/feature-driven-flow/commands/` |
| `shared/fdf/` | `plugins/feature-driven-flow/fdf/` |
| `claude-code/plugins/feature-driven-flow/README.md` | `plugins/feature-driven-flow/README.md` |
| `claude-code/README.md` | `README.md` |

Not included:

1. `tools/`
2. `docs/`
3. `codex/`
4. dev repo git history

## Deploy Sync

Use the deploy helper to mirror the built distribution into a local checkout of `QuasarByte/feature-driven-flow-claude`.

```powershell
pwsh -NoProfile -File tools/deploy-distribution-claude.ps1 -TargetRepoPath C:\path\to\feature-driven-flow-claude -Build
```

It uses a PowerShell-native mirror sync excluding `.git`, so:

1. new files are copied
2. changed files are overwritten
3. files missing from `distrib/feature-driven-flow-claude` are deleted in the target checkout

## Runtime Path Resolution

Marketplace root after add:

```text
<marketplace-root>/
├── .claude-plugin/marketplace.json
└── plugins/feature-driven-flow/
```

Installed plugin runtime after user installs `feature-driven-flow@quasarbyte-plugins`:

```text
~/.claude/plugins/cache/feature-driven-flow/
├── .claude-plugin/plugin.json
├── skills/
├── commands/
└── fdf/
```

The conductor `SKILL.md` still exposes plugin root to the AI with:

```text
FDF plugin root: ${CLAUDE_SKILL_DIR}/../..
```

## Versioning

1. Plugin version is declared in `plugins/feature-driven-flow/.claude-plugin/plugin.json`.
2. Marketplace catalog schema version remains in `.claude-plugin/marketplace.json`.
3. Marketplace metadata may also carry release metadata for the published catalog and plugin entry.
4. The development repo tracks its own version sources separately.

## Repositories

| Repo | Purpose |
|---|---|
| `QuasarByte/feature-driven-flow` | Development source |
| `QuasarByte/feature-driven-flow-claude` | Claude marketplace target |