# pnpm Commands

Use when `pnpm-lock.yaml` is present.

## Install and Dependencies

- `pnpm install`
- `pnpm add <package>`
- `pnpm add -D <package>`

## Validation and Build

- `pnpm format --check`
- `pnpm lint`
- `pnpm typecheck`
- `pnpm test`
- `pnpm build`

## Runtime

- `pnpm dev`
- `pnpm start`

## CI Note

Prefer `pnpm install --frozen-lockfile` in CI.
