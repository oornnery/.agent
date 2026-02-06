# Agents

Official agent set for single-agent and multi-agent operation.

## Official (11)

- `runner`
- `researcher`
- `reviewer`
- `tester`
- `python-engineer`
- `node-engineer`
- `go-engineer`
- `rust-engineer`
- `platform-engineer`

Full matrix: `.agent/agents/INDEX.md`

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
