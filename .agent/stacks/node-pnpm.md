# Stack: Node.js (pnpm)

## Package Manager
- **Tool**: pnpm
- **Lock file**: `pnpm-lock.yaml`
- **Config**: `package.json`

## Commands

### Install Dependencies
```bash
pnpm install
```

### Add Package
```bash
pnpm add <package>
pnpm add -D <package>
```

### Format
```bash
pnpm format
# or directly
pnpm exec prettier --write .
```

### Lint
```bash
pnpm lint
pnpm lint --fix
# or directly
pnpm exec eslint . --fix
```

### Typecheck
```bash
pnpm typecheck
# or directly
pnpm exec tsc --noEmit
```

### Run Tests
```bash
# Quick run
pnpm test

# Watch mode
pnpm test --watch

# Coverage
pnpm test --coverage
```

### Run Application
```bash
# Development
pnpm dev

# Production build
pnpm build
pnpm start
```

## CI Pipeline (GitHub Actions)

```yaml
name: CI
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'
      - run: pnpm install
      - run: pnpm format --check
      - run: pnpm lint
      - run: pnpm typecheck
      - run: pnpm test
```

## File Structure

```
project/
├── package.json
├── pnpm-lock.yaml
├── tsconfig.json
├── .prettierrc
├── eslint.config.js
├── src/
│   ├── index.ts
│   └── lib/
└── tests/
    └── index.test.ts
```
