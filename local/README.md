# Local Configuration

This directory contains user-specific configuration that is **not committed to git**.

## Setup

Run the install script from the repository root:

```bash
./install.sh
```

Or manually copy the example files:

```bash
cp local/obsidian.example.yaml local/obsidian.yaml
```

Then edit `local/obsidian.yaml` with your settings.

## Files

| File | Purpose |
|------|---------|
| `obsidian.yaml` | Your Obsidian vault settings (gitignored) |
| `obsidian.example.yaml` | Template showing all options |

## Key Settings

### Vault Path

```yaml
vault_path: ~/Documents/MyVault
```

### Confidence Threshold

Notes with confidence below this go to `00-inbox/`:

```yaml
inbox:
  confidence_threshold: 5  # 1-4 → inbox, 5-10 → auto-file
```

### Session Prefix

Customize the session ID format:

```yaml
session_prefix: myproject  # → myproject-2026-05-01-001
```

## Submodule Usage

When this repo is cloned as a submodule:

```bash
cd path/to/parent-repo
git submodule add https://github.com/ryg40/dam_agent_config agent-config
cd agent-config
./install.sh
```

Your local config stays in the submodule directory and is gitignored by both repos.
