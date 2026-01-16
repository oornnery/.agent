# Step 00b — INTERACTIVE MODE

## When to Use
- Ambiguous requirements
- High-risk change (database, billing, auth)
- Multiple possible approaches
- User explicitly requested checkpoints
- Breaking changes or migrations

## Rules

### Checkpoint Questions (Micro-Approval)

Ask concise questions at these gates:

| After Step | Ask About |
|------------|-----------|
| Analyze | Confirm approach + scope |
| Plan | Confirm implementation strategy |
| Review | Confirm severity of findings |
| Before PR | Confirm messaging + rollout plan |

### Question Format

Keep questions **brief and actionable**:

```
CHECKPOINT: [Step Name]

I plan to: [1-2 sentence summary]

Approach options:
A) [Option A - recommended]
B) [Option B - alternative]

Risks: [brief risk summary]

Proceed with A, or prefer B?
```

### Never Ask About
- Obvious formatting/style choices
- Standard patterns already in codebase
- Trivial implementation details

## Output (APEX_STATE)

```json
{
  "mode": "interactive",
  "checkpoints_remaining": ["plan", "review", "pr"]
}
```

## Example Usage

```bash
/apex --interactive refactor billing pipeline
/apex --interactive migrate database schema
/apex --interactive add payment processing
```
