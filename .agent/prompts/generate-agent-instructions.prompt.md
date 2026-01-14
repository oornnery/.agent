Analyze this codebase to generate or update `.agent/instructions.md` for guiding AI coding agents.

Focus on discovering the essential knowledge that would help an AI agent be immediately productive in this codebase. Consider:
- Big-picture architecture across multiple files (major components, boundaries, data flows, rationale)
- Critical developer workflows (build, test, debug) including commands not obvious from file inspection
- Project-specific conventions/patterns that differ from defaults
- Integration points, external dependencies, cross-component communication

Source existing AI conventions from:
`**/{.github/copilot-instructions.md,AGENT.md,AGENTS.md,CLAUDE.md,.cursorrules,.windsurfrules,.clinerules,.cursor/rules/**,.windsurf/rules/**,.clinerules/**,README.md}`
(do one glob search)

Guidelines:
- If `.github/copilot-instructions.md` exists, merge intelligently (preserve valuable content; update outdated sections)
- Write concise, actionable instructions (~20–50 lines) in markdown
- Include specific examples from THIS codebase (paths, snippets, commands)
- Avoid generic advice; document only discoverable patterns (not aspirational)
- Reference key files/directories exemplifying patterns

Output:
1) Proposed updated `.agent/instructions.md`
2) List of unclear/incomplete areas that need confirmation from maintainers
