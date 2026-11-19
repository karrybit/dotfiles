# wtctl

Small commands that let automated workers get their own git worktree and give it back.

| Command | Does |
| --- | --- |
| `bin/wt-new <name>` | Creates `.worktrees/<name>` on branch `wt/<name>` and records it in `state/ledger.tsv` |
| `bin/wt-close <name>` | Removes the worktree when the ledger records that `wt-new` created it |
| `bin/wt-list` | Prints the name and branch of each worktree `wt-new` created |

The ledger is a TSV file with one row per worktree: name, path, branch. `bin/wt-lib` holds its location.

Run the checks with `tests/run`; it prints `0 failure(s)` and exits 0 when every check passes.
