# Feature-Driven-Flow (FDF)

Version: `1.2.0`

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

## Included Plugin

`feature-driven-flow` provides a structured 7-phase workflow for non-trivial software delivery.

After installation, use:

```text
/feature-driven-flow:fdf-start <task>
```


Claude marketplace commands are documented in namespaced form: `/feature-driven-flow:fdf-*`.

## Repository Layout

```text
.claude-plugin/marketplace.json
plugins/feature-driven-flow/
```

The marketplace catalog lives at repository root. The actual Claude plugin payload lives under `plugins/feature-driven-flow/`.
## Source Repository

Development happens in [QuasarByte/feature-driven-flow](https://github.com/QuasarByte/feature-driven-flow).
This repository is the Claude marketplace distribution published through [QuasarByte/feature-driven-flow-claude](https://github.com/QuasarByte/feature-driven-flow-claude).

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
