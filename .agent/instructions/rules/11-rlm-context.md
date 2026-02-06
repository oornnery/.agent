---
name: rlm-context
description: RLM context management. Apply when analyzing large codebases or planning complex changes.
---

# RLM Context Rule — Prompt as Environment

## Principle
Never stuff the entire codebase/rules/docs into the prompt.
Treat large context as an **external environment** (filesystem / repo),
and pull only the minimum required snippets.

## Default Strategy (3 Passes)
1. **MAP**: Build a small index (files/modules/components)
2. **DRILL**: Open only relevant regions (small slices)
3. **EXEC**: Implement and validate

## Slice Policy
- Prefer reading 80-200 lines max per file chunk
- Prefer grep/search before opening files
- Prefer summaries that keep pointers (file + line ranges)

## Pointer Format
Always preserve source locations:
```markdown
- Finding: [description]
  Source: path/to/file.py:L120-L180
  Why it matters: [reason]
```

## Recursive Decomposition
If the task is large:
- Create subtasks
- Invoke subagents (researcher/reviewer/tester) on each subtask
- Merge results at the end

## Rule Loading
Before coding:
1. Identify task category (UI / API / DB / Security / pipeline)
2. Load only the required rule files from `.agent/instructions/rules/`
3. Execute with focused context
