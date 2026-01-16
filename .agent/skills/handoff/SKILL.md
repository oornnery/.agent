---
name: handoff
description: Context management and session transfer. Use when you need to summarize current state, clear context, or prepare for session continuation.
---

# Handoff Skill

Manage context and enable session continuity.

## When to Use

- Context reaching ~60% capacity
- Switching between major tasks
- End of work session
- Before clearing conversation

## Handoff Process

### 1. Summarize Current State

Create `handoff.md` with:

```markdown
# Handoff Summary

**Date**: YYYY-MM-DD HH:MM
**Session Goal**: [Original objective]

## Completed
- ✅ Task 1
- ✅ Task 2

## In Progress
- 🔄 Task 3 (50%)
  - Current state: [description]
  - Next step: [what to do]

## Blocked
- ⏸️ Task 4
  - Reason: [why blocked]
  - Needs: [what's required]

## Files Modified
- `path/to/file.py` — what changed
- `path/to/other.py` — what changed

## Key Decisions Made
1. Chose approach A because [reason]
2. Deferred X to follow-up because [reason]

## Context for Next Session
- [Important context]
- [Key constraints]
- [Open questions]

## Commands to Resume
```bash
# Run this to pick up where we left off
[command 1]
[command 2]
```
```

### 2. Save to File

```bash
# Save handoff summary
cat > .claude/handoff.md << 'EOF'
[content]
EOF
```

### 3. Clear Context

Prepare for new session with clean state.

## Resume from Handoff

When starting new session:

1. Read `handoff.md`
2. Review "In Progress" items
3. Check "Blocked" status
4. Continue from last checkpoint

## Best Practices

- Be specific about current state
- Include exact file paths
- Document decisions with reasoning
- Provide concrete next steps
