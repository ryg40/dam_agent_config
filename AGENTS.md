# AGENTS.md

Universal instructions for all AI coding agents in this repo (Claude Code, OpenCode, Copilot).

## Target Runtime

This config is tuned for **small local models** served via llama-server and vLLM:

- Dense: Gemma4-31B, Qwen3.5-27B (Q8, ~120k ctx)
- MoE: Qwen3.6-35B-A3B, Qwen3.5-122B-A10B (Q8, ~120k ctx)
- Typically **two models loaded simultaneously** — one orchestrator, one executor

Reference docker-compose stacks live in [`configs/`](configs/):

| Stack | Slot | Path |
|-------|------|------|
| llama-server (via llama-swap) | orchestrator | [`configs/llama-server/`](configs/llama-server/) |
| vLLM | executor | [`configs/vllm/`](configs/vllm/) |

All sensitive values (e.g. `HF_TOKEN`) load from per-stack `.env` files that are
gitignored. See `.env.example` in each directory. Never inline tokens in
`docker-compose.yml` or commit messages.

Every rule below exists to keep context small and decisions local. Small models degrade fast past ~40k tokens; delegation is the main lever.

## Core Rules (numbered, imperative)

1. **READ** `head -50 agent-docs/STATE.md` and `head -50 agent-docs/PLAN.md` at the start of every task. Do not read the full files.
2. **NEVER** read a source file unless its path appears in the current task envelope or the user message.
3. **DELEGATE** codebase exploration to the `explorer` subagent. Do not glob/grep/read broadly yourself.
4. **DELEGATE** web research to the `learner` subagent. Do not use webfetch/websearch directly.
5. **ONE** atomic commit per logical change. Format: `<type>: <description>` (types: feat|fix|docs|refactor|test|chore).
6. **UPDATE** `agent-docs/STATE.md` and `agent-docs/PLAN.md` after every action that changes repo state.
7. **REFERENCE** files by `path:line`, never paste file contents into state files.
8. **STOP** immediately when the current task's `stop_when` condition is met. Do not continue into adjacent work.
9. **ASK** rather than assume when the task envelope is incomplete or ambiguous.
10. **RESPECT** read-only constraints: `/review` and `/document` never modify code; subagents respect their declared permissions.

## Output Budget

Small models waste context on preamble and recap. Apply:

- No restating the user's request back to them
- No "I will now..." narration before tool calls
- Final response ≤ 100 words unless the task genuinely needs more
- Subagent returns ≤ 40 lines
- Reasoning stays internal — do not stream it

## Orchestrator / Executor Pattern

This repo uses a **two-model split**. The orchestrator plans and delegates; the executor does the tool calls.

```
                 ┌─────────────────┐
   user  ───▶    │  orchestrator   │  (primary agent, small context footprint)
                 │  plan / oneoff  │
                 └───┬────────┬────┘
                     │        │
         envelope    │        │    envelope
                     ▼        ▼
            ┌──────────┐  ┌──────────┐  ┌──────────┐
            │ explorer │  │ executor │  │ learner  │
            │ (reads)  │  │ (writes) │  │ (web)    │
            └──────────┘  └──────────┘  └──────────┘
              40 lines     commit +       40 lines
              max back     state update   max back
```

**Why:** the orchestrator never accumulates file contents, only compressed findings. Two 35B models can sustain a long session this way; one 35B model cannot.

## Task Envelope

Every delegation from orchestrator to a subagent MUST use this envelope:

```markdown
## Task Envelope

**Goal:** <one sentence, imperative>
**Files:** `path/a.ts`, `path/b.ts`   # explicit list, no globs
**Constraints:**
  - <must/never items>
**Stop when:** <observable condition — commit made, findings returned, etc.>
**Return format:** <what orchestrator expects back>
```

Executors and explorers MUST refuse to act if any field is missing. Ask the orchestrator instead of guessing.

## Agent Roles

| Agent | Mode | Reads | Writes | Web | Commits | Purpose |
|-------|------|-------|--------|-----|---------|---------|
| planner | primary | state files only | state files | no | no | Break work into tasks, delegate |
| executor | subagent | envelope files | envelope files | no | yes | Implement one task |
| explorer | subagent | any (read-only) | no | no | no | Return compressed code findings |
| learner | subagent | no | no | yes | no | Return compressed web findings |
| reviewer | primary | all | state files | no | no | Report issues, never fix |
| documentor | primary | all | `agent-docs/` only | no | no | Sync state with git reality |
| oneoff | primary | via subagents | via subagents | via learner | yes | Ad-hoc plan+execute outside workflow |
| agentfixer | primary | agent files | agent files (ask) | no | yes | Modify agent definitions |

## State Files

```
agent-docs/STATE.md      Phase, focus, blockers, progress  (first 50 lines = actionable)
agent-docs/PLAN.md       Task breakdown with checkboxes    (first 50 lines = active)
agent-docs/CHANGELOG.md  Change history                    (append-only)
```

Structure: first 50 lines = actionable state above `---`; history below `---` is debugging-only.

## Commands (all frameworks)

| Command | Role | Constraint |
|---------|------|------------|
| `/plan <req>` | planner orchestrates | delegates reads to explorer |
| `/execute [task]` | planner → executor subagent | bounded; envelope required |
| `/review` | reviewer | READ-ONLY |
| `/document` | documentor | CODE READ-ONLY |

## Commit Format

```
<type>: <description>

Task: <task name from plan>
```

## File Structure

```
AGENTS.md                         Universal rules (this file, highest priority)
CLAUDE.md                         Claude Code specific notes
agents.md                         Reference documentation
opencode.json                     OpenCode project config
agent-docs/                       Shared state (all tools read/write)
configs/                          Reference docker-compose stacks for the model servers
configs/llama-server/             llama-swap + llama-server (orchestrator slot)
configs/vllm/                     vLLM (executor slot)
.opencode/agents/                 OpenCode agent definitions
.opencode/commands/               OpenCode slash commands
.claude/agents/                   Claude Code subagent definitions
.claude/commands/                 Claude Code slash commands
.github/copilot-instructions.md   Copilot rules
.github/prompts/                  Copilot prompt files
```
