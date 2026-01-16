# Step 00b — ECONOMY MODE

## When to Use
- User wants a fast result
- Small, isolated change
- Limited time or context budget
- Simple bug fix or typo

## Rules

### Minimize Scanning
- Avoid reading entire codebase
- Only read essential files directly related to the change
- Trust existing patterns without deep analysis

### Prefer Simple Solutions
- One-pass implementation
- Skip optional refactors
- No "while we're here" improvements
- Smallest viable change only

### Communication
- Ask only if completely blocked
- No confirmation checkpoints
- Report only final result

### Skip These Steps
- Deep architecture analysis
- Comprehensive test coverage
- Extensive code review
- Documentation updates (unless requested)

## Output (APEX_STATE)

```json
{
  "mode": "economy",
  "scope": "minimal"
}
```

## Example Usage

```bash
/apex --economy fix typo in config loader
/apex --economy update version in package.json
/apex --economy add missing import
```
