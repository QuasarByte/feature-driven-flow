# Asset Index (Manifest)

This repository is a markdown asset pack (rules, profiles, templates, references).

To reduce discovery cost and "compile" what exists without scanning many files, use the generated manifest:

`skills/feature-driven-flow/extensions/manifest.json`

## What The Manifest Contains

1. Rules:
   - `id`, `title`, `tags`, `applies_to_phases`, `intent`, `file`
2. Profiles:
   - `id`, `title`, `intent`, `extends`, `always_rules`, `file`
3. Templates: file list
4. References: file list

## How To Regenerate

From repo root:

```powershell
powershell -ExecutionPolicy Bypass -File tools/generate-fdf-manifest.ps1
```

This updates:

`skills/feature-driven-flow/extensions/manifest.json`

## When To Use It

1. When proposing a profile selection or rule matrix and you want a fast list of available assets.
2. When auditing the pack contents for drift or missing coverage.
3. When onboarding contributors (single index file).

## Packs

If packs are used, manifests can exist for each pack as well:

`skills/feature-driven-flow/packs/<pack_id>/manifest.json`

See `references/packs.md`.
