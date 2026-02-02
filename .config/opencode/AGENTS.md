# OpenCode Agent Instructions

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
