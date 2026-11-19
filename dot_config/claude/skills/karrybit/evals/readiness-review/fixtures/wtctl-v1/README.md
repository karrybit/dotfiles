# wtctl

Small commands that let automated workers get their own git worktree and give it back.

| Command | Does |
| --- | --- |
| `bin/wt-new <name>` | Creates `.worktrees/<name>` on branch `wt/<name>` and records it in `state/ledger.tsv` |
| `bin/wt-close <name>` | Removes the worktree when the ledger records that `wt-new` created it |
| `bin/wt-list` | Prints the name and current branch of each worktree `wt-new` created, or `-` when the branch cannot be read |

The ledger is a TSV file with one row per worktree: name and path. Rows that older versions wrote with a third column, the branch, are still read. `bin/wt-lib` holds its location.

Run the checks with `tests/run`; it prints `0 failure(s)` and exits 0 when every check passes.
