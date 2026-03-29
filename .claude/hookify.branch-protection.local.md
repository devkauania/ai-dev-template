---
name: no-branches-warning
enabled: true
event: bash
action: warn
pattern: git\s+(checkout\s+-b|branch\s+\w|switch\s+-c|worktree)
---

**Branch/Worktree Not Allowed**

Per CLAUDE.md rule #3: This project works **directly on master**. No branches or worktrees.

**Why**: Single-stream development avoids merge conflicts, stale branches, and cleanup overhead. All changes go directly to master.

**What to do instead**: Make your changes on the current branch (master) and commit when the user asks.
