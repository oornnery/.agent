# Step 07 — ADD TESTS (Coverage That Matters)

## Goal
Add tests that prove behavior, not implementation details.

## Testing Philosophy

> "Test behavior, not implementation."

Good tests:
- Describe what the system DOES
- Survive refactoring
- Are easy to understand
- Run fast

Bad tests:
- Test internal methods
- Are brittle to changes
- Are slow or flaky
- Have complex setup

## Test Types

| Type | When | Coverage |
|------|------|----------|
| Unit | Logic, pure functions | High |
| Integration | API endpoints, DB | Medium |
| E2E | Critical flows | Low (expensive) |

## What to Test

### Happy Path
- Normal successful execution
- Expected inputs → expected outputs

### Error Paths
- Invalid inputs
- Missing data
- Permission denied
- External service failures

### Edge Cases
- Empty inputs
- Boundary values
- Large inputs
- Concurrent access

## Test Structure (AAA Pattern)

```python
def test_user_creation():
    # Arrange
    user_data = {"name": "John", "email": "john@example.com"}
    
    # Act
    result = create_user(user_data)
    
    # Assert
    assert result.id is not None
    assert result.name == "John"
```

## Naming Convention

```python
def test_<what>_<when>_<expected>():
    """
    test_create_user_with_valid_data_returns_user
    test_create_user_with_duplicate_email_raises_error
    test_get_user_when_not_found_returns_none
    """
```

## Fixtures Best Practices

- Keep fixtures small and focused
- Use factory functions over global fixtures
- Clear setup, minimal teardown
- Avoid shared mutable state

## Avoid

- ❌ Testing private methods directly
- ❌ Mocking everything
- ❌ Time-dependent tests without freezing
- ❌ Tests that depend on execution order
- ❌ Sleeping in tests (use proper sync)

## Output Format

```markdown
## Tests Added

### Unit Tests
- `tests/test_user_service.py::test_create_user_success`
- `tests/test_user_service.py::test_create_user_duplicate_email`

### Integration Tests
- `tests/test_user_api.py::test_post_users_endpoint`

### Behavior Covered
- User creation with valid data
- Duplicate email detection
- API response format
```

## Output (PIPELINE_STATE)

```json
{
  "current_step": "step-07-tests",
  "tests_added": [
    "tests/test_user_service.py",
    "tests/test_user_api.py"
  ],
  "files_created": ["tests/test_user_service.py"],
  "next_step": "step-08-run-tests"
}
```
