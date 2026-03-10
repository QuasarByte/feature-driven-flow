# Asset Validation (Optional Tooling)

This repository is designed to be usable without scripts. Validation tooling is optional.

## What It Checks

The validator performs lightweight checks over shared assets:

1. Shared rule ids are present and unique.
2. `applies_to_phases` is non-empty and uses only valid phase names.
3. Shared profile ids are present and unique.
4. Profiles reference only known rule ids in `rule_sets.always`.
5. `settings.json` files conform to `schemas/fdf-settings.schema.json`:
   - required: `skills/feature-driven-flow/settings.json`
   - optional: `.codex/feature-driven-flow/settings.json`
6. effective matrix artifact files conform to `schemas/fdf-effective-matrix.schema.json`:
   - required: `skills/feature-driven-flow/templates/effective-rule-matrix.json`
   - optional: `.codex/feature-driven-flow/effective-rule-matrix.json`
7. effective instructions bundle files conform to `schemas/fdf-effective-instructions-bundle.schema.json`:
   - required: `skills/feature-driven-flow/templates/effective-instructions-bundle.manifest.json`
   - optional: `.codex/feature-driven-flow/effective-instructions-bundle/bundle.manifest.json`
8. effective instructions compact files conform to `schemas/fdf-effective-instructions-compact.schema.json`:
   - required: `skills/feature-driven-flow/templates/effective-instructions-compact.json`
   - optional: `.codex/feature-driven-flow/effective-instructions-compact.json`
9. effective instructions bundle portable files conform to `schemas/fdf-effective-instructions-bundle-portable.schema.json`:
   - required: `skills/feature-driven-flow/templates/effective-instructions-bundle-portable.manifest.json`
   - optional: `.codex/feature-driven-flow/effective-instructions-bundle-portable/bundle.manifest.json`
10. effective instructions compact portable files conform to `schemas/fdf-effective-instructions-compact-portable.schema.json`:
   - required: `skills/feature-driven-flow/templates/effective-instructions-compact-portable.json`
   - optional: `.codex/feature-driven-flow/effective-instructions-compact-portable.json`

## How To Run

From repo root:

```powershell
powershell -ExecutionPolicy Bypass -File tools/validate-fdf-assets.ps1
```
