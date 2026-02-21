# Rule: security-baseline

## id
`security-baseline`

## title
Security Baseline

## applies_to_phases
`explore`, `clarify`, `architect`, `verify`

## intent
Reduce security risk, data exposure, and unsafe failure behavior.

## guidance
### explore
1. Identify authentication/authorization entry points and trust boundaries.
2. Identify sensitive data flow surfaces and storage/external boundaries.
3. Record security-relevant integration seams for downstream phases.

### clarify
1. Identify sensitive data classes and trust boundaries.
2. Clarify authentication/authorization impact.
3. Clarify audit and compliance expectations.

### architect
1. Apply least-privilege boundaries.
2. Define secret handling boundaries.
3. Define input/output validation boundaries.

### verify
1. Review abuse and failure paths.
2. Check for data exposure.
3. Check logging redaction.

## checks
### explore
1. Security-relevant entry points and boundaries are mapped.

### clarify
1. Sensitive data handling requirements are explicit.

### architect
1. Security controls are mapped to changed components.

### verify
1. No high-confidence security regressions remain unresolved.

## outputs
### explore
1. Security-focused behavior map notes.

### clarify
1. Security concern list.

### architect
1. Security boundary notes.

### verify
1. Security findings and dispositions.
