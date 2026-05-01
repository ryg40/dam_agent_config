#!/bin/bash
# Source this script to load Obsidian configuration
# Usage: source scripts/obsidian-config.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")/local"
CONFIG_FILE="$CONFIG_DIR/obsidian.yaml"
DEFAULT_CONFIG="$CONFIG_DIR/obsidian.example.yaml"

# Check if yq is available for YAML parsing
if command -v yq &> /dev/null; then
    HAS_YQ=true
else
    HAS_YQ=false
fi

# Read config value with fallback
# Usage: get_config "key.path" "default_value"
get_config() {
    local key="$1"
    local default="${2:-}"

    if [ ! -f "$CONFIG_FILE" ]; then
        echo "$default"
        return
    fi

    if [ "$HAS_YQ" = true ]; then
        local value
        value=$(yq -r ".$key // empty" "$CONFIG_FILE" 2>/dev/null)
        if [ -n "$value" ] && [ "$value" != "null" ]; then
            echo "$value"
        else
            echo "$default"
        fi
    else
        # Fallback: grep-based parsing for simple keys
        local value
        value=$(grep -E "^${key}:" "$CONFIG_FILE" 2>/dev/null | head -1 | cut -d':' -f2- | xargs)
        if [ -n "$value" ]; then
            echo "$value"
        else
            echo "$default"
        fi
    fi
}

# Load common config values
load_obsidian_config() {
    OBSIDIAN_VAULT=$(get_config "vault_path" "$HOME/.obsidian/Obsidian Vault")
    OBSIDIAN_VAULT="${OBSIDIAN_VAULT/#\~/$HOME}"

    SESSION_PREFIX=$(get_config "session_prefix" "opc")
    DEFAULT_CONFIDENCE=$(get_config "default_confidence" "7")
    DEFAULT_PRIORITY=$(get_config "default_priority" "5")
    CONFIDENCE_THRESHOLD=$(get_config "inbox.confidence_threshold" "5")
    GIT_AUTO_COMMIT=$(get_config "git.auto_commit" "true")
    GIT_COMMIT_PREFIX=$(get_config "git.commit_prefix" "vault:")

    export OBSIDIAN_VAULT SESSION_PREFIX DEFAULT_CONFIDENCE DEFAULT_PRIORITY
    export CONFIDENCE_THRESHOLD GIT_AUTO_COMMIT GIT_COMMIT_PREFIX
}

# Check if config exists
config_exists() {
    [ -f "$CONFIG_FILE" ]
}

# Warn if config doesn't exist
check_config() {
    if ! config_exists; then
        echo "Warning: local/obsidian.yaml not found. Run ./install.sh to configure." >&2
        echo "Using defaults." >&2
    fi
}

# Auto-load config when sourced
load_obsidian_config
