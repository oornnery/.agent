# npm Commands

Use when `package-lock.json` or `npm-shrinkwrap.json` is present.

## Install and Dependencies

- `npm ci` (CI)
- `npm install` (local)
- `npm install <package>`
- `npm install -D <package>`

## Validation and Build

- `npm run format -- --check`
- `npm run lint`
- `npm run typecheck`
- `npm test`
- `npm run build`

## Runtime

- `npm run dev`
- `npm start`

## CI Note

Prefer `npm ci` for reproducible CI installs.
