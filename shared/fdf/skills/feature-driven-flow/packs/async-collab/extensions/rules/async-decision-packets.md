# Rule: async-decision-packets

## id
`async-decision-packets`

## title
Async Decision Packets (Team TUI Exports)

## tags
`team`, `async`, `persistence`, `handoff`

## applies_to_phases
`scope`, `clarify`, `architect`, `verify`

## intent
Export user/team questions and decision points into versionable markdown "packets" that can be shared outside the chat (email/messenger/VCS) and answered asynchronously.

## guidance
### scope
1. Always present the Effective Rule Matrix in-chat for user confirmation; packets are export artifacts for async/team handoff.
2. When proposing profiles/matrix, produce a packet file:
   - `<run_root_dir>/<run_id>/<packets_dir>/01-scope-rule-matrix.md` using `../../templates/packet-decision-tui.md`.
3. The packet must include:
   - recommended option marked clearly
   - enough context to decide without reading the full chat

### clarify
1. When you ask clarification questions, also export them to:
   - `<run_root_dir>/<run_id>/<packets_dir>/03-clarify-questions.md` using `../../templates/packet-questions-tui.md`.
2. Keep questions prioritized and decision-ready.

### architect
1. When presenting architecture options, also export the decision to:
   - `<run_root_dir>/<run_id>/<packets_dir>/04-architect-option-choice.md` using `../../templates/packet-decision-tui.md`.

### verify
1. When asking user disposition (fix now/defer/proceed), export it to:
   - `<run_root_dir>/<run_id>/<packets_dir>/06-verify-disposition.md` using `../../templates/packet-decision-tui.md`.

## checks
### scope
1. Effective Rule Matrix is shown in-chat and explicitly confirmed or adjusted by the user.
2. Packet file exists and includes the full set of options and a recommended choice.

### clarify
1. Packet file includes all blocking questions and answer fields.

### architect
1. Packet file includes all options and the recommendation.

### verify
1. Packet file includes disposition options and any required context (findings summary).

## outputs
### scope
1. Exported packet path(s).

### clarify
1. Exported packet path(s).

### architect
1. Exported packet path(s).

### verify
1. Exported packet path(s).
