# Pack: hardening

Production hardening and non-functional requirement rules.

Adds:

1. `security-baseline`
2. `performance-targets`
3. `operations-ready`
4. `release-readiness-policy` + `release-readiness-gate.md`
5. `compatibility-first`

How to enable:

1. Add `hardening` to `packs.enabled` in `.codex/feature-driven-flow/settings.json`.
2. Optionally select the `hardening-overlay` profile, or use presets like `hardened` (from the `presets` pack).
