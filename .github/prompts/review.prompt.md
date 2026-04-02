---
description: Review current changes for quality and correctness
mode: agent
---

# Review

Review current changes for quality and correctness.

**IMPORTANT**: Always update `/agent-docs/` after every action.

## Instructions

1. Check `git status` for uncommitted changes
2. Check `git diff` for staged and unstaged changes
3. Review recent commits if no uncommitted changes
4. Evaluate against these criteria:
   - Code quality and style
   - Test coverage (are changes tested?)
   - Documentation sync (are docs updated?)
   - Atomic commits (is each commit focused?)
5. Report findings
6. Update `/agent-docs/STATE.md` with review status

## Review Checklist

- [ ] Changes match the stated task
- [ ] No unrelated changes mixed in
- [ ] Tests pass (if applicable)
- [ ] Documentation reflects changes
- [ ] Commit message is clear
- [ ] No security issues introduced

## Output

Provide a review summary:
- **Status**: LGTM / Needs Work
- **Issues**: List any problems found
- **Suggestions**: Optional improvements

Update `/agent-docs/STATE.md`:
- Set phase to "reviewing" or back to "executing"
- Note any blockers found
- Update timestamp

## Doc Update Checklist

- [ ] Updated phase in `/agent-docs/STATE.md`
- [ ] Added blockers if any issues found
- [ ] Set timestamp in STATE.md
