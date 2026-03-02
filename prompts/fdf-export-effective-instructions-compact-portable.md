Export compiled/effective instructions as portable compact file (embedded content).

Task:
$ARGUMENTS

Requirements:
1. Interpret `$ARGUMENTS` as optional output file path.
2. Resolve target path:
   - explicit user path when allowed
   - otherwise `effective_instructions.export.default_portable_compact_file`
3. Force content mode:
   - `portable` or `hybrid` (embedded content required)
4. Validate exported file against:
   - `schemas/fdf-effective-instructions-compact-portable.schema.json`
5. Warn user about tradeoffs:
   - larger artifacts
   - potential sensitive source exposure when sharing externally
6. If `effective_instructions.export.allow_custom_instructions=true`, ask user whether to include custom instructions:
   - add new custom instruction(s),
   - modify/rephrase current candidate(s),
   - continue without custom instructions.
7. If custom instructions are included and `effective_instructions.export.require_custom_instructions_approval=true`, require explicit user approval before export.
8. If `effective_instructions.export.require_all_custom_instruction_items_approved=true`, detect any item where `state!=approved` and stop for user decision:
   - improve/rephrase and approve,
   - skip unapproved items and continue with approved-only set,
   - cancel export.
9. Persist approved custom instructions under artifact field `custom_instructions`.
10. Return resolved path and validation status.
