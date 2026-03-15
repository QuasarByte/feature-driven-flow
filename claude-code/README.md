# Feature-Driven-Flow (FDF)

Version: `1.2.1`

This repository is a Claude Code marketplace that currently publishes one plugin:

1. `feature-driven-flow`

## Install

Add the marketplace:

```text
/plugin marketplace add QuasarByte/feature-driven-flow-claude
```

Install the plugin:

```text
/plugin install feature-driven-flow@quasarbyte-plugins
```

Optional shared runtime defaults:

1. Copy `plugins/feature-driven-flow/fdf/` into `~/.claude/fdf/` if you want one global FDF asset tree outside the installed plugin cache.
2. Optionally copy `fdf/` into a target project root as `./fdf/` when that project needs local FDF overrides.

## Included Plugin

`feature-driven-flow` provides a structured 7-phase workflow for non-trivial software delivery.

After installation, use:

```text
/feature-driven-flow:fdf-start <task>
```

Claude marketplace commands are documented in namespaced form: `/feature-driven-flow:fdf-*`.

## Asset Resolution Rule

At runtime, shared FDF assets are resolved from the first available root in this order:

1. `./fdf/` in the target project root
2. `~/.claude/fdf/`
3. bundled plugin `fdf/`

Repo-local overrides still live under `.claude/feature-driven-flow/`.

## Repository Layout

```text
.claude-plugin/marketplace.json
plugins/feature-driven-flow/
```

The marketplace catalog lives at repository root. The actual Claude plugin payload lives under `plugins/feature-driven-flow/`.

## Source Repository

Development happens in [QuasarByte/feature-driven-flow](https://github.com/QuasarByte/feature-driven-flow).
This repository is the Claude marketplace distribution published through [QuasarByte/feature-driven-flow-claude](https://github.com/QuasarByte/feature-driven-flow-claude).

## PowerShell Path Handling

When using PowerShell to inspect plugin files, quote filesystem paths that may contain spaces.
If `rg` is unavailable in the shell, use PowerShell-native discovery commands such as `Get-ChildItem -Recurse -File` and `Select-String`.

## Maintainer Tooling

If you use the release scripts from the source repository, PowerShell 7 (`pwsh`) must be installed.
The `.sh` and `.cmd` wrappers still delegate to `pwsh`.

Scripts that require `pwsh`:

1. `tools/build-distribution-claude.ps1`
2. `tools/deploy-distribution-claude.ps1`
3. `tools/run-validation-cycle.ps1`
4. `tools/validate-fdf-assets.ps1`
5. `tools/generate-fdf-manifest.ps1`
6. `shared/fdf/scripts/convert-effective-instructions.ps1`