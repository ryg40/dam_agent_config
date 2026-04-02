---
description: Review current changes for quality and correctness
---

# Review

Review current changes for quality and correctness.

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

If $ARGUMENTS is a PR number or commit SHA, review that specifically.
