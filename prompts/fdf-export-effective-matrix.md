Export the currently confirmed Effective Rule Matrix.

Task:
$ARGUMENTS

Requirements:
1. Interpret `$ARGUMENTS` as optional output path.
2. Resolve target path by policy:
   - explicit user path when allowed by `matrix_export.allow_user_path_override`
   - otherwise `matrix_export.default_file`
3. Respect path policy:
   - relative paths are repo-root relative
   - absolute paths only if `matrix_export.allow_absolute_path=true`
   - overwrite behavior from `matrix_export.overwrite_existing`
4. Export artifact in canonical JSON shape:
   - `schema: fdf/effective-rule-matrix.v1`
   - matrix/provenance fields required by schema
5. Validate exported file against:
   - `schemas/fdf-effective-matrix.schema.json`
6. Return export result including resolved path and validation status.
