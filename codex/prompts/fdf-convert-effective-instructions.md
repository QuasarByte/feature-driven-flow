Convert effective-instructions artifacts between directory bundle and compact formats.

Task:
$ARGUMENTS

Requirements:
1. Interpret `$ARGUMENTS` as conversion request:
   - bundle -> compact, or
   - compact -> bundle
2. Support output content mode:
   - `reference`
   - `portable` (embedded content)
   - `hybrid` (both references + embedded content)
   - `preserve` (default)
3. Resolve input/output paths from explicit user arguments or settings defaults.
4. Use conversion tool:
   - `fdf/scripts/convert-effective-instructions.ps1`
5. Preserve `custom_instructions` block during conversion when present.
6. Validate resulting artifact against target schema.
7. Return conversion mode, content mode, source path, output path, and validation status.
