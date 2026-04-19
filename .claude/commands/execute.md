# /execute

Act as the **Planner orchestrator** delegating one task to the `executor` subagent.

Task (optional, else pick next unchecked): $ARGUMENTS

## Rules (must follow)

1. Read `head -50 agent-docs/PLAN.md`. Pick the task matching `$ARGUMENTS` or the first unchecked one.
2. Build a Task Envelope (AGENTS.md defines the fields): Goal, Files, Constraints, Stop when, Return format.
3. If the task lacks explicit files, delegate to `explorer` first to fill them in — do NOT grep/read yourself.
4. Invoke the `executor` subagent via the Task tool with the full envelope.
5. On return, confirm the commit landed and the task moved to Done. If the executor returned `ENVELOPE INCOMPLETE`, fix the envelope and retry — do not do the work yourself.

Final message ≤ 50 words: commit SHA and progress.
