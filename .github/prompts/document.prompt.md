---
description: Sync state files with git reality (CODE READ-ONLY)
mode: agent
---

# /document

**CODE READ-ONLY.** Only update `agent-docs/`.

## Rules

1. Parallel reads: `head -50 agent-docs/STATE.md`, `head -50 agent-docs/PLAN.md`, `git status`, `git log --oneline -5`.
2. Identify drift: uncommitted work, unmarked-Done tasks, new blockers.
3. Update `agent-docs/STATE.md` header to match reality.
4. Sync `agent-docs/PLAN.md` checkboxes.
5. Append to `agent-docs/CHANGELOG.md` only for notable changes.
6. Reference paths, never paste file contents.

≤ 100 words.
