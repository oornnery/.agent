---
name: explorer
description: Read-only codebase exploration and architecture mapping. Use for understanding unfamiliar code, finding patterns, and generating documentation.
---

# Explorer Skill

Analyze codebases without making changes.

> **⚠️ READ-ONLY SKILL**
> Explorer CANNOT edit any files. Only reads and reports.

## Capabilities

- ✅ Read files
- ✅ Search patterns (grep, glob)
- ✅ Browse directories
- ✅ Map architecture
- ✅ Create context maps
- ✅ Generate documentation
- ❌ No editing

## Exploration Tasks

### 1. Quick Overview
```
explorer overview
```
- Entry points
- Key modules
- Dependencies
- Test structure

### 2. Find Patterns
```
explorer patterns [area]
```
- Naming conventions
- Error handling
- Data access patterns
- Testing patterns

### 3. Map Dependencies
```
explorer deps [module]
```
- Import graph
- External dependencies
- Circular dependency check

### 4. Security Scan
```
explorer security
```
- Hardcoded secrets
- Unsafe patterns
- Auth/authz flows

### 5. Generate Diagrams
```
explorer diagrams
```

Generate Mermaid diagrams during exploration to visualize architecture and flows.

**Types to generate:**
- **Architecture**: Component relationships and boundaries
- **Data Flow**: Request/response sequences
- **Component**: Module dependencies
- **State Machine**: Complex stateful systems

**When:**
- After identifying major components
- When tracing request/response cycles
- For complex stateful systems
- When mapping dependencies

**Best practices:**
- Keep diagrams focused and readable
- Use consistent naming conventions
- Reference actual file paths in labels

### 6. Generate AGENTS.md (Required After Full Exploration)
```
explorer generate-agents-md
```

After completing exploration, generate `.agent/instructions.md` to guide AI agents.

**Process:**
1. **Search** for existing AI conventions (glob search):
   - `.github/copilot-instructions.md`, `AGENT.md`, `AGENTS.md`, `CLAUDE.md`
   - `.cursorrules`, `.windsurfrules`, `.clinerules`
   - `.cursor/rules/**`, `.windsurf/rules/**`, `.clinerules/**`
   - `README.md`

2. **Analyze** essential knowledge:
   - Architecture (components, boundaries, data flows, rationale)
   - Critical workflows (build, test, debug commands)
   - Project-specific conventions/patterns
   - Integration points, dependencies, cross-component communication

3. **Merge** intelligently:
   - Preserve valuable content from existing files
   - Update outdated sections
   - Avoid duplication

**Output format:**
```markdown
# AI Agent Instructions

## Architecture Overview
[High-level description with key components and relationships]

## Architecture Diagram
```mermaid
graph TB
    [Include architecture diagram]
```

## Data Flow
```mermaid
sequenceDiagram
    [Include sequence diagram]
```

## Critical Workflows
- **Build**: `command`
- **Test**: `command`
- **Debug**: `command`

## Project Conventions
- [Specific patterns unique to this codebase]
- [Naming conventions]
- [Code organization principles]

## Key Files & Directories
| Path | Purpose |
|------|---------|
| `path/to/file` | Description |

## Integration Points
- [External services and how they're integrated]
- [Cross-component communication patterns]

## Dependencies
- [Critical dependencies and their usage patterns]
```

**Guidelines:**
- Write concise, actionable instructions (~20–50 lines)
- Include specific examples from THIS codebase (paths, snippets, commands)
- Avoid generic advice; document only discoverable patterns
- Reference key files/directories exemplifying patterns

**Final output:**
1. Proposed updated `.agent/instructions.md` (full content)
2. List of unclear/incomplete areas needing confirmation

## Best Practices

- Start broad, then narrow
- Document findings immediately
- Flag uncertainties
- **Always generate AGENTS.md** after completing a full codebase exploration
- Use existing AI conventions as a starting point when available
- Focus on actionable, specific guidance rather than generic advice
- Don't assume—verify

## RLM Pattern Reference

Use `.agent/instructions/rules/11-rlm-context.md` as the canonical source for
`MAP → DRILL → EXEC`, slicing policy, and pointer format.
