---
description: Implement next task with atomic commit
mode: agent
---

# /execute

Pick the next task from PLAN.md and implement it under the Task Envelope contract.

## Rules

1. Read `head -50 agent-docs/PLAN.md`. Pick first unchecked (or user-named) task.
2. Treat the task as a Task Envelope (AGENTS.md): confirm Goal, Files, Constraints, Stop when.
3. If Files is not explicit, do focused searches — but stop as soon as you have the paths. Do not read broadly.
4. Read only the files in the envelope. Make the edits.
5. Commit: `<type>: <description>\n\nTask: <task name>`.
6. Move task Active → Done in PLAN.md; update STATE.md progress.
7. If the envelope is incomplete, stop and ask — do not guess.

Final message ≤ 50 words.
