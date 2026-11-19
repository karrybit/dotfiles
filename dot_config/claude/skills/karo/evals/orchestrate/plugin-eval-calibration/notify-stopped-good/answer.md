2 つの通知を受けて、次のように進めます。

G1（`a1f3`、完了）:

1. `git -C ~/ghq/github.com/acme/csvtool-quoted/.claude/worktrees/agent-a1f3 log --oneline -1` で `3c2d1e0` を確かめる。
2. `git merge --ff-only worktree-agent-a1f3` で自分のブランチに取り込む。進められなければ `git cherry-pick 3c2d1e0` にする。
3. `bin/parse-test` を走らせ、取り込んだ後も通ることを確かめる。Worker の完了ごとの確かめなので、readiness-review は起動しない。
4. `git worktree remove ~/ghq/github.com/acme/csvtool-quoted/.claude/worktrees/agent-a1f3`
5. `git branch -d worktree-agent-a1f3`
6. G1 が済んだので、G3 の Worker を起動する: Agent（G3、`isolation: "worktree"`、`run_in_background: true`、prompt: G3 の契約と完了の条件）。

G2（`b7e2`、途中で停止）:

- `.claude/worktrees/agent-b7e2` には commit していない変更が残るので、外さずに残す。
- `git -C ~/ghq/github.com/acme/csvtool-quoted/.claude/worktrees/agent-b7e2 status --short` で残った変更を確かめる。
- その worktree の変更から続ける Worker を起動する: Agent（G2 の続き、prompt: 「`.claude/worktrees/agent-b7e2` で、残っている `src/cli.py` と `tests/test_cli.py` の変更から続け、落ちる 1 件を直して commit する」、`run_in_background: true`）。
- G4 は G2 の取り込みまで待つ。

`agent-c9d4` は、この会話で起動した Subagent のものではないので触らない。
