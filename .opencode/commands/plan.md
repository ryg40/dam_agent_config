---
description: Plan requirements into atomic tasks (orchestrator)
agent: plan
---

# /plan

Invoke the `plan` orchestrator agent. Requirement follows.

## Rules (must follow)

1. Read only `head -50 agent-docs/STATE.md` and `head -50 agent-docs/PLAN.md`.
2. Delegate any code exploration to `explorer` via the task tool, using the Task Envelope format in AGENTS.md.
3. Delegate any web research to `learner`.
4. Break the requirement into atomic tasks with explicit Files, Constraints, and Stop when for each.
5. Write tasks to `agent-docs/PLAN.md` Active section; update `agent-docs/STATE.md` phase to `executing`.
6. Do NOT implement — `/execute` handles that.

Final message ≤ 100 words.
