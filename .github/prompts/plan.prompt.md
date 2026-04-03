---
description: Break requirements into atomic tasks
mode: agent
---

# Plan

Break requirements into atomic tasks.

## Efficient Reads

```bash
head -50 agent-docs/STATE.md  # Quick context
head -50 agent-docs/PLAN.md   # Active tasks only
```

Read full files only when debugging or need history.

## Steps

1. Read first 50 lines of STATE.md and PLAN.md
2. Parse requirement from user
3. Break into atomic tasks (one commit each)
4. Update PLAN.md header with tasks
5. Update STATE.md header (phase: planning)

## Task Format

```markdown
## Active

- [ ] **Task name** - Brief description
  - Files: list
  - Depends: (if any)
```

## Output

- Updated PLAN.md (tasks in Active section)
- Updated STATE.md (phase: planning → executing)
