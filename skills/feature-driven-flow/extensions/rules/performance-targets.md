# Rule: performance-targets

## id
`performance-targets`

## title
Performance Targets

## applies_to_phases
`explore`, `clarify`, `architect`, `verify`

## intent
Keep latency, throughput, and capacity behavior within expected targets.

## guidance
### explore
1. Identify hot paths and high-frequency call paths in current behavior.
2. Identify cache/state lifecycle points affecting latency and throughput.
3. Identify existing performance telemetry tied to the feature area.

### clarify
1. Capture latency/throughput targets.
2. Capture peak usage and concurrency assumptions.
3. Capture resource budget constraints.

### architect
1. Identify hot paths.
2. Define caching/batching strategy when needed.
3. Define degradation/backpressure behavior.

### verify
1. Compare baseline to expected delta.
2. Check load and limit behavior.
3. Confirm monitoring thresholds alignment.

## checks
### explore
1. Candidate hot paths and telemetry points are mapped.

### clarify
1. Targets are measurable.

### architect
1. Performance-sensitive paths are explicitly addressed.

### verify
1. Performance risk is documented with confidence.

## outputs
### explore
1. Performance-focused behavior map notes.

### clarify
1. Target matrix.

### architect
1. Performance design notes.

### verify
1. Performance findings and residual risk notes.
