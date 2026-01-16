---
name: second-order-thinking
description: Apply second-order thinking to all decisions. Ask 'And then what?' before making changes.
---

# Second-Order Thinking

> "First-order thinking is fast and easy. Second-order thinking is deliberate."

## The Core Question

**"And then what?"**

Before making any change, ask:
- What happens immediately after this change?
- What happens a week later?
- What happens when someone else maintains this?

## Decision Framework

### Time Horizons

| Horizon | Question |
|---------|----------|
| 10 minutes | Does this work right now? |
| 10 days | Will this still work after deployment? |
| 10 months | Will this be maintainable? |

### Ecosystem Impact

Before making a change, consider:

| Actor | Question |
|-------|----------|
| Users | How does this affect the end user? |
| Team | Can others understand and maintain this? |
| CI/CD | Will automated checks catch issues? |
| Ops | How does this affect monitoring/alerting? |
| Security | Are there new attack vectors? |

## Anti-Patterns

### First-Order Thinking (Avoid)
```
Problem: Tests are slow
→ Solution: Skip the slow tests
→ Consequence: Bugs slip through
```

### Second-Order Thinking (Use)
```
Problem: Tests are slow
→ Why slow? Database hits
→ Solution: Mock database in unit tests
→ Keep integration tests with real DB
→ Consequence: Fast tests + real coverage
```

## Application to Code Changes

### Before Adding a Feature
1. What existing code will this touch?
2. What tests need to change?
3. How will this scale?
4. What happens if this fails partially?

### Before Refactoring
1. What breaks if I'm wrong?
2. How do I verify correctness?
3. Is this the right time for this change?
4. What's the blast radius?

### Before Deleting Code
1. Is this called from somewhere I didn't find?
2. Is this documented elsewhere?
3. Will anyone be surprised by this removal?

## Checklist

Before finalizing any change, verify:

- [ ] Considered downstream effects
- [ ] Thought about edge cases and errors
- [ ] Considered maintenance burden
- [ ] Evaluated security implications
- [ ] Assessed performance impact
