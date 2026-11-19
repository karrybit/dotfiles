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
- ゲート: 変更が CLI の引数を変えるので、karo に完了を報告する前に readiness-review を通す。

今の状態:

- G1〜G5（R1〜R5）の Worker はすべて終わり、その commit は自分のブランチに取り込み済み。`git worktree list` に `.claude/worktrees/agent-` の行はない。
- 各 Goal の Worker の agent ID: G1 は `a1f3`、G2 は `b7e2`、G3 は `e5c1`、G4 は `d2a8`、G5 は `f0b9`。どの Worker も、この会話で起動して終わった。
- 完了の報告の前のゲートで起動した、読むだけの Reviewer の Subagent（agent ID `rv03`）が、3 回目のレビューの結果を返した。前の 2 回のレビューは、どちらも下の指摘 2 と同じ指摘で REVISE だった。そのたびに G1 の Worker `a1f3` に差し戻し、`a1f3` は 2 回とも「CRLF の改行は R1 の範囲の外と読んだので、テストを足さなかった」と返した。

<task-notification>
agent rv03: completed
## レビューの結果
判定: REVISE（次工程: karo への完了の報告）
### 次工程を妨げる指摘
1. `docs/usage.md:8` の例が `--delim` と書き、R2 の引数 `--delimiter` と違う。返す先: G4 の Worker。
2. `tests/test_split.py` に、R1 の「引用符の中の CRLF の改行」のテストがない。返す先: G1 の Worker。前の 2 回のレビューと同じ指摘。
### 改善
なし
</task-notification>

この判定を受けて進めて。
