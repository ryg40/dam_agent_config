---
description: Plan requirements into atomic tasks (orchestrator)
mode: agent
---

# /plan

Act as the Planner orchestrator (see AGENTS.md).

## Rules

1. Read only `head -50 agent-docs/STATE.md` and `head -50 agent-docs/PLAN.md`.
2. Delegate code exploration to a read-only sub-agent with a Task Envelope (Goal, Files, Constraints, Stop when, Return format — see AGENTS.md). If Copilot cannot spawn subagents, do focused reads yourself but stay under 40 lines per file.
3. Delegate web research to a research helper the same way.
4. Break the requirement into atomic tasks. Each task lists explicit Files, Constraints, Stop when.
5. Write tasks to `agent-docs/PLAN.md` Active; update `agent-docs/STATE.md` phase to `executing`.
6. Do NOT implement — `/execute` handles that.

Final message ≤ 100 words.
