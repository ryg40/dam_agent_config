# Plan

<!-- EFFICIENT READ: First 50 lines contain active work -->

**Goal**: Small-model orchestrator/executor refactor + installer
**Progress**: 11/11

## Active

(all tasks complete)

## Blocked

(none)

---
<!-- COMPLETED BELOW -->

## Done (2026-04-18)

- [x] **1. Rewrite AGENTS.md** — numbered imperatives, target-runtime section, small-model guidance
- [x] **2. Planner → orchestrator** — delegates all code/web/exec to subagents
- [x] **3. Add `explorer` subagent** — read-only codebase exploration, ≤ 40 line returns
- [x] **4. Harden executor** — strict envelope contract, refuses incomplete envelopes
- [x] **5. Add `.claude/agents/`** — executor, explorer, learner for Claude Code parity
- [x] **6. Task Envelope format** — documented in AGENTS.md, referenced by all subagents
- [x] **7. Rewrite slash commands** — thin orchestrator invocations across all three frameworks
- [x] **8. Small-model notes in CLAUDE.md** — delegation rules, output budget
- [x] **9. Update state files** — STATE, PLAN, CHANGELOG reflect the refactor
- [x] **10. Installer script** — `install.sh` with dry-run/force/skip-existing
- [x] **11. `.gitignore`** — root file + installer block appended to targets

## Done (2026-04-10)

- [x] **1. Create AGENTS.md at repo root** - Universal agent instructions file
- [x] **2. Restructure .opencode/ to match conventions** - Added agents/, modes/, skills/
- [x] **3. Create OpenCode agent definitions** - YAML frontmatter with permissions
- [x] **4. Add opencode.json config** - Minimal project config
- [x] **5. Reconcile agents.md → AGENTS.md** - Reference docs vs actionable rules
- [x] **6. Update CLAUDE.md to reference AGENTS.md** - Cross-reference, no duplication
- [x] **7. Update agent-docs/STATE.md** - Reflect completed work
