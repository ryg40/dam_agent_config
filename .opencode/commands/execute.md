---
description: Delegate next task to executor subagent
agent: plan
---

# /execute

The `plan` orchestrator picks the next task and delegates it to the `execute` subagent.

## Rules (must follow)

1. Read `head -50 agent-docs/PLAN.md`. Pick the first unchecked task (or the one named by the user).
2. Build a Task Envelope (AGENTS.md): Goal, Files, Constraints, Stop when, Return format.
3. If Files is not explicit, delegate to `explorer` first — do NOT grep/read directly.
4. Send the envelope to `execute` via the task tool.
5. If `execute` returns `ENVELOPE INCOMPLETE`, fix the envelope and retry. Do NOT take over the work yourself.
6. On success, confirm commit + PLAN.md update.

Final message ≤ 50 words.
