# Agents

Official agent set for single-agent and multi-agent operation.

## Core Official (10)

- `runner`
- `researcher`
- `reviewer`
- `tester`
- `refactor`
- `python-engineer`
- `node-engineer`
- `go-engineer`
- `rust-engineer`
- `platform-engineer`

## Specialization Model

- Language specialists (primary): `python-engineer`, `node-engineer`, `go-engineer`, `rust-engineer`
- Gate/platform specialists: `tester`, `reviewer`, `platform-engineer`
- Structural improvement specialist: `refactor`

## Agent -> Skills

| Agent               | Skills                                                                 |
| ------------------- | ---------------------------------------------------------------------- |
| `runner`            | `explorer`                                                             |
| `researcher`        | `explorer`                                                             |
| `reviewer`          | `explorer`                                                             |
| `tester`            | `testing`, `python`, `node`, `go`, `rust`                              |
| `refactor`          | `explorer`, `testing`, `python`, `node`, `go`, `rust`, `design-system` |
| `python-engineer`   | `python`, `testing`, `python/pytest`                                   |
| `node-engineer`     | `node`, `testing`                                                      |
| `go-engineer`       | `go`, `testing`                                                        |
| `rust-engineer`     | `rust`, `testing`                                                      |
| `platform-engineer` | `python`, `node`, `go`, `rust`, `testing`                              |

## Agent -> Default Rules

| Agent               | Default Rules                                                                                                         |
| ------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `runner`            | `00-core`, `04-safe-commands`, `05-git-workflow`, `06-handoff`, `08-context-map`                                      |
| `researcher`        | `00-core`, `08-context-map`, `11-rlm-context`                                                                         |
| `reviewer`          | `00-core`, `02-architecture`, `07-code-review`, `08-context-map`                                                      |
| `tester`            | `00-core`, `03-tooling`                                                                                               |
| `refactor`          | `00-core`, `02-architecture`, `03-tooling`, `04-safe-commands`, `05-git-workflow`, `08-context-map`, `11-rlm-context` |
| `python-engineer`   | `00-core`, `02-architecture`, `03-tooling`                                                                            |
| `node-engineer`     | `00-core`, `02-architecture`, `03-tooling`                                                                            |
| `go-engineer`       | `00-core`, `02-architecture`, `03-tooling`                                                                            |
| `rust-engineer`     | `00-core`, `02-architecture`, `03-tooling`                                                                            |
| `platform-engineer` | `00-core`, `03-tooling`, `04-safe-commands`, `05-git-workflow`                                                        |

## Delegation Flow (Strict Multi-Agent)

1. `runner` routes by language specialist first.
2. `tester` owns validation gate.
3. `reviewer` owns read-only review gate.

## Frontmatter Contract

Use this template for new agents:

```md
---
name: <agent-name>
description: <short role>
tools: [ ... ]
skills: [ ... ]
default_rules: [ ... ]
mode: single|multi
---
```
