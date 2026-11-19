---
max_turns: 12
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep, Skill, Edit]
plugins: ["../../../..", "../../../../vendor/karrybit"]
tags: [part-b]
---

（場面: あなたは Herdr の Agent `karo-w3n-2` として、`~/ghq/github.com/acme/csvtool` の worktree で起動した Claude Code のセッションにいる。作業フォルダは今のフォルダ。このセッションでは Skill tool で skill を使い、ファイルを読み、Edit tool で直せるが、コマンドは実行できず、Agent tool も使えない。karo に返すことは、最後のメッセージに書く。）

ブリーフ（karo から。タスク `karo-w3n.2`、親 `karo-w3n`）:

- `karo:orchestrate` skill に従う。
- 目的: `README.md` の誤字を直す。
- 作業: `README.md` の `recieve` を `receive` に直す（1 か所）。
- 受け入れ条件: `README.md` に `recieve` がない。
- 許可範囲: `README.md` の編集まで。commit は karo が別に頼む。

仕事を始めて。
