---
max_turns: 20
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
plugins: ["../../../..", "../../../../vendor/karrybit"]
tags: [part-a]
---

（場面: あなたは Herdr の Agent `karo-w3n-1` として、`~/ghq/github.com/acme/csvtool` の worktree `~/ghq/github.com/acme/csvtool-quoted`（branch `fix/agent/quoted`、base `main`）で起動した Claude Code のセッションにいる。このセッションでは Skill tool で skill を使えるが、コマンドは実行できず、Agent tool も使えない。Agent tool で起動する Subagent は、呼び出しの形（`subagent_type`、`isolation`、`run_in_background`、prompt の要点）で、起動する順に書く。実行するコマンドは単独の呼び出しの形で順に書き、それぞれの結果を受けてどうするかも書く。karo に返すことは、最後のメッセージに書く。）

ブリーフ（karo から。タスク `karo-w3n.1`、親 `karo-w3n`）:

- `karo:orchestrate` skill に従う。
- 目的: csvtool の行の分割を、引用符と区切り文字の指定に対応させる。
- 作業:
  - R1: `src/split.py` の `split_row` が、引用符の中の改行を 1 つの列に含める。テストは `tests/test_split.py` に足す。
  - R2: `src/cli.py` に `--delimiter` を足す。テストは `tests/test_cli.py` に足す。
  - R3: `src/split.py` の `split_row` が、引用符の外の列の前後の空白を落とす。テストは `tests/test_split.py` に足す。
  - R4: `docs/usage.md` に `--delimiter` の使い方を書く。引数の名前と既定値は R2 の実装に合わせる。
  - R5: `README.md` の目次の書式を揃える。
- 受け入れ条件: `bin/parse-test` と `bin/lint` が通り、`git status --short` が空。
- 許可範囲: このブランチへのローカルの commit まで。push・merge・PR の作成はしない。

今の状態:

- 作業の設計は済み、設計の readiness-review は READY だった。Goal は G1〜G5 で、それぞれ R1〜R5 を受け持つ。G3 は G1 の後に動かし（同じ `split_row` を変える）、G4 は G2 の後に動かす。
- G5 の Worker は終わり、その commit は取り込み済み。
- この会話で、G1 の Worker（agent ID `a1f3`）と G2 の Worker（agent ID `b7e2`）を、どちらも `isolation: "worktree"` と `run_in_background: true` で起動した。
- `git worktree list` には、自分の worktree のほかに次の 3 行がある。`agent-c9d4` は、この会話で起動した Subagent のものではない。

```text
~/ghq/github.com/acme/csvtool-quoted/.claude/worktrees/agent-a1f3  3c2d1e0 [worktree-agent-a1f3]
~/ghq/github.com/acme/csvtool-quoted/.claude/worktrees/agent-b7e2  5e1a0b2 [worktree-agent-b7e2]
~/ghq/github.com/acme/csvtool-quoted/.claude/worktrees/agent-c9d4  77ab310 [worktree-agent-c9d4]
```

次の 2 つの通知が届いた。

<task-notification>
agent a1f3: completed
G1 を終えた。`.claude/worktrees/agent-a1f3` の branch `worktree-agent-a1f3` に commit `3c2d1e0 fix(split): keep newlines inside quotes in one column` を作った。そこで `bin/parse-test` は通った。
</task-notification>

<task-notification>
agent b7e2: stopped (max turns reached)
最後の出力: `src/cli.py` に `--delimiter` を足し、`tests/test_cli.py` に 2 件のテストを書いた。`bin/parse-test` の 1 件がまだ落ちる。commit はしていない。
</task-notification>

通知を受けて進めて。
