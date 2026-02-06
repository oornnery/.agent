# Rules Matrix

This file defines the canonical rule-loading model.

## Rule Layers

## Layer 0 (Always-On)

- `.agent/instructions/rules/00-core.md`
- `.agent/instructions/rules/04-safe-commands.md`

## Layer 1 (Contextual)

- Structural/refactor work: `.agent/instructions/rules/02-architecture.md`
- Validation/check execution: `.agent/instructions/rules/03-tooling.md`
- Large context/deep analysis: `.agent/instructions/rules/11-rlm-context.md`

## Layer 2 (Only Multi-Agent / Pipeline)

- `.agent/instructions/rules/90-agent-protocol.md`

## Task Type -> Rules

| Task Type | Required | Optional |
|---|---|---|
| Small fix (single file) | `00-core`, `04-safe-commands` | `03-tooling` |
| Python backend feature | `00-core`, `04-safe-commands`, `03-tooling` | `02-architecture`, `11-rlm-context` |
| Node (JS/TS) feature | `00-core`, `04-safe-commands`, `03-tooling` | `02-architecture`, `11-rlm-context` |
| Go service feature | `00-core`, `04-safe-commands`, `03-tooling` | `02-architecture`, `11-rlm-context` |
| Rust service/CLI feature | `00-core`, `04-safe-commands`, `03-tooling` | `02-architecture`, `11-rlm-context` |
| Refactor / architecture change | `00-core`, `04-safe-commands`, `02-architecture`, `03-tooling` | `11-rlm-context` |
| Multi-agent pipeline | Layer 0 + contextual rules | `90-agent-protocol` required |

## Agent -> Default Rules

| Agent | Default Rules |
|---|---|
| `runner` | `00-core`, `04-safe-commands` |
| `researcher` | `00-core`, `11-rlm-context` |
| `reviewer` | `00-core`, `02-architecture` |
| `tester` | `00-core`, `03-tooling` |
| `python-engineer` | `00-core`, `02-architecture`, `03-tooling` |
| `node-engineer` | `00-core`, `02-architecture`, `03-tooling` |
| `go-engineer` | `00-core`, `02-architecture`, `03-tooling` |
| `rust-engineer` | `00-core`, `02-architecture`, `03-tooling` |
| `fastapi-engineer` | `00-core`, `02-architecture`, `03-tooling` |
| `jx-engineer` | `00-core`, `02-architecture`, `03-tooling` |
| `platform-engineer` | `00-core`, `03-tooling`, `04-safe-commands` |

## Minimal Load Examples

### Example A: Python bugfix

- `00-core`
- `04-safe-commands`
- `03-tooling`

### Example B: JX page change

- `00-core`
- `04-safe-commands`
- `03-tooling`
- `02-architecture` (if route/layout structure changes)

### Example C: Multi-agent delivery flow

- Layer 0 + contextual
- Add `90-agent-protocol`
