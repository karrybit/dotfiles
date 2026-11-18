---
max_turns: 40
timeout_seconds: 1200
allowed_tools: [Read, Glob, Grep, Skill, Agent, Bash, Write, Edit]
tags: [researcher]
---

このリポジトリは記録のリポジトリ。2026-11-17 の定例の議事録から、MTG の記録を作ってほしい。

この仕事は karrybit:researcher の Agent に頼み、下の依頼を渡して、返ってきた報告を手を加えずにそのまま最後の返事にして。その Agent を使えなければ、自分で依頼どおりに行って同じように報告して。

<request>
- 目的と問い: 2026-11-17 の定例で決まったことと宿題を、MTG の記録にする。
- 読む場所: このリポジトリの `minutes/2026-11-17-weekly-sync.txt`
- ノートの書き先: このリポジトリの `source/meeting/2026-11-17-weekly-sync.md`（絶対パスにして渡す）
- 情報源のアクセスの制約: このリポジトリの `rule/sources.md` に従う。
- ノートの規則: このリポジトリの `rule/note-rules.md` に従う。
- 検査: このリポジトリで `bin/check-note source/meeting/2026-11-17-weekly-sync.md` を単独で実行する。合格の出力は `check-note: 0 problem(s)`。`stale since` の行は数えない。終了コード 2 は検査そのものの失敗。
- 追加の skill: 分野や論点を探る調査には `imozuru:imozuru` を使ってよい。原文の保存先は `investigation/2026-11-18-<話題>/`。
- 分担: ノートの commit と、タスクと判断待ちの記録は依頼した側が行う。Agent は commit も `bd` もしない。
</request>
