---
description: Create or update a task plan from requirements
mode: agent
---

# Plan

Create or update a task plan from requirements.

**IMPORTANT**: Always update `/agent-docs/` after every action.

## Instructions

1. Read `/agent-docs/STATE.md` and `/agent-docs/PLAN.md`
2. Parse the requirement provided by the user
3. Break it into atomic, committable tasks
4. Identify dependencies between tasks
5. Write/update `/agent-docs/PLAN.md` with the task structure
6. Update `/agent-docs/STATE.md` to reflect planning is complete

## Task Format

Each task in PLAN.md should have:
- [ ] **Task name** - Brief description
  - Files: list of files to touch
  - Depends: task dependencies (if any)

## Output

Update these files in `/agent-docs/`:
- `PLAN.md` - Task breakdown
- `STATE.md` - Set phase to "planned", update timestamp

If no input provided, review and refine the existing plan.

## Doc Update Checklist

- [ ] Updated `/agent-docs/STATE.md` with current phase
- [ ] Updated `/agent-docs/PLAN.md` with tasks
- [ ] Set timestamp in STATE.md
