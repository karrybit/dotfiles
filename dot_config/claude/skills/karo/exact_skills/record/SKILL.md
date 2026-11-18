---
name: record
description: '$KARO_HOME の記録のファイルを Edit・Write で書き、karo の commit の script で commit する手順と、ノートのフロントマターの書き方（type、項目の埋め方、置き場所、状態が変わったときに直すフィールド）と、NG の直し方と、調べ物を karrybit:researcher のサブエージェントに頼むときに依頼に書く karo の規則。記録のファイルを書くとき、ノートのフロントマターを書くか直すとき、委任・取り込み・終了を記録するとき、commit か karo-check が問題を出したとき、調べ物や MTG の記録づくりを頼むときに使う。'
user-invocable: false
---

# 記録を書いて commit する

- 記録のファイルは、`$KARO_HOME/AGENTS.md` の「書き込み先」の表の記録のファイル。タスク・判断待ち・決定は記録のファイルに書かず、`bd` で書く（`karo:tasks` skill）。過去の会話も書き写さず、要るときは cass で引く（`karo:recall` skill）。
- 下の `<scripts>` は `~/.config/claude/skills/karo/scripts` で、この `~/` の形のまま書く。
- ノートを作る前と、ノートのフロントマターを書くか直す前に、この skill のフォルダの `frontmatter.md` を読む。フィールドの書き方、種類ごとの置き場所と埋め方、状態が変わったときに直すフィールドがある。

## 書く

- 新しいファイルは Write で、今あるファイルへの追記と直しは Edit で、`$KARO_HOME` の下の絶対パスに書く（`$KARO_HOME` の値は SessionStart の hook が出す）。
- Edit・Write のあと、post-edit の hook が `.md` を rumdl で整え、`<scripts>/karo-check --only <そのファイル>` で確かめる。hook が問題を返したら、そのファイルを直してから commit する。hook が返すのは書いたファイルの問題か検査そのものの失敗だけで、そのファイルを指すほかのノートの問題は commit が止める。
- standup（`standup/YYYY-MM-DD.md`）がまだなければ、Write で `type: Standup` と `date` のフロントマターから作る（`frontmatter.md` の「種類」の `Standup` の行）。
- `state.md` は git の外の `$KARO_STATE_HOME/state.md` にあり（`$KARO_STATE_HOME` の値は SessionStart の hook が出す）、Edit で書き、commit のパスに並べない。
- 運用の出来事（タスクを持たない依頼で記録を変えたこと）は、commit の本文に書く。
- 長い本文（サブエージェントの調査の結果、imozuru の原文）は、そのサブエージェントや imozuru に `$KARO_HOME` の書き先へ直接書かせ、終わったらそのパスを commit に渡す。

## 調べ物を頼む

- 調べ物と MTG の記録づくりは、Agent tool で `karrybit:researcher` のサブエージェントに頼む（Herdr の Agent にはしない）。依頼には、目的と答える問い、確かめ済みの事実、読む場所に加えて、下の表の 6 つを書く。`$KARO_HOME` は値に置き換えて書く。

| 項目 | 書くこと |
| --- | --- |
| ノートの書き先 | 調べた結果は `$KARO_HOME/investigation/YYYY-MM-DD-<話題>.md`、MTG の記録は MTG ごとに `$KARO_HOME/source/meeting/YYYY-MM-DD-<MTG>.md` |
| 情報源のアクセスの制約 | `$KARO_HOME/AGENTS.md` の「情報源」の節（外のサービスは読むだけ、MTG の議事録を読む範囲）に従うこと |
| ノートの規則 | 書く前に `frontmatter.md`（この skill のフォルダ。依頼には絶対パスで書く）を Read で読み、その「フィールド」と、書き先の種類の行（調べ物は `Investigation`、MTG は `Meeting Notes`、imozuru の map.md は `Research Map`）に従うこと |
| 検査 | `~/.config/claude/skills/karo/scripts/karo-check --only <ノートの $KARO_HOME からのパス>` を `~/` の形のまま単独で実行する（imozuru を使ったら `--only investigation/YYYY-MM-DD-<話題>/map.md` も足す）。合格は、終了コードが 2 でなく、出力に `<ノートのパス><TAB>` で始まる行が `stale since` の行のほかにないこと。ほかのノートの行は数えないので、件数の行（`karo-check: <件数> problem(s) in the --only scope`）が 0 でなくてもよい。終了コード 2 は検査そのものの失敗（引数か schema の誤り、yq・fd・rg を動かせない） |
| 追加の skill | 分野や論点を探る調査には `imozuru:imozuru` を使ってよく、原文の保存先はノートと同じ名前のフォルダ `$KARO_HOME/investigation/YYYY-MM-DD-<話題>/` |
| 分担 | ノートの commit は karo が commit の script で行い、判断待ち（decision の bead）は karo が `bd` で作る。サブエージェントは commit も `bd` もしない |

- 報告を受けたら、`$KARO_HOME/AGENTS.md` の「委任・レビュー・Checkin・Checkout」の表の調べ物の行で受け入れを決め、報告の「commit に入れるファイル」を下の「commit する」で 1 つの commit にする。

## commit する

1. 1 つの返事に要る書き込みをすべて書いたら、それを 1 つの commit にする。`<scripts>/commit '<件名>' '<本文>' <パス>...` を単独の Bash の呼び出しで（パイプ・リダイレクト・`&&` をつながずに）実行する。
   - 件名は `<タスクID>[, <タスクID>]...: <何を変えたか>` の形にし、そのやり取りのタスク ID で始める。タスクのないやり取りでは、ID を置かずに何を変えたかだけを書く。
   - 本文には、なぜ変えたか（オーナーのどの指示か、どの決定・出典に基づくか）を書く。件名と本文は、それぞれ改行を含まない 1 行にし、`'` で囲む（本文に `'` を入れない）。
   - パスは `$KARO_HOME` からの相対パスで、この commit に入れるファイルをすべて並べる（消したファイルも、名前を変えたファイルは前と後の両方も並べる）。commit は並べたパスだけを stage し、commit に入る中身（HEAD に並べたパスの今の中身を足したもの）を `<scripts>/karo-check --only` で、そのパスと、そのパスを指すほかのノートについて確かめる。並べていないファイルの直しは中身に入らないので、ほかのノートを直したらそのノートも並べる。記録の全体は確かめないので、全体は `karo:land`・`karo:checkout` の引数なしの karo-check が確かめる。

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
- `<パス><TAB><問題>` の行（karo-check の出力）: フロントマターと置き場所を `frontmatter.md` に合わせて直す。並べたパスでなく、それを指すほかのノートの行（`link target missing`、`derived_from missing`、`unknown project`）なら、そのノートのリンクか値を直し、そのノートも commit のパスに並べる。
- `karo-check:` で始まり件数のない行と終了コード 2（`no schema`、`cannot run <道具>`）: 検査そのものが動いていない。ノートを直さず、その行をオーナーに伝える。
- `git diff --check` の出力（行末の空白、末尾の空行など）: 出た行を直す。
- `usage:` の行: 引数が足りないか、本文が空。件名・本文・パスをそろえて実行し直す。
- オーナーの判断が要って直せない NG は、理由の行をオーナーに伝える。書いたファイルは commit されないまま残る。
