# Rule: inference-guardrails

## id
`inference-guardrails`

## title
Inference Guardrails

## tags
`process`, `inference`

## applies_to_phases
`scope`, `clarify`, `verify`

## intent
Keep runtime context inference explicit, testable, and stable through delivery.

## guidance
### scope
1. State inferred context with confidence and evidence.
2. List top assumptions and ambiguity hotspots.
3. Require user confirmation or adjustment.

### clarify
1. Prioritize questions that can invalidate inferred context.
2. Confirm non-goals and excluded surfaces.

### verify
1. Check for context drift and scope drift.
2. Record residual uncertainty if confidence remained low.

## checks
### scope
1. Evidence and confidence are explicit.

### clarify
1. Critical assumptions are resolved or tracked.

### verify
1. Drift is either absent or explicitly accepted.

## outputs
### scope
1. Inference summary with confidence.

### clarify
1. Assumption resolution log.

### verify
1. Drift and uncertainty summary.
