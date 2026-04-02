---
description: Implement the next task from the plan with an atomic commit
---

# Execute

Implement the next task from the plan with an atomic commit.

**IMPORTANT**: Always update `/agent-docs/` after every action.

## Instructions

1. Read `/agent-docs/PLAN.md` and `/agent-docs/STATE.md`
2. Find the next uncompleted task (respect dependencies)
3. If $ARGUMENTS specifies a task, use that instead
4. Implement the task
5. Stage and commit with a clear message
6. Mark the task complete in `/agent-docs/PLAN.md`
7. Update `/agent-docs/STATE.md` with progress

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
- Updated `/agent-docs/PLAN.md` (task marked done)
- Updated `/agent-docs/STATE.md` (progress updated, timestamp refreshed)

If all tasks complete, set STATE.md phase to "complete".

## Doc Update Checklist

- [ ] Marked task complete in `/agent-docs/PLAN.md`
- [ ] Updated phase in `/agent-docs/STATE.md`
- [ ] Updated "Recent Commits" in STATE.md
- [ ] Set timestamp in STATE.md
