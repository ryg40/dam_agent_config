# Plan

<!-- EFFICIENT READ: First 50 lines contain active work -->

**Goal**: Configure repo for OpenCode compatibility and AGENTS.md enforcement
**Progress**: 0/7

## Active

- [ ] **1. Create AGENTS.md at repo root** - Universal agent instructions file
  - Files: `AGENTS.md`
  - Notes: Takes precedence over CLAUDE.md in OpenCode. Must contain project context, workflow rules, state file locations, efficient read patterns, and commit style. Keep imperative and actionable. This is the highest-leverage file - injected into every conversation.

- [ ] **2. Restructure .opencode/ to match conventions** - Add agents/, modes/, skills/ dirs
  - Files: `.opencode/agents/`, `.opencode/modes/`, `.opencode/skills/`
  - Depends: none
  - Notes: OpenCode expects plural dirs: agents/, commands/, modes/, skills/, tools/, plugins/. We already have commands/.

- [ ] **3. Create OpenCode agent definitions** - YAML frontmatter agents in .opencode/agents/
  - Files: `.opencode/agents/plan.md`, `.opencode/agents/execute.md`, `.opencode/agents/review.md`, `.opencode/agents/document.md`
  - Depends: 2
  - Notes: Each file needs YAML frontmatter with description, permission (edit, bash, webfetch), and optional model/temperature. Body = system prompt. Review + document agents should have `edit: deny`. Omit `mode: subagent` so they appear in agent list.

- [ ] **4. Add opencode.json config** - Project-level OpenCode configuration
  - Files: `opencode.json`
  - Depends: none
  - Notes: Minimal config pointing to AGENTS.md via customInstructions, and any model preferences. Keep lightweight.

- [ ] **5. Reconcile agents.md → AGENTS.md** - Consolidate agent docs
  - Files: `agents.md`, `AGENTS.md`
  - Depends: 1
  - Notes: Current `agents.md` has detailed agent definitions. Move actionable instructions to AGENTS.md, keep `agents.md` as reference documentation. Ensure AGENTS.md uses enforcement patterns: imperative verbs, explicit constraints, programmatic checks.

- [ ] **6. Update CLAUDE.md to reference AGENTS.md** - Cross-reference and avoid duplication
  - Files: `CLAUDE.md`
  - Depends: 1, 5
  - Notes: CLAUDE.md and AGENTS.md will coexist. In OpenCode, AGENTS.md wins. In Claude Code, CLAUDE.md is used. Keep them aligned but non-redundant. CLAUDE.md should reference AGENTS.md for shared rules.

- [ ] **7. Update agent-docs/STATE.md** - Reflect current work
  - Files: `agent-docs/STATE.md`, `agent-docs/CHANGELOG.md`
  - Depends: all above

## Blocked

(none)

---
<!-- COMPLETED BELOW -->

## Done

(tasks move here)
