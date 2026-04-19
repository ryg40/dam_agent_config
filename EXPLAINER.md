# EXPLAINER.md

How OpenCode and Claude Code wire together agents, skills, commands, and hooks — and the design decisions behind this repo's configuration.

---

## Part 1 — The Four Extension Points

Both OpenCode and Claude Code expose the same four extension primitives, with slightly different names and trigger semantics. Understanding each is essential before talking about workflows.

### 1. Agents / Subagents — *the "who"*

A separate persona with its own system prompt, tool whitelist, permissions, and (critically) its **own context window**. When a primary agent delegates to a subagent, the subagent's tool output does not flow back into the primary's context — only the subagent's final summary does.

| Framework | Primary agents | Subagents | File location | Trigger |
|-----------|----------------|-----------|---------------|---------|
| **OpenCode** | Built-in `build`, `plan`; custom via `.opencode/agents/*.md` with `mode: primary` | `.opencode/agents/*.md` with `mode: subagent` | `.opencode/agents/` (project) or `~/.config/opencode/agents/` (global) | Primary auto-delegates on task match, or user `@mentions` the subagent |
| **Claude Code** | One primary (the CLI session itself) | `.claude/agents/*.md` with YAML frontmatter | `.claude/agents/` (project) or `~/.claude/agents/` (user) | Auto-invoked when Claude matches the subagent's `description`; explicit via the `Task` tool with `subagent_type` |

**Frontmatter shape** (both frameworks — OpenCode uses YAML, Claude Code uses YAML):

```yaml
---
name: executor                   # Claude Code: required; OpenCode: derived from filename
description: When to use me      # Used by router for auto-invocation
mode: subagent                   # OpenCode only
tools: Read, Edit, Bash          # Tool whitelist
permission:                      # OpenCode permission gates
  edit: allow
  bash: ask
  webfetch: deny
---
```

**Key property for this repo:** a subagent's separate context window is the *primary mechanism* for keeping a small local model from running out of tokens. Everything else is secondary.

### 2. Skills — *the "what, on demand"*

Reusable instruction bundles that the agent **discovers and loads only when needed**. Unlike rules (always loaded) and commands (explicit user invocation), skills sit in the middle: the agent sees their *description* up front and decides to load the full body when a task matches.

| Framework | Location | Invocation |
|-----------|----------|------------|
| **OpenCode** | `.opencode/skills/<name>/SKILL.md` (also reads `.claude/skills/` for compat) | Native `skill` tool — agent sees the short description, loads full content on demand |
| **Claude Code** | `.claude/skills/<name>/SKILL.md` | Auto-loaded by description match; each skill also gets an auto-generated `/slash-command` interface (as of 2026) |

A skill file is a normal markdown doc with YAML frontmatter (`name`, `description`) plus optional bundled scripts/resources in the same folder. Skills are the right primitive when the instructions are *too big to live in the system prompt* but *too general to be a subagent*.

**This repo does not ship skills yet** — the workflow is small enough that rules + commands + subagents cover it. Skills would be the next lever if we added per-language or per-framework playbooks.

### 3. Commands / Slash Commands — *the "explicit verb"*

User-typed verbs (`/plan`, `/execute`). Just markdown files whose body becomes a prompt. The file chooses which agent handles the prompt.

| Framework | Location | Frontmatter |
|-----------|----------|-------------|
| **OpenCode** | `.opencode/commands/*.md` | `description`, `agent` (which agent to route to) |
| **Claude Code** | `.claude/commands/*.md` | Minimal; body uses `$ARGUMENTS` placeholder |
| **Copilot** | `.github/prompts/*.prompt.md` | `description`, `mode: agent` |

Commands are thin by design — they should route to an agent and pass arguments, not re-specify the whole workflow. (This repo's refactor deliberately made them thin; before the refactor, each command duplicated the agent's logic, which drifted.)

### 4. Hooks — *the "when"*

Shell commands the **harness** runs at lifecycle events. Hooks are not LLM-driven — they are deterministic, which makes them the right tool for "from now on, every time X happens, do Y."

| Framework | Event surface |
|-----------|---------------|
| **OpenCode** | `tool.execute.before`, `tool.execute.after`, config + session events |
| **Claude Code** | `PreToolUse`, `PostToolUse`, `PermissionRequest`, `UserPromptSubmit`, `Stop`, `SubagentStop`, and more — configured in `.claude/settings.json` |

Hooks are how you enforce "never let the agent commit without running the formatter" or "log every bash command to an audit file." They fire regardless of what the model decides to do.

**This repo does not ship hooks yet.** Hooks are the next lever for any rule the LLM repeatedly forgets — for example, a `PostToolUse` hook on `Edit` that runs `git status` into the transcript, or a `Stop` hook that refuses to end the session while `agent-docs/STATE.md` is out of sync with git.

---

## Part 2 — How a Workflow Flows Through the Stack

The repo's canonical workflow: **human → `/plan` → `/execute` → `/review` → `/document`**. Here is the actual sequence of primitives fired at each step.

### `/plan <requirement>`

```
user types: /plan add rate-limit header to /api/login
   │
   ▼
harness loads .claude/commands/plan.md (or .opencode/commands/plan.md)
   │
   ▼
command body routes to the `planner` agent
   │  (OpenCode: explicit via `agent: plan` frontmatter;
   │   Claude Code: body tells the model to act as orchestrator)
   ▼
planner reads head -50 of STATE.md + PLAN.md  ← the ONLY files it reads itself
   │
   ▼
planner recognizes it needs code context
   │
   ▼
planner uses Task tool → `explorer` subagent
   │  envelope: Goal / Files / Stop-when / Return format
   ▼
explorer runs glob/grep/read in ITS OWN context window
   │
   ▼
explorer returns ≤ 40-line findings (file:line + snippet)
   │  ← only these 40 lines enter the planner's context
   ▼
planner writes atomic tasks to agent-docs/PLAN.md
planner updates agent-docs/STATE.md (phase: executing)
```

The key move: `explorer`'s 500-line grep output never touches the planner's window. The planner sees 40 lines and makes a decision.

### `/execute [task]`

```
planner reads head -50 PLAN.md, picks next unchecked task
   │
   ▼
planner builds Task Envelope (Goal, Files, Constraints, Stop-when, Return)
   │
   ▼
planner uses Task tool → `executor` subagent
   │
   ▼
executor reads ONLY the files in envelope.Files  (globs/greps disabled)
executor edits → `git diff` → `git commit`
executor updates PLAN.md (task → Done) + STATE.md (progress)
   │
   ▼
executor returns 5-line summary: commit SHA + files + new progress
   │  ← planner's context grows by 5 lines, not 500
   ▼
planner confirms to user
```

If an envelope is incomplete, the executor returns `ENVELOPE INCOMPLETE: <field>` and stops. The planner fixes the envelope — it does not take over the work. This failure mode is deliberate: small models are far more reliable at refusing than at guessing correctly.

### `/review` and `/document`

Both are single-agent, no delegation. Both are **read-only over code**: `/review` may not edit at all; `/document` may only edit `agent-docs/`. Permissions enforce this at the harness level (`edit: deny` in the agent frontmatter), not just via the prompt.

### Where hooks would plug in

None today. Candidates:

- `PostToolUse` on `Edit`/`Write` → auto-run the repo's linter/formatter
- `Stop` hook → block session end if `git status` shows uncommitted changes in tracked files
- `PreToolUse` on `Bash` with `rm -rf` / `git push --force` → hard deny

---

## Part 3 — Design Decisions in This Repo vs. Alternatives

The decisions below all trace back to one assumption: **the planner's context window is the bottleneck, and the cheapest way to widen it is to never let tool output land there.**

### Decision 1 — Orchestrator / executor split is mandatory, not optional

**This repo:** planner has `glob: false`, `grep: false`, `webfetch: false`. It *cannot* do broad reads. It must delegate.

**Bare OpenCode `build` agent:** has every tool. A 35B model asked to implement a feature will typically glob, grep ~15 times, read 8 files, and by then has consumed 30–60k tokens before writing the first edit.

**Bare Claude Code:** same — the default session has all tools and a powerful foundation model that can *afford* the context burn. Cheap on a 200k-context frontier model; fatal at Q8 120k with a 35B.

**Vanilla web chat:** no tools at all. User pastes files in. Works for single-file problems, collapses the moment the answer requires reading three files.

### Decision 2 — Task Envelopes are mandatory; incomplete envelopes are refused

**This repo:** every delegation carries an explicit contract (Goal, Files, Constraints, Stop-when, Return format). Executor refuses rather than guesses.

**Bare frameworks:** delegation is free-form. The primary agent writes a paragraph of instructions; the subagent does its best. This works on Opus/Sonnet because they hold the intent robustly. On Qwen3.5-27B it produces scope creep, duplicate work, and occasionally destructive changes.

**Vanilla web chat:** no delegation at all; the user *is* the envelope.

### Decision 3 — State lives in markdown files with a 50-line actionable header

**This repo:** `STATE.md` and `PLAN.md` have a header/history split. Every agent reads `head -50`, never the whole file.

**Bare frameworks:** no state convention. A session's state is its context window — which vanishes on `/clear` or compaction.

**Vanilla web chat:** state is the scrollback.

The trade-off: markdown state is slower to update than in-memory, but it survives across sessions, across models, and across frameworks. For a human-driven workflow where sessions are short and hand-offs are common, this is worth the write cost.

### Decision 4 — Three frameworks kept in sync rather than picking one

**This repo:** every command, rule, and agent exists in OpenCode, Claude Code, and Copilot form. Commands are thin routers; rules live in a single `AGENTS.md` the frameworks all read.

**Cost:** duplication drift. Mitigated by making command files tiny and rules centralized in `AGENTS.md`.

**Benefit:** your local 35B (OpenCode + llama-serve) and an occasional Claude Code session use the *exact same workflow*. No retraining a user's muscle memory between tools.

### Decision 5 — Permissions as backstops, not suggestions

**This repo:** the reviewer has `edit: deny` in frontmatter. Not "the prompt says don't edit" — the harness blocks `Edit` tool calls entirely.

**Bare frameworks:** permissions are available but often unset, relying on the prompt. Frontier models usually comply; small models often don't.

### Decision 6 — No skills yet, no hooks yet

Deliberate minimalism. Skills and hooks are high-leverage but add surface area. The current 4-command workflow doesn't need them, and shipping unused primitives is a drift risk. Both are flagged in this doc as "next levers."

---

## Part 4 — Trade-offs: Unlimited Tokens vs. Your 72GB VRAM Local Setup

### Scenario A — Unlimited tokens (Claude on anthropic.com, OpenAI API with Opus/GPT-5, any frontier model, pay-per-token)

**Benefits of this config:**

- **Reproducibility.** The envelope contract means the same request produces the same delegation pattern across sessions. Audit trails are consistent.
- **Cost control.** Frontier models are still $$ per million tokens. Routing exploration to a cheaper subagent model (e.g. Haiku for `explorer`, Opus for `planner`) is the standard cost-optimization move and this config supports it directly via per-agent `model` frontmatter.
- **Onboarding clarity.** A new teammate reading `AGENTS.md` + `EXPLAINER.md` understands the system in 15 minutes.
- **Guardrails.** Permissions as backstops prevent "oops, the agent force-pushed" incidents, which happen even with frontier models.

**Negatives of this config:**

- **Overhead.** For a truly trivial task ("rename this variable"), the envelope ceremony and the planner/executor split add 2–3 extra tool calls. On a frontier model this is a rounding error in both cost and latency, but aesthetically it's fussier than just typing the request into a bare session.
- **Delegation tax.** Auto-delegation from primary → subagent incurs one round-trip. If the primary could have done the work in 200 tokens, you've added ~1000 tokens of overhead. Matters at scale, invisible per-session.
- **Rigidity.** Frontier models are genuinely good at "explore, think, act" flows. Forcing them into the envelope structure sometimes leaves capability on the table.

**Bottom line:** you are trading latency and a bit of capability for predictability and cost control. At frontier scale, this is usually worth it for team projects; personal projects might prefer the bare experience.

### Scenario B — Your setup: 72GB VRAM, llama-serve, two models resident at Q8 with ~120k context

Typical pairing: Qwen3.6-35B-A3B (orchestrator, MoE, active params ~3B) + Qwen3.5-27B or Gemma4-31B (executor, dense). Or one of each slot running the same 35B MoE if the dense model won't fit.

**Benefits of this config:**

- **This is what it's designed for.** The entire architecture exists because a 27–35B model degrades hard past ~40k tokens of context. The orchestrator/executor split keeps the planner's live context to ~5–15k across a multi-hour session.
- **Two-model efficiency.** Your hardware can host both simultaneously. The planner instance never handles heavy tool output; the executor instance handles one task at a time and can be aggressively cleared between tasks. Cache reuse on llama-serve stays high because the planner's prompt changes slowly.
- **MoE fits well.** A 35B MoE with 3B active params runs fast per-token and suits the orchestrator role (lots of small decisions, little long-context synthesis). Use a denser executor when edits need stronger code reasoning.
- **Permissions as backstops really matter.** Small models *will* occasionally call a denied tool. Harness-level denial turns a potential incident into a no-op.
- **Envelope refusal is a safety valve.** When the executor gets a vague envelope it returns `ENVELOPE INCOMPLETE` instead of hallucinating a file path. This is the single biggest reliability win observed with small models in this config.
- **No cost pressure.** Unlike scenario A, overhead tool calls are free. Run the envelope ceremony on every task.

**Negatives of this config:**

- **Small models fight the envelope format.** A 27B model sometimes emits the envelope in a slightly wrong shape — wrong field name, missing Stop-when, extra prose. Mitigation: the executor's refusal path handles it, but it adds a retry. Few-shot examples in the agent prompts would help further (potential future addition).
- **Auto-delegation routing is weaker.** OpenCode and Claude Code both pick subagents by description matching. Small models pick wrong subagent ~5–10% of the time in practice. `@mention` explicit routing is more reliable; commands (`/execute`) sidestep this entirely.
- **Long-context skills degrade.** If you do add skills later, note that a 35B Q8 reading a 2000-line `SKILL.md` will lose coherence. Keep skill bodies under ~200 lines or break them up.
- **MoE routing jitter.** Some MoE models (including Qwen3.6-A3B) show higher variance on structured-output tasks like envelope emission than same-size dense models. If envelope compliance matters more than speed, prefer the dense 27–31B class for the *orchestrator* slot; if you want the planner to move fast and the executor to be careful, do the reverse.
- **No streaming summaries from subagents.** Both OpenCode and Claude Code wait for the subagent to finish before returning the summary. On a small local model handling a 20-file repo search, that's a 30–90s blocking wait with no UI feedback. Acceptable trade for context savings, but worth knowing.
- **Two-model context switching.** If llama-serve is juggling the orchestrator and executor on overlapping GPU memory (not fully resident), KV-cache rebuild costs add up. Keep both fully resident (72GB is enough for two Q8 30-class models) or accept the switch cost.

**Bottom line:** for your setup the config is close to the minimum viable structure for getting serious work out of a 35B local model. Without the split, you'd top out at single-file refactors; with it, you can sustain multi-task sessions because the planner's working context stays small and the executor's context gets reset per task.

### Scenario C — Vanilla web chat with a frontier model (claude.ai, chatgpt.com)

Included for completeness. No tools, no files, no hooks.

**Benefits:** zero setup. Great for one-shot questions, code review of pasted snippets, design discussions.

**Negatives:** cannot read your repo, cannot commit, cannot run anything. State is scrollback. Every session starts cold. All of the benefits above are structurally unreachable.

This repo's config exists precisely because vanilla chat can't do repo-scale work and bare framework defaults burn context too fast for small local models.

---

## Part 5 — Quick Reference: "Which primitive should I use?"

| Need | Use |
|------|-----|
| Deterministic behavior on every tool call | **Hook** |
| User-triggered verb that kicks off a workflow | **Slash command** |
| A persona with its own context window and tool limits | **Subagent** |
| Reusable instruction bundle that loads only when relevant | **Skill** |
| Always-on rules that shape every response | **`AGENTS.md` / `CLAUDE.md`** |
| Temporary, task-scoped state | **`agent-docs/STATE.md`** |
| Cross-session memory for a specific repo | **`agent-docs/` files** |

---

## Sources

- [OpenCode Agents](https://opencode.ai/docs/agents/)
- [OpenCode Skills](https://opencode.ai/docs/skills/)
- [OpenCode Commands](https://opencode.ai/docs/commands/)
- [OpenCode Rules](https://opencode.ai/docs/rules/)
- [Claude Code Subagents](https://code.claude.com/docs/en/sub-agents)
- [Claude Code Full Stack (MCP, Skills, Subagents, Hooks)](https://alexop.dev/posts/understanding-claude-code-full-stack/)
- [Claude Code Plugins](https://www.anthropic.com/news/claude-code-plugins)
- [Skills vs Commands vs Subagents vs Plugins](https://www.youngleaders.tech/p/claude-skills-commands-subagents-plugins)
