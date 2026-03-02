# Rule: compatibility-first

## id
`compatibility-first`

## title
Compatibility First

## tags
`compatibility`

## applies_to_phases
`explore`, `clarify`, `architect`, `verify`

## intent
Protect existing clients, integrations, and migration paths.

## guidance
### explore
1. Identify current client and integration entry points that may be impacted.
2. Identify contract surfaces (API/schema/protocol) in the change area.
3. Identify existing fallback/versioning seams.

### clarify
1. Capture existing client expectations.
2. Capture compatibility policy for APIs/schemas.
3. Capture migration and deprecation windows.

### architect
1. Define versioning and fallback strategy.
2. Define migration sequencing.
3. Define deprecation communication points.

### verify
1. Validate compatibility test coverage.
2. Validate migration path behavior.
3. Validate rollback safety.

## checks
### explore
1. Compatibility-sensitive surfaces are mapped before design starts.

### clarify
1. Compatibility commitments are explicit.

### architect
1. Migration and fallback paths are feasible.

### verify
1. Breaking changes are either mitigated or explicitly accepted.

## outputs
### explore
1. Compatibility-focused behavior map notes.

### clarify
1. Compatibility requirements summary.

### architect
1. Compatibility and migration plan.

### verify
1. Compatibility findings and disposition.

