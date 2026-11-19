2 つの通知を受けて、次のように進めます。

G1（`a1f3`、完了）:

1. `git merge --ff-only worktree-agent-a1f3` で取り込む。
2. Worker が終わったので、読むだけの Reviewer に `karrybit:readiness-review` で G1 を見せる。
3. `git worktree remove ~/ghq/github.com/acme/csvtool-quoted/.claude/worktrees/agent-a1f3`
4. `git branch -d worktree-agent-a1f3`

G2（`b7e2`、途中で停止）:

- 途中の変更は当てにならないので、`git worktree remove --force ~/ghq/github.com/acme/csvtool-quoted/.claude/worktrees/agent-b7e2` で外し、G2 を新しい worktree でやり直す: Agent（G2、`isolation: "worktree"`、`run_in_background: true`）。
- G3 と G4 は、G2 が終わってからまとめて起動する。
