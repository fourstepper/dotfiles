# OpenCode Agent Instructions

## Configuration File Locations

OpenCode configuration files are stored in the following locations:

- **Global config directory**: `~/.config/opencode/`
- **Global AGENTS.md**: `~/.config/opencode/AGENTS.md` - Instructions that apply to all OpenCode sessions
- **Project-specific config**: `.opencode/` directory in the project root
- **Project-specific AGENTS.md**: `.opencode/AGENTS.md` - Instructions specific to a single project

The AGENTS.md file contains custom instructions that are automatically loaded and applied to the agent. Global instructions apply to all sessions, while project-specific instructions only apply when working within that project.

## Repository Locations

- **Work repositories**: `~/workspace/work/` - Most commonly used, contains work-related projects
- **Personal repositories**: `~/workspace/personal/` - Contains personal projects

### Frequently Used Repositories

| Repository | Path | Description |
|------------|------|-------------|
| agents | `~/workspace/work/agents` | Slackbot framework and agent infrastructure |
| kevin | `~/workspace/work/kevin` | Kevin - Cybersecurity Agent |

## CRITICAL: Git Commit Safety

**NEVER commit any changes to git that look like secrets.**

This includes but is not limited to:
- API keys
- Access tokens
- Passwords
- Private keys
- Connection strings with credentials
- Environment files containing sensitive values (`.env`, `.env.local`, etc.)
- OAuth secrets
- Webhook secrets
- Database credentials
- Any string that appears to be a secret or credential

Before committing, always review staged changes for accidental secret exposure. If in doubt, ask the user to confirm the commit is safe.

## GitLab Merge Requests

When creating merge requests on behalf of the user:

- **Always assign to me**: When creating a merge request, always assign it to Robin Opletal (user ID: 2368, username: robin.opletal)

## Linear Issue Management

When updating issues in Linear via the Linear MCP:

- **Prefer comments over direct edits**: For updates on issues, primarily use comments rather than modifying the issue fields directly
