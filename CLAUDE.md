# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository manages agent configuration definitions for a Database Activity Monitoring (DAM) and audit logging system. It serves as a centralized configuration store where monitoring and audit agents are documented, defined, and configured.

## Repository Structure

- `agents.md` - Central documentation file defining all agents, their properties, configurations, and statuses
- `workflows/` - Automated workflow definitions compatible with AI coding CLI tools (OpenCode, KiloCode, etc.)
- `templates/` - Reusable templates for Jira tickets, reports, and other artifacts

## Agent Configuration Workflow

When working with agent definitions in this repository:

1. **Agent Properties**: Each agent must be documented with:
   - Name (kebab-case identifier)
   - Description (clear, concise purpose statement)
   - Status (Enabled/Disabled/Maintenance)

2. **Agent Configuration Format**: Agents use YAML configuration blocks with the following structure:
   ```yaml
   agent:
     name: agent-name
     enabled: true/false
     schedule: "cron expression"
     timeout: seconds
   ```

3. **Agent Statuses**:
   - **Enabled** - Agent is active and running on schedule
   - **Disabled** - Agent is defined but not running
   - **Maintenance** - Agent is temporarily paused for updates

## Working with agents.md

The `agents.md` file is the single source of truth for agent definitions. When adding or modifying agents:

- Maintain consistent table formatting for agent properties
- Include complete YAML configuration blocks
- Update the agent status appropriately
- Follow the existing documentation structure (Overview → Agent Definitions → Adding New Agents → Agent Statuses)

## Workflows

Workflow files in `workflows/` are designed for AI coding CLI tools (OpenCode, KiloCode, Claude Code, etc.). They use markdown with `task` code blocks that define discrete automation steps.

### Workflow Structure

```markdown
### Step N: Step Name

Description of what this step accomplishes.

```task
Detailed instructions for the AI agent to execute.
Include specific commands, selectors, or API calls.
```
```

### Required MCP Servers

Workflows may depend on these MCP (Model Context Protocol) servers:
- **Atlassian MCP** - Jira ticket creation and management
- **MongoDB MCP** - Database queries and operations
- **Playwright MCP** - Browser automation for web form interactions

### Template Placeholders

Templates use mustache-style placeholders (`{{VARIABLE_NAME}}`) that should be replaced with actual values at runtime.

## Development Commands

This is a documentation/configuration repository with no build, test, or lint commands. Changes are committed directly to the repository.

## Git Workflow

This repository uses feature branches for changes:
- Branch naming: Uses `claude/` prefix for automated branches
- Main branch: Changes are merged via pull requests
