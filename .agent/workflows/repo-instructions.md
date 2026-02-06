# Workflow: Repo Instructions

Use this workflow to generate or refresh repository-level AI instructions from real project structure.

## Purpose

Produce an implementation-ready instructions document rooted in repository truth.

## Input

- Repository root path (default: current)
- Existing instruction files (if any)

## Execution

1. Discover existing instruction sources:
   - `.github/copilot-instructions.md`, `AGENT.md`, `AGENTS.md`, `CLAUDE.md`
   - `.cursorrules`, `.windsurfrules`, `.clinerules`
   - `.cursor/rules/**`, `.windsurf/rules/**`, `.clinerules/**`
   - local `README.md`
2. Build architecture/context map from current code.
3. Extract canonical build/test/debug commands.
4. Merge useful conventions and remove outdated/duplicate sections.
5. Write a concise instructions artifact to:
   - `.agent/instructions/README.md` (or project-specific equivalent)

## Expected Output

- Updated instructions document
- Explicit list of uncertain points requiring confirmation
