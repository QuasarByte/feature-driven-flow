Import compiled/effective instructions from portable directory bundle (embedded content).

Task:
$ARGUMENTS

Requirements:
1. Interpret `$ARGUMENTS` as optional portable bundle directory path.
2. If path is missing, try default from settings:
   - `effective_instructions.import.default_portable_directory_bundle`
3. Validate manifest against:
   - `schemas/fdf-effective-instructions-bundle-portable.schema.json`
4. Ensure `embedded_sources` exists and content mode is accepted by:
   - `effective_instructions.import.accept_content_modes`
5. If `custom_instructions` exists and `effective_instructions.import.allow_custom_instructions=true`, ask user to:
   - accept imported custom instructions as-is,
   - modify/rephrase before use,
   - discard imported custom instructions.
6. If `effective_instructions.import.require_custom_instructions_confirmation=true`, do not apply imported custom instructions until user confirms.
7. Ask user to accept imported instructions, refresh from current assets, or discard.
8. Record validation, custom instruction disposition, and final disposition in Scope outputs.
