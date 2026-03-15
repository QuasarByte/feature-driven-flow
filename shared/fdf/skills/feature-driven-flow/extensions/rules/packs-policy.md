# Rule: packs-policy

## id
`packs-policy`

## title
Packs Policy (Asset Bundle Selection)

## tags
`packs`, `settings`, `governance`

## applies_to_phases
`scope`

## intent
Make enabled pack selection explicit so asset discovery is deterministic and portable across machines and LLM tools.

## guidance
### scope
1. Read pack settings (see `../../references/settings.md` and `../../references/packs.md`):
   - `packs.enabled`
   - `packs.allow_shared_packs` / `packs.allow_local_packs`
   - `packs.shared_dir` / `packs.local_dir`
2. Build the "enabled asset set" summary:
   - list enabled pack ids (in order)
   - for each enabled pack: record expected manifest path:
     - `<packs.shared_dir>/<pack_id>/<packs.manifest_filename>` and/or `<packs.local_dir>/<pack_id>/<packs.manifest_filename>`
   - record which source was used (shared vs local) when both exist
3. Verify the enabled asset set is internally consistent:
   - rule ids are globally unique across core + enabled packs
   - profile ids are globally unique across core + enabled packs
   - any referenced rule/profile ids in selected profiles exist in the enabled asset set
4. Record enabled pack ids in Scope outputs and in `00-run.md` (when persistence enabled).
5. If pack manifests are available, list enabled packs with their manifest paths.
6. If enabled packs introduce missing/unknown rule or profile ids referenced by a chosen profile, block and ask the user to resolve by:
   - enabling the correct pack
   - selecting a different profile
   - or removing the missing ids from the matrix

## checks
### scope
1. Enabled pack list is explicit (even if empty).
2. Enabled asset set summary is recorded (packs + manifest paths).
3. Rule/profile ids are globally unique across core + enabled packs, or the conflict is explicitly resolved.
4. Any pack-related missing asset references are resolved or tracked as blocking.

## outputs
### scope
1. Enabled packs summary.
2. Pack manifest paths (when available).
