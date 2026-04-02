---
description: Create or update a task plan from requirements
mode: agent
---

# Plan

Create or update a task plan from requirements.

## Instructions

1. Read the current STATE.md and PLAN.md if they exist
2. Parse the requirement provided by the user
3. Break it into atomic, committable tasks
4. Identify dependencies between tasks
5. Write/update PLAN.md with the task structure
6. Update STATE.md to reflect planning is complete

## Task Format

Each task in PLAN.md should have:
- [ ] **Task name** - Brief description
  - Files: list of files to touch
  - Depends: task dependencies (if any)

## Output

Update or create:
- `PLAN.md` - Task breakdown
- `STATE.md` - Current state (set phase to "planned")

If no input provided, review and refine the existing plan.
