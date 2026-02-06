# Node Stack Selection

Use this file first to detect the correct Node stack profile.

## 1) Language Mode Detection

Use TypeScript-first mode when:

- `tsconfig.json` exists
- `.ts`/`.tsx` files are primary in `src/`
- `typecheck` script exists and is required in CI

Use JavaScript mode when:

- no `tsconfig.json`
- source is mainly `.js`/`.mjs`/`.cjs`

## 2) Runtime/Package Manager Detection

Use exactly one manager/runtime based on repository signals:

- Bun: `bun.lockb` or `bunfig.toml`
- pnpm: `pnpm-lock.yaml`
- npm: `package-lock.json` or `npm-shrinkwrap.json`

If no lockfile exists:

- follow existing CI/docs conventions first
- otherwise default to `pnpm` for monorepos and `npm` for simple single-package repos

## 3) Validation Pipeline Template

1. Format check
2. Lint
3. Typecheck (TypeScript mode)
4. Tests
5. Build smoke check when required
