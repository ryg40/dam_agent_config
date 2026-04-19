---
description: Review current changes (READ-ONLY)
agent: review
---

# /review

**READ-ONLY.** Report issues, do not fix.

## Rules

1. Read `head -50 agent-docs/STATE.md`.
2. Run `git status` and `git diff` in parallel.
3. Check: changes match task, no unrelated changes, no security issues, files match PLAN.md scope.
4. For large diffs, delegate focused reads to `explorer`.
5. Report as `path:line — description`. Do NOT edit.
6. Update `agent-docs/STATE.md` only on blocker.

## Output

- **Status**: LGTM | Needs Work
- **Issues**: bullets with file:line refs

≤ 100 words.
