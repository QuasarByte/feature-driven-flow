# Packs (Asset Bundles)

Packs are additional asset bundles that extend Feature-Driven-Flow without modifying the core distribution.

Pack contents are markdown-first:

1. Rules: `extensions/rules/*.md`
2. Profiles: `extensions/profiles/*.md`
3. Templates: `templates/*.md` (optional)
4. References: `references/*.md` (optional)

## Why Packs Exist

1. Keep core stable while allowing teams to share domain policies.
2. Enable "repositories of repositories": curated sets of rules/profiles maintained independently.
3. Reduce discovery cost by indexing assets via manifests.

## Pack Locations

Settings control whether these are allowed and where they are loaded from:

1. Shared packs (this distribution):
   - `packs.shared_dir` (default `skills/feature-driven-flow/packs`)
2. Repository-local packs (target repo):
   - `packs.local_dir` (default `.codex/feature-driven-flow/packs`)

Each pack directory should include:

`manifest.json` (generated) and optionally a `README.md`.

## Packs In This Distribution

1. `async-collab`: persistence, async packets, portability exports.
2. `quality`: engineering principles + test strategy gate.
3. `hardening`: security/performance/ops/release/compatibility rules.
4. `presets`: convenience profiles (`baseline`, `hardened`, overlays) and recommendations.
5. `observability-lite`: small workflow debug notes (example pack).

## Manifests

Each pack has its own manifest:

`<pack_root>/manifest.json`

The core distribution also has a combined manifest:

`skills/feature-driven-flow/extensions/manifest.json`

Use `tools/generate-fdf-manifest.ps1` to regenerate manifests.

## Precedence and Conflicts

1. Core invariants and `AGENTS.md` always win.
2. Packs only affect *which assets exist to select* (rules/profiles/templates/references).
3. Rule ids must be globally unique across core + enabled packs.
4. If two packs define the same rule id, treat it as a configuration error and require user resolution (disable one pack or rename).
