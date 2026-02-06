# Agents Index

Official agent set and responsibility map.

## Agent -> Skills

| Agent | Skills |
|---|---|
| `runner` | `context-map`, `explorer`, `handoff`, `git-workflow` |
| `researcher` | `context-map`, `explorer` |
| `reviewer` | `code-review` |
| `tester` | `python`, `python/test-runner`, `node`, `go`, `rust` |
| `python-engineer` | `python`, `python/fastapi`, `python/jx`, `python/faststream`, `python/test-runner` |
| `node-engineer` | `node`, `python/test-runner` |
| `go-engineer` | `go`, `python/test-runner` |
| `rust-engineer` | `rust`, `python/test-runner` |
| `fastapi-engineer` | `python`, `python/fastapi`, `python/faststream`, `python/test-runner` |
| `jx-engineer` | `python`, `python/jx`, `python/test-runner`, `design-system`, `node` |
| `platform-engineer` | `python`, `python/test-runner`, `node`, `go`, `rust`, `git-workflow` |

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

## Delegation Flow (Strict Multi-Agent)

1. `runner` orchestrates and delegates implementation.
2. `tester` owns validation gate.
3. `reviewer` owns read-only review gate.
