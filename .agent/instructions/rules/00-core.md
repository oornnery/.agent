---
name: core
description: Core safety rules and principles. Apply always when making code changes.
---

# Core Principles

## Safety Rules

- **Read first**: Always read files before editing—never hallucinate paths/APIs
- **Small diffs**: Keep changes small and verifiable
- **No surprise deletions**: Never delete files without explicit permission
- **Validate always**: After changes run: format → lint → typecheck → test

## Second-Order Thinking

Before any change, ask "And then what?":

- What happens immediately after?
- What happens when others maintain this?
- What breaks if this fails partially?

## Anti-Patterns (Never Do)

- ❌ Invent paths, APIs, or flags that don't exist
- ❌ Skip failing tests or ignore errors
- ❌ Make large, sprawling changes
- ❌ Commit code that doesn't pass checks

## Recovery

If something goes wrong: stop → read error → diagnose → fix incrementally → verify
