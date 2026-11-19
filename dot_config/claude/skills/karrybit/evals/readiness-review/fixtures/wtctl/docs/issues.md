# Known Issues

- #3 `wt-list` shows a stale branch. After `git switch other` inside a worktree, `wt-list` still prints the branch the worktree was created on (`wt/<name>`), since it prints the ledger's third column, written once by `wt-new`.
