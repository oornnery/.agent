# Workflow: Handoff

Use this workflow to persist session state and enable deterministic continuation.

## Input

- Session goal
- Completed/in-progress/blocked tasks
- Files touched
- Key decisions
- Resume commands

## Execution

1. Summarize current state in Markdown:
   - completed, in-progress, blocked
   - files modified and rationale
   - decisions and pending questions
2. Save handoff artifact to:
   - project handoff file (recommended: `handoff.md` in repo root)
3. Include protocol references when in multi-agent mode:
   - `.agent/instructions/rules/90-agent-protocol.md`
   - `.agent/instructions/rules/11-rlm-context.md`

## Output Template

```markdown
# Handoff Summary

**Date**: YYYY-MM-DD HH:MM
**Session Goal**: ...

## Completed

- ...

## In Progress

- ...

## Blocked

- ...

## Files Modified

- `path`: reason

## Key Decisions

1. ...

## Resume Commands

~~~bash
...
~~~
```
