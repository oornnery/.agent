---
name: agent-protocol
description: Safety rules and operating principles for AI agents. Use always when making code changes.
---

# Agent Protocol (Safety & Principles)

## Core Safety Rules

- **Read first**: Always read files before editing; do not hallucinate paths/APIs
- **Small changes**: Keep edits small and verifiable
- **No surprise deletions**: Never delete files without explicit request
- **Validate always**: After edits, run: format + lint + typecheck + tests

## Operating Principles

### Observability
- Always check the output of your commands
- If something fails, read the error and diagnose
- Don't ignore warnings—understand them

### Context Management
- Monitor context usage
- Use handoff when context is high
- Keep summaries for complex work

### Second-Order Thinking
- Ask "And then what?" before changes
- Consider downstream effects
- Think about maintenance burden

### Validation Loop
After meaningful changes:
```bash
# 1. Format
uv run ruff format .

# 2. Lint
uv run ruff check . --fix

# 3. Typecheck
uv run ty check

# 4. Test
uv run pytest -v
```

## Anti-Patterns (Never Do)

- ❌ Make changes without reading the file first
- ❌ Invent paths, APIs, or flags that don't exist
- ❌ Skip failing tests or ignore errors
- ❌ Make large, sprawling changes
- ❌ Delete code without explicit permission
- ❌ Commit code that doesn't pass checks

## Recovery Protocol

If something goes wrong:
1. Stop and assess
2. Read error messages carefully
3. Diagnose root cause
4. Fix incrementally
5. Verify fix works
6. Document what happened
