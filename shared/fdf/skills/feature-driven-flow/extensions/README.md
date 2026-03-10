# Extensions

This directory provides rules customization and optional profile presets for feature-driven-flow.

## Structure

1. `rules/`: reusable shared micro-core rules.
2. `profiles/`: reusable shared micro-core profiles.
3. `manifest.json`: generated index of all assets (core + packs).

## How To Use

1. Start `/fdf-start ...`.
2. Let Codex infer execution context.
3. Optionally provide Effective Rule Matrix candidate via:
   - file path (recommended): `<repo>/.codex/feature-driven-flow/effective-rule-matrix.json`
   - inline multiline block in prompt/chat
4. Review proposed/validated matrix and profile selection (when compilation is needed).
5. Accept or adjust selected profiles and/or the Effective Rule Matrix.
6. Run workflow with selected shared rules plus optional local rules.
7. Optionally ask to save/export current Effective Rule Matrix for reuse.
8. Optionally ask to save/export compiled Effective Instructions as:
   - directory bundle (canonical)
   - compact file (portable)

## Local Rules

Repository-local rules are loaded from:

`<repo>/.codex/feature-driven-flow/rules/*.md`

Use `project-baseline.md` for always-on local policy.

## Local Profiles (Optional)

Repository-local profiles may be loaded from:

`<repo>/.codex/feature-driven-flow/profiles/*.md`

Use local profiles to encode repo-specific policy bundles without editing shared profiles.

## Notes

1. Rules are discovered from core `extensions/rules/*.md`, enabled pack manifests, and optional local rule files.
2. Profiles are optional selectors that compile down to the canonical per-phase rule matrix.
3. Users can reuse matrix artifacts across sessions; imported matrix candidates are validated before acceptance.
4. Users can reuse compiled-instructions artifacts across sessions; imported bundle/compact candidates are validated before acceptance.
5. Compiled-instructions content mode can be `reference|portable|hybrid`; portable/hybrid improves transferability but increases size and may expose embedded source content.
6. One extension dimension is used at runtime: rules.
7. Rules are applied by phase based on each rule's `applies_to_phases`.
8. Packs (asset bundles) can add additional rules/profiles/templates/references. Packs are located under `skills/feature-driven-flow/packs` in this distribution and can also be loaded from `.codex/feature-driven-flow/packs` in a target repo (see `references/packs.md`).
9. Persistence and async team handoff are implemented by the `async-collab` pack (see `packs/async-collab/references/persistence.md`).
10. A generated index of all assets is available at `extensions/manifest.json` (see `references/asset-index.md`).
