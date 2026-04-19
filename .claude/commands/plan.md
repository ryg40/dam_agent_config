# /plan

Act as the **Planner orchestrator** (see AGENTS.md + `.claude/agents/`).

Requirement: $ARGUMENTS

## Rules (must follow)

1. Read only `head -50 agent-docs/STATE.md` and `head -50 agent-docs/PLAN.md` yourself.
2. If you need code context, delegate to the `explorer` subagent with a Task Envelope (see AGENTS.md).
3. If you need web context, delegate to the `learner` subagent.
4. Break the requirement into atomic tasks. Each task must list explicit file paths, constraints, and a `Stop when` condition.
5. Write tasks to the Active section of `agent-docs/PLAN.md`. Update `agent-docs/STATE.md` phase to `executing`.
6. Do NOT implement anything. `/execute` is a separate command.

Final message ≤ 100 words: confirm task count and next step.
