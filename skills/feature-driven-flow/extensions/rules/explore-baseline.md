# Rule: explore-baseline

## id
`explore-baseline`

## title
Explore Baseline

## tags
`process`, `explore`

## applies_to_phases
`explore`

## intent
Build an accurate repository behavior map before design and implementation.

## guidance
### explore
1. Run parallel exploration passes when possible (at least two perspectives).
2. Trace analogous capability paths, architecture seams, and integration surfaces.
3. Read all key files identified by exploration.
4. Summarize change surface and boundaries.
5. Do not suggest implementation changes unless explicitly requested.

## checks
### explore
1. Must-read file list is complete.
2. Runtime behavior map is coherent.
3. Integration boundaries and dependencies are captured.
4. Exploration favors trace accuracy over broad but shallow coverage.

## outputs
### explore
1. Trigger surfaces with repository references.
2. Runtime path map in ordered steps.
3. Data contracts, mutations, and side effects.
4. Boundary/dependency map.
5. Must-read file set for downstream phases.
