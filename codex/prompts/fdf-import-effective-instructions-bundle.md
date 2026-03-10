Import compiled/effective instructions from a directory bundle.

Task:
$ARGUMENTS

Requirements:
1. Interpret `$ARGUMENTS` as optional bundle directory path.
2. If path is missing, try default from settings:
   - `effective_instructions.import.default_directory_bundle`
3. Expected bundle layout:
   - `bundle.manifest.json`
   - `phases/scope.md`
   - `phases/explore.md`
   - `phases/clarify.md`
   - `phases/architect.md`
   - `phases/implement.md`
   - `phases/verify.md`
   - `phases/summarize.md`
4. Validate manifest against:
   - `fdf/schemas/fdf-effective-instructions-bundle.schema.json`
5. Validate embedded matrix and phase coverage consistency.
6. If `custom_instructions` exists and `effective_instructions.import.allow_custom_instructions=true`, ask user to:
   - accept imported custom instructions as-is,
   - modify/rephrase before use,
   - discard imported custom instructions.
7. If `effective_instructions.import.require_custom_instructions_confirmation=true`, do not apply imported custom instructions until user confirms.
8. Ask user to accept imported compiled instructions, refresh from current assets, or discard.
9. Record source, validation result, custom instruction disposition, and final disposition in Scope outputs when applicable.
