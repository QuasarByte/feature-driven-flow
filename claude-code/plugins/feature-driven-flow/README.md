# Feature-Driven-Flow — Claude Code Plugin

A structured 7-phase AI delivery framework for non-trivial feature development.

## Install

If you added the QuasarByte marketplace, install the plugin with:

```text
/plugin install feature-driven-flow@quasarbyte-plugins
```

Optional shared runtime defaults:

1. Copy the bundled `fdf/` tree into `~/.claude/fdf/` if you want one reusable global FDF asset tree.
2. Optionally copy `fdf/` into a target project root as `./fdf/` when that project needs local FDF overrides.

## Runtime Asset Resolution

The plugin resolves shared FDF assets from the first available root in this order:

1. `./fdf/` in the target project root
2. `~/.claude/fdf/`
3. bundled plugin `fdf/`

Project-local Claude overrides still live under `.claude/feature-driven-flow/`.
## Phases

| # | Phase | Purpose |
|---|---|---|
| 1 | **Scope** | Define intent, load rule matrix, confirm profiles |
| 2 | **Explore** | Trace repository behavior and surface change surface |
| 3 | **Clarify** | Resolve ambiguity and capture decisions |
| 4 | **Architect** | Produce design options and get approval |
| 5 | **Implement** | Execute approved plan with explicit gate |
| 6 | **Verify** | Audit changes for correctness and quality |
| 7 | **Summarize** | Produce end-state report and close tracker |

## Commands

Use slash commands as the supported user-facing interface.

For marketplace installs, use the namespaced plugin command form. Bare `/fdf-start` may not be reliable as the public interface.

| Command | Description |
|---|---|
| `/feature-driven-flow:fdf-start` | Main entrypoint for the full FDF workflow |
| `/feature-driven-flow:fdf-export-effective-matrix` | Export the confirmed Effective Rule Matrix to a file |
| `/feature-driven-flow:fdf-import-effective-matrix` | Import and validate an Effective Rule Matrix |
| `/feature-driven-flow:fdf-diff-effective-matrix` | Diff two Effective Rule Matrix artifacts |
| `/feature-driven-flow:fdf-show-effective-matrix` | Display the active Effective Rule Matrix |
| `/feature-driven-flow:fdf-export-effective-instructions-bundle` | Export compiled instructions as a directory bundle |
| `/feature-driven-flow:fdf-export-effective-instructions-compact` | Export compiled instructions as a compact JSON file |
| `/feature-driven-flow:fdf-export-effective-instructions-bundle-portable` | Export bundle with embedded source content |
| `/feature-driven-flow:fdf-export-effective-instructions-compact-portable` | Export compact file with embedded source content |
| `/feature-driven-flow:fdf-import-effective-instructions-bundle` | Import and validate a directory bundle |
| `/feature-driven-flow:fdf-import-effective-instructions-compact` | Import and validate a compact artifact |
| `/feature-driven-flow:fdf-import-effective-instructions-bundle-portable` | Import a portable directory bundle |
| `/feature-driven-flow:fdf-import-effective-instructions-compact-portable` | Import a portable compact artifact |
| `/feature-driven-flow:fdf-convert-effective-instructions` | Convert bundle ↔ compact formats |
| `/feature-driven-flow:fdf-refresh-effective-instructions` | Regenerate compiled instructions from current rules |
| `/feature-driven-flow:fdf-explain-effective-instructions` | Explain what the active compiled instructions do |
| `/feature-driven-flow:fdf-preview-scope-candidates` | Preview profile and matrix candidates before Scope |
| `/feature-driven-flow:fdf-validate-effective-artifacts` | Validate all FDF artifacts against schemas |
| `/feature-driven-flow:fdf-doctor-effective-reuse` | Diagnose reuse artifact issues |

## Local Customization

Create `.claude/feature-driven-flow/` in your project to add local rules, override settings, or add local packs.

```text
.claude/feature-driven-flow/
├── settings.json
├── rules/
└── packs/
```

## Internal Implementation

The plugin also ships skills under `skills/` for the conductor and specialist accelerators. Treat those as internal implementation details rather than the supported user interface.

## Source Repository

Development happens in [QuasarByte/feature-driven-flow](https://github.com/QuasarByte/feature-driven-flow). Released Claude artifacts are published via [QuasarByte/feature-driven-flow-claude](https://github.com/QuasarByte/feature-driven-flow-claude).
