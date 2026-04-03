---
description: Review current changes for quality
mode: agent
---

# Review

Review current changes for quality.

## Efficient Reads

```bash
head -50 agent-docs/STATE.md  # Quick context
git diff                       # Current changes
git log --oneline -5           # Recent commits
```

## Steps

1. Read first 50 lines of STATE.md
2. Check `git status` and `git diff`
3. Review against checklist
4. Report findings
5. Update STATE.md if blocked

## Checklist

- [ ] Changes match task
- [ ] No unrelated changes
- [ ] Docs updated if needed
- [ ] No security issues

## Output

- **Status**: LGTM | Needs Work
- **Issues**: (if any)
- Updated STATE.md (phase: blocked if issues)
