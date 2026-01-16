# Changelog Format

## Structure

```markdown
# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- New feature description

### Changed
- Change description

### Fixed
- Bug fix description

### Removed
- Removed feature description

## [1.2.0] - 2026-01-15

### Added
- Feature A
- Feature B

### Fixed
- Bug X
```

## Categories

| Category | Description |
|----------|-------------|
| Added | New features |
| Changed | Changes in existing functionality |
| Deprecated | Soon-to-be removed features |
| Removed | Removed features |
| Fixed | Bug fixes |
| Security | Vulnerability fixes |

## Guidelines

- Keep entries concise and user-focused
- Link to PRs/issues when relevant
- Use present tense ("Add" not "Added")
- Group by category, then by scope

## Example Entry

```markdown
## [2.1.0] - 2026-01-15

### Added
- JWT authentication for API endpoints (#123)
- Rate limiting with configurable thresholds (#125)

### Changed
- Improved error messages for validation failures (#124)

### Fixed
- Race condition in concurrent user creation (#126)

### Security
- Updated dependencies to patch CVE-2026-0001
```
