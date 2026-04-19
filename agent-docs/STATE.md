# State

<!-- EFFICIENT READ: First 50 lines contain all actionable state -->

**Phase**: complete
**Updated**: 2026-04-18
**Progress**: 11/11

## Focus

Small-model (30B–122B) orchestrator/executor refactor + installer — complete.

## Blocked

(none)

## Next

Ready for a real workload. Invoke `/plan <requirement>` against a local model to validate envelope behavior.

---
<!-- CONTEXT BELOW: Read only when needed -->

## Decisions

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-04-10 | Create AGENTS.md alongside CLAUDE.md | AGENTS.md is the universal standard; OpenCode uses it over CLAUDE.md |
| 2026-04-10 | Review/document agents get edit:deny | Read-only constraint enforced at config level, not just prompt level |
| 2026-04-18 | Orchestrator/executor split | Planner becomes primary; code reads go to `explorer` subagent, implementation to `executor` — keeps planner context small enough for 35B local models |
| 2026-04-18 | Mandatory Task Envelope format | Makes delegation contract explicit; subagents refuse incomplete envelopes rather than guess |
| 2026-04-18 | Claude Code `.claude/agents/` directory | Parity with OpenCode subagents; lets Claude's Task tool use the same executor/explorer/learner pattern |
| 2026-04-18 | Installer script | Lets this config drop into any existing repo with skip-existing default and `--force` override |

## Session Log

| Date | Action | Outcome |
|------|--------|---------|
| 2026-04-03 | init | Created state files |
| 2026-04-10 | plan + execute | OpenCode compatibility + AGENTS.md (7 tasks) |
| 2026-04-18 | plan | 11 tasks for small-model refactor + installer |
| 2026-04-18 | execute 1 | Rewrote AGENTS.md with numbered rules, envelope format, target-runtime section |
| 2026-04-18 | execute 2 | Planner converted to orchestrator (`.opencode/agents/plan.md`) |
| 2026-04-18 | execute 3 | Added `explorer` subagent for codebase reads |
| 2026-04-18 | execute 4 | Hardened executor with envelope contract |
| 2026-04-18 | execute 5 | Added `.claude/agents/` with executor/explorer/learner |
| 2026-04-18 | execute 6 | Task Envelope format documented in AGENTS.md |
| 2026-04-18 | execute 7 | Slash commands rewritten as thin orchestrator calls (Claude, OpenCode, Copilot) |
| 2026-04-18 | execute 8 | CLAUDE.md updated with small-model operating notes |
| 2026-04-18 | execute 9 | State files updated (this) |
| 2026-04-18 | execute 10 | Installer script `install.sh` with dry-run/force/skip-existing |
| 2026-04-18 | execute 11 | `.gitignore` for repo and installer-managed block for targets |
