# Instructions (Always-On)

Always-on rules live in `.agent/instructions/rules/`.

## Layered Model

Official matrix: `.agent/instructions/rules/INDEX.md`

### Layer 0 (always)

1. `00-core.md`
2. `04-safe-commands.md`

### Layer 1 (by context)

1. `02-architecture.md` (when changing structure)
2. `03-tooling.md` (when running checks)
3. `11-rlm-context.md` (for large-context/deep analysis tasks)

### Layer 2 (multi-agent/pipeline only)

1. `90-agent-protocol.md`

## Local Memory

- File: `.agent/settings.local.json`
- Purpose: local permissions and preferences.
