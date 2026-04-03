# Document

Sync docs with reality. Run anytime.

## Efficient Reads

```bash
head -50 agent-docs/STATE.md  # Current state
head -50 agent-docs/PLAN.md   # Active tasks
git status                     # Uncommitted
git log --oneline -5           # Recent commits
```

## Steps

1. Read first 50 lines of STATE.md and PLAN.md
2. Run git status and git log
3. Identify drift:
   - Uncommitted work not in STATE
   - Completed tasks not marked done
   - New blockers
4. Update STATE.md header to match reality
5. Sync PLAN.md task status
6. Append to Session Log if significant

## Output

- STATE.md reflects current reality
- PLAN.md tasks synced
- CHANGELOG.md updated (if notable changes)
