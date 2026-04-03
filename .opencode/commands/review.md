---
description: Review current changes for quality
---

# Review

Review current changes for quality. **READ-ONLY**: Report issues, don't fix them.

## Routing

**Use when:**
- After `/execute` before committing more
- Before creating a PR
- Spot-checking recent work

**Skip when:**
- No uncommitted changes or recent commits
- Just need to sync state → `/document`

## Efficient Reads

```bash
head -50 agent-docs/STATE.md  # Quick context
git diff                       # Current changes
git log --oneline -5           # Recent commits
```

## Steps

1. Read first 50 lines of STATE.md
2. Run `git status` and `git diff` in parallel
3. Review against checklist
4. Report findings (don't fix)
5. Update STATE.md if blocked

## Checklist

- [ ] Changes match task
- [ ] No unrelated changes
- [ ] No security issues
- [ ] Tests pass (if applicable)

## Output

Reference issues by file path:

- **Status**: LGTM | Needs Work
- **Issues**: `src/app.ts:42` - description
- Updated STATE.md (phase: blocked if issues)
