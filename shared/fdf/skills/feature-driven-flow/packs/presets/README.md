# Pack: presets

Convenience profiles and overlays that compose rules from other packs.

This pack provides:

1. `baseline` and `hardened` convenience profiles (strictness levels)
2. Security/ops/performance/release overlay profiles
3. A deterministic mapping doc recommending profiles by context

Use `packs.enabled` in settings to make these profiles available for selection.

How to enable:

1. Add `presets` to `packs.enabled` in `.codex/feature-driven-flow/settings.json`.
2. Choose a strictness base profile: `lean-baseline` (core), `baseline` (presets), or `hardened` (presets).
3. Add concern overlays as needed (security/ops/performance/release).
