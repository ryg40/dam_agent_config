---
description: Scan for changes and update documentation state
mode: agent
---

# Document

Scan for changes and update documentation state. Run this anytime to sync reality with docs.

## Instructions

1. Run `git status` to see uncommitted changes
2. Run `git diff` to see what changed
3. Run `git log --oneline -10` to see recent commits
4. Compare current state against STATE.md
5. Identify drift:
   - Uncommitted work not in STATE.md
   - Completed tasks not marked done
   - New files not documented
   - Changed scope or blockers
6. Update STATE.md to reflect reality
7. Update CHANGELOG.md with recent changes (if significant)

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

- Updated STATE.md reflecting current reality
- Updated CHANGELOG.md if there are notable changes
- Summary of what changed since last sync
