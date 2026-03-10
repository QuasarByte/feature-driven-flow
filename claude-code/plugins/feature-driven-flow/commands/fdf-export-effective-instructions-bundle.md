---
description: FDF — export compiled/effective instructions as a directory bundle
allowed-tools: Read, Write, Glob
---

Task: $ARGUMENTS

Requirements:
1. Interpret `$ARGUMENTS` as optional output directory path.
2. Resolve target directory by policy:
   - explicit user path when allowed by `effective_instructions.export.allow_user_path_override`
   - otherwise `effective_instructions.export.default_directory_bundle`
3. Use content mode from settings:
   - `effective_instructions.export.content_mode` (`reference|portable|hybrid`)
4. Respect path policy:
   - relative paths are repo-root relative
   - absolute paths only if `effective_instructions.export.allow_absolute_path=true`
   - overwrite behavior from `effective_instructions.export.overwrite_existing`
5. Export bundle files: `bundle.manifest.json` and `phases/<phase>.md` for all 7 phases.
6. Validate manifest against:
   - `fdf/schemas/fdf-effective-instructions-bundle.schema.json`
   - or portable schema when content mode is `portable|hybrid`
7. If portable/hybrid mode, warn about larger artifacts and possible sensitive source exposure.
8. If `effective_instructions.export.allow_custom_instructions=true`, ask user whether to include custom instructions.
9. If custom instructions included and `require_custom_instructions_approval=true`, require explicit user approval before export.
10. If `require_all_custom_instruction_items_approved=true`, block unapproved items; ask user to approve, skip, or cancel.
11. Return export result including resolved directory and validation status.