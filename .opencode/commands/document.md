---
description: Sync docs with reality
---

# Document

Sync docs with reality. **CODE READ-ONLY**: Only updates `agent-docs/`.

## Routing

**Use when:**
- Anytime to sync state
- After manual changes outside workflow
- Before handing off to another session
- Frequently during long sessions

**Skip when:**
- About to `/execute` (it updates state itself)

## Efficient Reads

Run these in parallel:

```bash
head -50 agent-docs/STATE.md  # Current state
head -50 agent-docs/PLAN.md   # Active tasks
git status                     # Uncommitted
git log --oneline -5           # Recent commits
```

## Steps

1. Read STATE.md, PLAN.md, git status, git log in parallel
2. Identify drift:
   - Uncommitted work not in STATE
   - Completed tasks not marked done
   - New blockers
3. Update STATE.md header to match reality
4. Sync PLAN.md task status
5. Append to Session Log if significant

## File Path References

In STATE.md, reference paths not content:

```markdown
## Uncommitted
- `src/app.ts` (modified) - added auth check
- `lib/utils.ts` (new) - helper functions
```

## Output

- STATE.md reflects current reality
- PLAN.md tasks synced
- CHANGELOG.md updated (if notable)
