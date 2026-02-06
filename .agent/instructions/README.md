# Instructions (Always-On)

Always-on rules live in `.agent/instructions/rules/`.

## Layered Model

Official matrix: `.agent/instructions/rules/README.md`

### Layer 0 (always)

1. `00-core.md`
2. `04-safe-commands.md`

### Layer 1 (by context)

1. `02-architecture.md` (when changing structure)
2. `03-tooling.md` (when running checks)
3. `05-git-workflow.md` (when managing branches, commits, rebases, PRs)
4. `06-handoff.md` (when preserving state across sessions or task switches)
5. `07-code-review.md` (when performing formal review gates)
6. `08-context-map.md` (when starting discovery/mapping in unfamiliar or large repos)
7. `11-rlm-context.md` (for large-context/deep analysis tasks)

### Layer 2 (multi-agent/pipeline only)

1. `90-agent-protocol.md`

## Local Memory

- File: `.agent/settings.local.json`
- Purpose: local permissions and preferences.
- Assistant profile variants:
  - `.agent/settings.codex.json`
  - `.agent/settings.copilot.json`
  - `.agent/settings.antigravity.json`
  - `.agent/settings.claude.json`
- Note: `settings.local.json` remains the active local file. Other files are per-assistant templates and may require syntax adjustments depending on the tool parser.
