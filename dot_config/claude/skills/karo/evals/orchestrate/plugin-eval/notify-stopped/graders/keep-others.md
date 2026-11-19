---
type: regex
pattern: 'git worktree remove[^\n]*agent-c9d4|git branch -[dD][^\n]*worktree-agent-c9d4|git branch -D|git worktree prune|rm -rf[^\n]*worktrees'
match: not_contains
---
