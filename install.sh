#!/usr/bin/env bash
# Install this agent config into an existing repo.
#
# Usage:
#   ./install.sh <target-repo-path>            # skip files that already exist
#   ./install.sh <target-repo-path> --force    # overwrite everything
#   ./install.sh <target-repo-path> --dry-run  # show what would be copied
#
# What gets installed:
#   AGENTS.md                       universal agent rules
#   CLAUDE.md                       Claude Code notes
#   agents.md                       reference documentation
#   opencode.json                   OpenCode project config
#   .claude/agents/                 Claude Code subagents
#   .claude/commands/               Claude Code slash commands
#   .opencode/agents/               OpenCode agent definitions
#   .opencode/commands/             OpenCode slash commands
#   .github/copilot-instructions.md Copilot rules
#   .github/prompts/                Copilot prompt files
#   agent-docs/                     shared state files (STATE/PLAN/CHANGELOG)
#
# The installer ALSO appends our exclusions to the target's .gitignore
# (creating it if missing). It never deletes anything.

set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET=""
FORCE=0
DRY_RUN=0

usage() {
  sed -n '2,19p' "$0" | sed 's/^# \{0,1\}//'
  exit 1
}

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)    FORCE=1; shift ;;
    --dry-run)  DRY_RUN=1; shift ;;
    -h|--help)  usage ;;
    -*)         echo "Unknown flag: $1" >&2; usage ;;
    *)
      if [[ -z "$TARGET" ]]; then TARGET="$1"; shift
      else echo "Unexpected argument: $1" >&2; usage
      fi
      ;;
  esac
done

[[ -z "$TARGET" ]] && usage
[[ ! -d "$TARGET" ]] && { echo "Target does not exist: $TARGET" >&2; exit 1; }

TARGET="$(cd "$TARGET" && pwd)"

if [[ "$SOURCE_DIR" == "$TARGET" ]]; then
  echo "Source and target are the same directory. Nothing to do." >&2
  exit 1
fi

echo "Installing agent config"
echo "  from: $SOURCE_DIR"
echo "  into: $TARGET"
echo "  mode: $([[ $FORCE -eq 1 ]] && echo force || echo skip-existing)$([[ $DRY_RUN -eq 1 ]] && echo ' (dry-run)')"
echo

# Files and directories to install. Each entry is a relative path.
ITEMS=(
  "AGENTS.md"
  "CLAUDE.md"
  "agents.md"
  "opencode.json"
  ".claude/agents"
  ".claude/commands"
  ".opencode/agents"
  ".opencode/commands"
  ".github/copilot-instructions.md"
  ".github/prompts"
  "agent-docs"
)

copy_item() {
  local rel="$1"
  local src="$SOURCE_DIR/$rel"
  local dst="$TARGET/$rel"

  if [[ ! -e "$src" ]]; then
    echo "  [skip] $rel (not in source)"
    return
  fi

  # Directory copy
  if [[ -d "$src" ]]; then
    if [[ -d "$dst" && $FORCE -eq 0 ]]; then
      # Directory exists — copy only files that don't exist in target
      local copied=0
      while IFS= read -r -d '' f; do
        local sub="${f#$src/}"
        local target_file="$dst/$sub"
        if [[ -e "$target_file" && $FORCE -eq 0 ]]; then continue; fi
        if [[ $DRY_RUN -eq 1 ]]; then
          echo "  [would] $rel/$sub"
        else
          mkdir -p "$(dirname "$target_file")"
          cp "$f" "$target_file"
          echo "  [copy ] $rel/$sub"
        fi
        copied=$((copied+1))
      done < <(find "$src" -type f -print0)
      [[ $copied -eq 0 ]] && echo "  [skip ] $rel/ (no new files)"
    else
      # Directory doesn't exist or --force: copy recursively
      if [[ $DRY_RUN -eq 1 ]]; then
        echo "  [would] $rel/ (recursive)"
      else
        mkdir -p "$(dirname "$dst")"
        cp -r "$src" "$dst"
        echo "  [copy ] $rel/ (recursive)"
      fi
    fi
    return
  fi

  # File copy
  if [[ -e "$dst" && $FORCE -eq 0 ]]; then
    echo "  [skip ] $rel (exists)"
    return
  fi
  if [[ $DRY_RUN -eq 1 ]]; then
    echo "  [would] $rel"
  else
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    echo "  [copy ] $rel"
  fi
}

for item in "${ITEMS[@]}"; do
  copy_item "$item"
done

# Gitignore: append our block if the marker isn't already present
GITIGNORE="$TARGET/.gitignore"
MARKER="# >>> dam_agent_config >>>"
END_MARKER="# <<< dam_agent_config <<<"
BLOCK=$(cat <<'EOF'
# >>> dam_agent_config >>>
# Installed by dam_agent_config/install.sh
install.log
*.bak
*.orig
# <<< dam_agent_config <<<
EOF
)

if [[ $DRY_RUN -eq 1 ]]; then
  if [[ ! -f "$GITIGNORE" ]] || ! grep -qF "$MARKER" "$GITIGNORE"; then
    echo "  [would] append dam_agent_config block to .gitignore"
  else
    echo "  [skip ] .gitignore (already has dam_agent_config block)"
  fi
else
  if [[ ! -f "$GITIGNORE" ]]; then
    printf '%s\n' "$BLOCK" > "$GITIGNORE"
    echo "  [create] .gitignore"
  elif ! grep -qF "$MARKER" "$GITIGNORE"; then
    printf '\n%s\n' "$BLOCK" >> "$GITIGNORE"
    echo "  [append] .gitignore"
  else
    echo "  [skip ] .gitignore (already has dam_agent_config block)"
  fi
fi

echo
echo "Done. Next steps:"
echo "  1. Review the installed files, especially agent-docs/ for drift."
echo "  2. If the target has its own CLAUDE.md/AGENTS.md, merge manually."
echo "  3. Run /plan <your-requirement> to exercise the workflow."
