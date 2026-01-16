# Step 02 — PLAN (Implementation Plan + Checkpoints)

## Goal
Produce a plan that is safe, testable, and decomposed into small commits.

## Plan Structure

### 1. Approach (1 paragraph)
Brief summary of the implementation strategy.

### 2. Tasks Checklist
Ordered list of discrete tasks:

```markdown
- [ ] Task 1: Description
- [ ] Task 2: Description
- [ ] Task 3: Description
```

### 3. Commit Plan
What changes per commit:

| Commit | Scope | Description |
|--------|-------|-------------|
| 1 | Models | Add new data model |
| 2 | Service | Implement business logic |
| 3 | Routes | Add API endpoint |
| 4 | Tests | Add unit tests |

### 4. Testing Plan
- Unit tests for new logic
- Integration tests for API
- Edge cases to cover
- Error scenarios

### 5. Rollout / Migration
- Database migrations needed?
- Feature flag required?
- Backwards compatibility?
- Deprecation warnings?

## Second-Order Checks

Before finalizing plan, verify:

| Question | Answer |
|----------|--------|
| What else will this break? | |
| What new error states are introduced? | |
| What happens under partial failure? | |
| What happens on retry/idempotency? | |
| How will this scale? | |
| What monitoring is needed? | |

## Plan Template

```markdown
# Implementation Plan: [Feature Name]

## Approach
[1 paragraph summary]

## Tasks
- [ ] 1. [First task]
- [ ] 2. [Second task]
- [ ] 3. [Third task]

## Commits
1. `feat(models): add User model` — schema + migrations
2. `feat(service): implement user creation` — business logic
3. `feat(api): add POST /users endpoint` — routing
4. `test(users): add unit tests` — coverage

## Testing
- Unit: `test_user_service.py`
- Integration: `test_user_api.py`
- Edge cases: empty input, duplicate email, rate limit

## Rollout
- [ ] Database migration
- [ ] Feature flag: `ENABLE_NEW_USERS`
- [ ] Monitor: error rate, latency
```

## Interactive Mode Checkpoint

If mode = interactive, ask:

```
CHECKPOINT: Plan Review

Proposed approach: [summary]

Tasks: [count] implementation steps
Commits: [count] atomic commits
Tests: [types] to add

Risks identified: [summary]

Proceed with this plan?
```

## Output (APEX_STATE)

```json
{
  "current_step": "step-02-plan",
  "commits": [
    {"message": "feat(models): add User model"},
    {"message": "feat(service): implement user creation"}
  ],
  "next_step": "step-03-execute"
}
```
