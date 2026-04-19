# /document

**CODE READ-ONLY.** Only update files in `agent-docs/`.

## Rules

1. Run in parallel: `head -50 agent-docs/STATE.md`, `head -50 agent-docs/PLAN.md`, `git status`, `git log --oneline -5`.
2. Identify drift:
   - Uncommitted work not reflected in STATE
   - Completed commits not marked Done in PLAN
   - New blockers or scope changes
3. Update the header (first 50 lines) of `agent-docs/STATE.md` to match reality.
4. Sync task checkboxes in `agent-docs/PLAN.md`.
5. Append a line to `agent-docs/CHANGELOG.md` only for notable changes.
6. Reference paths, never paste file contents.

≤ 100 words: summary of drift fixed.
