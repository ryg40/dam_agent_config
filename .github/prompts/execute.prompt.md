---
description: Implement next task with atomic commit
mode: agent
---

# Execute

Implement next task with atomic commit.

## Efficient Reads

```bash
head -50 agent-docs/STATE.md  # Quick context
head -50 agent-docs/PLAN.md   # Active tasks only
```

## Steps

1. Read first 50 lines of STATE.md and PLAN.md
2. Find next unchecked task (or use specified task)
3. Implement the task
4. Commit with message: `<type>: <description>`
5. Move task from Active to Done in PLAN.md
6. Update STATE.md header (progress, focus)

## Commit Format

```
<type>: <description>

Task: <task name>
```

Types: feat, fix, docs, refactor, test, chore

## Output

- Code changes
- One atomic commit
- PLAN.md task moved to Done
- STATE.md progress updated
