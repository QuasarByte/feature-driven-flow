Export compiled/effective instructions as compact single-file JSON.

Task:
$ARGUMENTS

Requirements:
1. Interpret `$ARGUMENTS` as optional output file path.
2. Resolve target path by policy:
   - explicit user path when allowed by `effective_instructions.export.allow_user_path_override`
   - otherwise `effective_instructions.export.default_compact_file`
3. Use content mode from settings:
   - `effective_instructions.export.content_mode` (`reference|portable|hybrid`)
   - portable/hybrid uses embedded-content schema/shape
4. Respect path policy:
   - relative paths are repo-root relative
   - absolute paths only if `effective_instructions.export.allow_absolute_path=true`
   - overwrite behavior from `effective_instructions.export.overwrite_existing`
5. Export compact artifact with embedded matrix and phase instruction text.
6. Validate exported file against:
   - `schemas/fdf-effective-instructions-compact.schema.json`
   - or portable schema when content mode is `portable|hybrid`
7. If portable/hybrid mode is used, warn about larger artifacts and possible sensitive source exposure.
8. If `effective_instructions.export.allow_custom_instructions=true`, ask user whether to include custom instructions:
   - add new custom instruction(s),
   - modify/rephrase current candidate(s),
   - continue without custom instructions.
9. If custom instructions are included and `effective_instructions.export.require_custom_instructions_approval=true`, require explicit user approval before export.
10. If `effective_instructions.export.require_all_custom_instruction_items_approved=true`, detect any item where `state!=approved` and stop for user decision:
   - improve/rephrase and approve,
   - skip unapproved items and continue with approved-only set,
   - cancel export.
11. Persist approved custom instructions under artifact field `custom_instructions`.
12. Return export result including resolved path and validation status.
