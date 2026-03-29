---
name: block-destructive-commands
enabled: true
event: bash
action: block
pattern: rm\s+-rf\s+[/~]|git\s+push\s+--force|git\s+push\s+-f\s|git\s+reset\s+--hard|DROP\s+(TABLE|DATABASE)
---

**Destructive Command Blocked**

This command is irreversible and has been blocked for safety.

- `rm -rf /...` or `rm -rf ~/...`: Target a specific subdirectory instead (e.g., `rm -rf dist/`)
- `git push --force`: Use `git push` without --force. Force pushing destroys remote history.
- `git reset --hard`: Use `git stash` to preserve changes, or `git checkout -- <file>` for specific files.
- `DROP TABLE/DATABASE`: Use migrations to manage schema changes safely.
