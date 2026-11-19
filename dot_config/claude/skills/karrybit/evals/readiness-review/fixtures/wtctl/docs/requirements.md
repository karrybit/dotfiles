# Requirements

- R1: `wt-close` removes only worktrees that `wt-new` created. A worktree a person created with `git worktree add` stays, even when its name or its place under `.worktrees/` is the same. People keep unpushed work in such worktrees.
- R2: `wt-list` prints, for each worktree `wt-new` created, its name and the branch it is on now.
- R3: Existing ledgers keep working after an upgrade of wtctl.
