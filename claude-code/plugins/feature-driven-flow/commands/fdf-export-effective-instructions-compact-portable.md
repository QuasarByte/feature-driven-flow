---
description: FDF — export compiled/effective instructions as a portable compact file (embedded content)
allowed-tools: Read, Write, Glob
---

Task: $ARGUMENTS

Requirements:
1. Interpret `$ARGUMENTS` as optional output file path.
2. Resolve target path:
   - explicit user path when allowed
   - otherwise `effective_instructions.export.default_portable_compact_file`
3. Force content mode `portable` or `hybrid` (embedded content required).
4. Validate exported file against:
   - `fdf/schemas/fdf-effective-instructions-compact-portable.schema.json`
5. Warn user about tradeoffs: larger artifacts and potential sensitive source exposure when sharing externally.
6. If `effective_instructions.export.allow_custom_instructions=true`, ask user whether to include custom instructions.
7. If custom instructions included and `require_custom_instructions_approval=true`, require explicit user approval before export.
8. If `require_all_custom_instruction_items_approved=true`, block unapproved items; ask user to approve, skip, or cancel.
9. Return resolved path and validation status.