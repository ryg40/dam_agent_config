---
description: Scan for changes and update documentation state
mode: agent
---

# Document

Scan for changes and update documentation state. Run this anytime to sync reality with docs.

**IMPORTANT**: This is the core sync command. Always updates `/agent-docs/`.

## Instructions

1. Run `git status` to see uncommitted changes
2. Run `git diff` to see what changed
3. Run `git log --oneline -10` to see recent commits
4. Read current `/agent-docs/STATE.md`
5. Identify drift:
   - Uncommitted work not in STATE.md
   - Completed tasks not marked done in PLAN.md
   - New files not documented
   - Changed scope or blockers
6. Update `/agent-docs/STATE.md` to reflect reality
7. Update `/agent-docs/CHANGELOG.md` with recent changes (if significant)
8. Update `/agent-docs/PLAN.md` if tasks were completed outside workflow

## STATE.md Format

```markdown
# State

**Phase**: planning | executing | reviewing | blocked | complete
**Updated**: YYYY-MM-DD HH:MM

## Current Focus
What's being worked on right now.

## In Progress
- Task or change currently underway

## Uncommitted Changes
- file.txt (modified) - brief description

## Recent Commits
- abc1234: commit message

## Blockers
- Any blocking issues

## Next Steps
- What to do next
```

## Output

Files updated in `/agent-docs/`:
- `STATE.md` - Reflecting current reality
- `CHANGELOG.md` - If there are notable changes
- `PLAN.md` - If tasks were completed

Summary of what changed since last sync.

## Doc Update Checklist

- [ ] Updated all sections of `/agent-docs/STATE.md`
- [ ] Synced `/agent-docs/PLAN.md` task status
- [ ] Added entries to `/agent-docs/CHANGELOG.md` if needed
- [ ] Set timestamp in STATE.md
