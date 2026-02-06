# Agent Rules, Skills, and Workflows

Organization of the coding-agent knowledge base, clearly separated into:

- `Rules / Instructions / Memory` (always on)
- `Workflows / Prompts` (manual execution)
- `Skills` (on-demand plugins in domain containers)
- `Agents` (optional personas/modes)

## Current Structure

```text
.agent/
├── .rumdl.toml              # Markdown lint/format config
├── instructions/
│   └── rules/                # Always-on rules
├── settings.local.json       # Local permissions/memory
├── workflows/                # Manual macros/flows
├── prompts/                  # Reusable prompt files
├── skills/                   # Active skills (one folder per domain)
├── agents/                   # Official personas (single + multi-agent)
└── MIGRATION_MAP.md          # Full migration mapping
```

## Classification Rules

1. `instructions/rules`: short mandatory rules.
2. `memory`: persistent local settings.
3. `workflows` and `prompts`: manually triggered macros.
4. `skills/<domain>/SKILL.md`: skill entrypoint.
5. `skills/<domain>/**/*.md`: local complementary content for that skill (including submodules).

## Rule Loading (Layers)

- Layer 0 (always): `00-core`, `04-safe-commands`
- Layer 1 (contextual): `02-architecture`, `03-tooling`, `05-git-workflow`, `06-handoff`, `07-code-review`, `08-context-map`, `11-rlm-context`
- Layer 2 (multi-agent/pipeline only): `90-agent-protocol`

Canonical source: `.agent/instructions/rules/README.md`

## Official Agent Set

- `runner`
- `researcher`
- `reviewer`
- `tester`
- `refactor`
- `python-engineer`
- `node-engineer`
- `go-engineer`
- `rust-engineer`
- `platform-engineer`

Canonical source: `.agent/agents/README.md`

## Active Skill Set

- `design-system`
- `explorer`
- `go`
- `node`
- `python`
- `python/fastapi`
- `python/jx`
- `python/pytest`
- `rust`
- `testing`

## Notes

- Stack-specific commands are canonical in stack skills.
- Validation orchestration is canonical in `.agent/skills/testing/SKILL.md`.
- Markdown lint/format uses `uvx rumdl` with repo config in `.rumdl.toml`.
- Table formatting is enabled via `MD060` (aligned table columns).
- Code review is canonical in `.agent/instructions/rules/07-code-review.md`.
- Handoff/session transfer is canonical in `.agent/instructions/rules/06-handoff.md`.
- Context mapping is canonical in `.agent/instructions/rules/08-context-map.md`.
- In Node projects, select profile and manager/runtime from `.agent/skills/node/`.
- Previously removed content was not automatically restored.
