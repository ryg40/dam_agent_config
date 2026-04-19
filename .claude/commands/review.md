# /review

**READ-ONLY.** Review changes; do not fix them.

## Rules

1. Read `head -50 agent-docs/STATE.md`.
2. Run `git status` and `git diff` in parallel.
3. Check against:
   - Changes match the stated task
   - No unrelated changes mixed in
   - No obvious security issues
   - File paths match what PLAN.md said would change
4. If the diff is large, delegate focused reads to `explorer` rather than reading yourself.
5. Report issues as `path:line — description`. Do NOT edit code.
6. Update `agent-docs/STATE.md` only if the review surfaces a blocker.

## Output

- **Status**: LGTM | Needs Work
- **Issues**: bullet list with file:line refs

≤ 100 words unless a detailed issue list demands more.
