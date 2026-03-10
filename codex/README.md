# Feature-Driven-Flow (FDF)

Version: `1.2.0`

Feature-Driven-Flow is a markdown-first delivery framework for non-trivial work. This package targets Codex. It runs a fixed seven-phase workflow, compiles selected policies into an Effective Rule Matrix, and supports reusable effective-instructions artifacts.

## Install

1. Copy `skills/*` into `$CODEX_HOME/skills/`.
2. Copy `prompts/*.md` into `$CODEX_HOME/prompts/`.
3. Copy `fdf/` into your target project root as `./fdf/`.
4. Restart Codex.

Resulting runtime layout in a target project:

```text
$CODEX_HOME/
├── skills/
│   └── feature-driven-flow/
└── prompts/
    └── fdf-start.md

<project-root>/
└── fdf/
    ├── schemas/
    ├── scripts/
    └── skills/feature-driven-flow/
```

## Quick Start

Run the conductor prompt:

```text
/prompts:fdf-start Create a simple console Java app that prints factorial(n). Use JDK 25 and Maven. Read n from argv.
```

Optional profile request:

```text
/prompts:fdf-start Build a small internal CLI tool. Use profile hardened and overlays security-overlay, operations-overlay.
```

Optional Effective Rule Matrix reuse:

```text
/prompts:fdf-start Implement my feature using matrix file .codex/feature-driven-flow/effective-rule-matrix.json
```

## Included Assets

- Internal conductor skill implementation: `skills/feature-driven-flow/SKILL.md`
- Internal specialist skill implementations: `skills/fdf-code-explorer/`, `skills/fdf-implementation-planner/`, `skills/fdf-change-auditor/`
- Prompt entrypoint: `prompts/fdf-start.md`
- Utility prompts: `prompts/fdf-*.md`
- Shared rules, profiles, packs, templates, references: `fdf/skills/feature-driven-flow/`
- Schemas: `fdf/schemas/*.json`
- Conversion tool: `fdf/scripts/convert-effective-instructions.ps1`


## Source Repository

Development happens in [QuasarByte/feature-driven-flow](https://github.com/QuasarByte/feature-driven-flow).
This Codex package is the runtime distribution published through [QuasarByte/feature-driven-flow-codex](https://github.com/QuasarByte/feature-driven-flow-codex).

## Maintainer Tooling

If you use the build, deploy, validation, manifest, or conversion scripts from this repository, PowerShell 7 (`pwsh`) must be installed.
The `.sh` and `.cmd` wrappers still delegate to `pwsh`.

Scripts that require `pwsh`:

1. `tools/build-distribution-codex.ps1`
2. `tools/deploy-distribution-codex.ps1`
3. `tools/run-validation-cycle.ps1`
4. `tools/validate-fdf-assets.ps1`
5. `tools/generate-fdf-manifest.ps1`
6. `shared/fdf/scripts/convert-effective-instructions.ps1`

## Workflow Contract

FDF always runs in this order:

`Scope -> Explore -> Clarify -> Architect -> Implement -> Verify -> Summarize`

Core invariants:

1. Do not reorder or skip phases.
2. Do not leave Clarify with decision-critical ambiguity.
3. Do not start Implement without explicit user approval.
4. Do not close before Verify and Summarize.

## Settings

Distribution defaults live at:

`fdf/skills/feature-driven-flow/settings.json`

Repo-local overrides can be added at:

- `.codex/feature-driven-flow/settings.json`
- `.codex/feature-driven-flow/rules/*.md`
- `.codex/feature-driven-flow/profiles/*.md`
- `.codex/feature-driven-flow/packs/*`

Default shared pack directory inside the installed runtime:

`fdf/skills/feature-driven-flow/packs`

## Effective Artifact Commands

Export matrix:

```text
/prompts:fdf-export-effective-matrix .codex/feature-driven-flow/effective-rule-matrix.json
```

Export compiled instructions bundle:

```text
/prompts:fdf-export-effective-instructions-bundle .codex/feature-driven-flow/effective-instructions-bundle
```

Export compiled instructions compact:

```text
/prompts:fdf-export-effective-instructions-compact .codex/feature-driven-flow/effective-instructions-compact.json
```

Convert bundle to compact:

```powershell
pwsh -NoProfile -File fdf/scripts/convert-effective-instructions.ps1 -Mode directory-to-compact -InputPath .codex/feature-driven-flow/effective-instructions-bundle -OutputPath .codex/feature-driven-flow/effective-instructions-compact.json
```

Convert compact to bundle:

```powershell
pwsh -NoProfile -File fdf/scripts/convert-effective-instructions.ps1 -Mode compact-to-directory -InputPath .codex/feature-driven-flow/effective-instructions-compact.json -OutputPath .codex/feature-driven-flow/effective-instructions-bundle
```

## Manifest and Schema Paths

- Combined manifest: `fdf/skills/feature-driven-flow/extensions/manifest.json`
- Core manifest: `fdf/skills/feature-driven-flow/manifest.json`
- Pack manifests: `fdf/skills/feature-driven-flow/packs/<pack_id>/manifest.json`
- Settings schema: `fdf/schemas/fdf-settings.schema.json`
- Matrix schema: `fdf/schemas/fdf-effective-matrix.schema.json`
- Effective-instructions schemas: `fdf/schemas/fdf-effective-instructions-*.schema.json`

## Troubleshooting

1. Prompt missing: verify `fdf-start.md` exists in `$CODEX_HOME/prompts/` and restart Codex.
2. Packs not available: check `packs.enabled` and `fdf/skills/feature-driven-flow/packs/<pack_id>/manifest.json`.
3. Imported matrix rejected: validate against `fdf/schemas/fdf-effective-matrix.schema.json`.
4. Effective-instructions import/export rejected: validate against the relevant schema under `fdf/schemas/` and review `effective_instructions.*` settings.

## Deploy Sync

To mirror the built Codex distribution into a local checkout of your release repository:

```powershell
pwsh -NoProfile -File tools/deploy-distribution-codex.ps1 -TargetRepoPath C:\path\to\feature-driven-flow-codex -Build
```

It uses a PowerShell-native mirror sync excluding `.git`, so it copies new files, updates changed files, and deletes files that no longer exist in `distrib/feature-driven-flow-codex`.