---
name: record
description: '$KARO_HOME の記録のファイルを Edit・Write で書き、karo の commit の script で commit する手順と、NG の直し方。記録のファイルを書くとき、委任・取り込み・終了を記録するとき、commit が NG を出したときに使う。'
user-invocable: false
---

# 記録を書いて commit する

- 記録のファイルは、`$KARO_HOME/AGENTS.md` の「書き込み先」の表の記録のファイル。タスク・判断待ち・決定は記録のファイルに書かず、`bd` で書く（`karo:beads` skill）。
- 下の `<scripts>` は `~/.config/claude/skills/karo/scripts` で、この `~/` の形のまま書く。

## 書く

- 新しいファイルは Write で、今あるファイルへの追記と直しは Edit で、`$KARO_HOME` の下の絶対パスに書く（`$KARO_HOME` の値は SessionStart の hook が出す）。
- Edit・Write のあと、post-edit の hook が `.md` を rumdl で整え、記録のノートなら fmcheck でフロントマターを確かめる。hook が問題を返したら、そのファイルを直してから commit する。
- standup（`standup/YYYY-MM-DD.md`）がまだなければ、Write で `type: Standup` と `date` のフロントマターから作る（`karo:frontmatter` skill の種類の表の `Standup` の行）。
- `state.md` は git の外の `$KARO_STATE_HOME/state.md` にあり（`$KARO_STATE_HOME` の値は SessionStart の hook が出す）、Edit で書き、commit のパスに並べない。
- 運用の出来事（タスクを持たない依頼で記録を変えたこと）は、commit の本文に書く。
- 長い本文（サブエージェントの調査の結果、imozuru の原文）は、そのサブエージェントや imozuru に `$KARO_HOME` の書き先へ直接書かせ、終わったらそのパスを commit に渡す。

## commit する

1. 1 つの返事に要る書き込みをすべて書いたら、それを 1 つの commit にする。`<scripts>/commit '<件名>' '<本文>' <パス>...` を単独の Bash の呼び出しで（パイプ・リダイレクト・`&&` をつながずに）実行する。
   - 件名は `<タスクID>[, <タスクID>]...: <何を変えたか>` の形にし、そのやり取りのタスク ID で始める。タスクのないやり取りでは、ID を置かずに何を変えたかだけを書く。
   - 本文には、なぜ変えたか（オーナーのどの指示か、どの決定・出典に基づくか）を書く。件名と本文は、それぞれ改行を含まない 1 行にし、`'` で囲む（本文に `'` を入れない）。
   - パスは `$KARO_HOME` からの相対パスで、この commit に入れるファイルをすべて並べる（消したファイルも並べる）。commit は並べたパスだけを stage する。

   <example>

   ```sh
   ~/.config/claude/skills/karo/scripts/commit 'karo-k3m: record the survey of fb list sorting' 'Keep the survey of sorting the fb list by update date, as the owner asked.' investigation/2026-01-01-fb-sort.md
   ```

   </example>

   完了条件: 最後の行が `OK <commit> <件名>`（commit した）か `OK - <件名> (no change)`（変わったところがない）。`NG <件名>` なら「NG を直す」に進む。

- 続く手順がその commit を使うとき（`karrybit:explore`）は、`OK` の行の `<commit>` を渡す。

## NG を直す

- NG のとき、commit は何も commit せず、並べたパスの stage を外し、ファイルは書いたままに残す。NG の理由は `NG` の行の前に出る。ファイルを Edit で直し、同じ commit を実行し直す。
- `not a record path: <パス>`: パスが「書き込み先」の表の記録のファイルではない。書き先を表のファイルに直す。
- ファイルのパスとフロントマターの問題（fmcheck の出力）: フロントマターを `karo:frontmatter` skill の種類の表に合わせて直す。
- `git diff --check` の出力（行末の空白、末尾の空行など）: 出た行を直す。
- `usage:` の行: 引数が足りないか、本文が空。件名・本文・パスをそろえて実行し直す。
- オーナーの判断が要って直せない NG は、理由の行をオーナーに伝える。書いたファイルは commit されないまま残る。
