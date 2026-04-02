---
description: Implement the next task from the plan with an atomic commit
---

# Execute

Implement the next task from the plan with an atomic commit.

## Instructions

1. Read PLAN.md and STATE.md
2. Find the next uncompleted task (respect dependencies)
3. If $ARGUMENTS specifies a task, use that instead
4. Implement the task
5. Stage and commit with a clear message
6. Mark the task complete in PLAN.md
7. Update STATE.md with progress

## Commit Message Format

```
<type>: <description>

- What was done
- Why it was done

Task: <task name from plan>
```

Types: feat, fix, docs, refactor, test, chore

## Output

- Implemented code changes
- One atomic git commit
- Updated PLAN.md (task marked done)
- Updated STATE.md (progress updated)

If all tasks complete, set STATE.md phase to "complete".
