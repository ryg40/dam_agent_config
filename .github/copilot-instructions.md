# Copilot Instructions

Universal agent rules live in [AGENTS.md](../AGENTS.md). Read that first.

## Target Runtime

This repo's agent configuration is tuned for small local models (30B–122B dense or MoE) served via llama-serve. Copilot is supported but inherits the same delegation-heavy, low-context style.

## Rules (short form — see AGENTS.md for full list)

1. Start with `head -50 agent-docs/STATE.md` and `head -50 agent-docs/PLAN.md`.
2. Delegate code exploration and web research when a sub-agent is available. Otherwise do minimal focused reads.
3. Every delegation uses the Task Envelope format (Goal, Files, Constraints, Stop when, Return format).
4. One atomic commit per logical change: `<type>: <description>` (types: feat|fix|docs|refactor|test|chore).
5. Update `agent-docs/STATE.md` and `agent-docs/PLAN.md` after every state-changing action.
6. Reference files as `path:line` in state files. Never paste contents.

## Commands

| Command | Purpose |
|---------|---------|
| `/plan` | Break requirements into atomic tasks |
| `/execute` | Implement one task, atomic commit |
| `/review` | Read-only review of changes |
| `/document` | Sync state with git reality |

## State Files

```
agent-docs/STATE.md      First 50 lines = actionable; below `---` = history
agent-docs/PLAN.md       First 50 lines = active tasks; below `---` = done
agent-docs/CHANGELOG.md  Append-only
```

## Output Budget

- Final messages ≤ 100 words unless the task needs more
- No preamble, no restating the request, no narration before tool calls
