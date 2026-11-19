---
name: record
description: '$KARO_HOME の記録のファイルを Edit・Write で書き、karo の commit の script で commit する手順と、ノートのフロントマターの書き方（type、項目の埋め方、置き場所、状態が変わったときに直すフィールド）と、karo の長い目の決定の Decision Record の書き方と置き換え方と、karo の今の状態の state.md の形と書き直す時機と、NG の直し方と、調べ物を karrybit:researcher のサブエージェントに頼むときに依頼に書く karo の規則。記録のファイルを書くとき、ノートのフロントマターを書くか直すとき、オーナーが karo の運用・設計の方針を決めたか変えたとき、委任・取り込み・終了を記録するとき、state.md を書き直すとき、commit か karo-check が問題を出したとき、調べ物や MTG の記録づくりを頼むときに使う。'
user-invocable: false
---

# 記録を書いて commit する

- 記録のファイルは、`$KARO_HOME/AGENTS.md` の「書き込み先」の表の記録のファイル。タスク・判断待ち・タスクかプロジェクトに閉じた決定は記録のファイルに書かず、`bd` で書く（`karo:tasks` skill）。karo 自身の長い目の運用・設計の決定は、下の「Decision Record を書く」で `$KARO_HOME/decisions/` に書く。過去の会話も書き写さず、要るときは cass で引く（`karo:recall` skill）。
- 下の `<scripts>` は `~/.config/claude/skills/karo/scripts` で、この `~/` の形のまま書く。
- ノートを作る前と、ノートのフロントマターを書くか直す前に、この skill のフォルダの `frontmatter.md` を読む。フィールドの書き方、種類ごとの置き場所と埋め方、状態が変わったときに直すフィールドがある。

## 書く

- 新しいファイルは Write で、今あるファイルへの追記と直しは Edit で、`$KARO_HOME` の下の絶対パスに書く（`$KARO_HOME` の値は SessionStart の hook が出す）。
- Edit・Write のあと、post-edit の hook が `.md` を rumdl で整え、`<scripts>/karo-check --only <そのファイル>` で確かめる。hook が問題を返したら、そのファイルを直してから commit する。hook が返すのは書いたファイルの問題か検査そのものの失敗だけで、そのファイルを指すほかのノートの問題は commit が止める。
- standup（`standup/YYYY-MM-DD.md`）がまだなければ、Write で `type: Standup` と `date` のフロントマターから作る（`frontmatter.md` の「種類」の `Standup` の行）。
- `state.md` は、下の「state.md を書く」に従って書く。
- 運用の出来事（タスクを持たない依頼で記録を変えたこと）は、commit の本文に書く。
- 長い本文（サブエージェントの調査の結果、imozuru の原文）は、そのサブエージェントや imozuru に `$KARO_HOME` の書き先へ直接書かせ、終わったらそのパスを commit に渡す。

## Decision Record を書く

- Decision Record は、karo 自身の将来の振る舞い・運用・設計に続けて効く決定の、背景と理由を持つ。基準は「将来の karo がこの理由を知らないと、誤った行動を取るか同じ議論を繰り返すか」で、当たらない決定とタスクに閉じた決定は `karo:tasks` skill の「判断待ちと決定」で Beads に書く。個別のシステムの決定（ADR）は書かない。
- 書くのは、オーナーが決めたと会話か記録にある決定だけにする。会話の中の提案と、cass で引いた過去の発言は、オーナーが今決めたと確かめるまで書かない。
- 新しい記録は `$KARO_HOME/decisions/YYYY-MM-DD-<話題>.md`（日付は決めた日）に Write で書き、フロントマターは `frontmatter.md` の「種類」の `Decision Record` の行に従う。本文は次の節をこの順に置く。

| 節 | 書くこと |
| --- | --- |
| `## 状態` | `Accepted（オーナーの承認、会話 YYYY-MM-DD HH:MM）`。置き換えたら `Superseded（[<新しい記録の話題>](decisions/<新しい記録>.md)）` |
| `## 背景` | 判断が要った背景 |
| `## 決定` | 採った方針 |
| `## 理由` | 採った理由と、検討して採らなかった選択肢 |
| `## 影響` | 期待する効果、制約、トレードオフ |
| `## 参照` | 関わるタスクの ID、記録へのパスのリンク、cass の出典（`karo:recall` skill の「出典」の形） |

- 決定を変えるときは、新しい記録を書き、フロントマターの `supersedes` に古い記録のパスを書く。古い記録は消さずに、`frontmatter.md` の「追記したとき・状態が変わったとき」の表の「決定を新しい決定で置き換えた」の行のとおり直し、2 つを同じ commit に入れる。誤字と事実の誤りの訂正は、古い記録を Edit で直すだけにする。
- 判断待ちの decision の bead から決まった決定は、記録を書いてから、bead を `bd close <決定> --reason '決定: decisions/<記録>.md' --json` で閉じる。決定の全文は記録にだけ置き、bead には書き写さない。
- Decision Record は理由を持ち、karo が今従う規則は持たない。規則は `$KARO_HOME/AGENTS.md`・`$KARO_HOME/rule/`・skill に書き、規則の行から記録のパスを指す。

## state.md を書く

- `$KARO_STATE_HOME/state.md` は karo の今の状態（Working Memory）で、karo だけが書く。委任した Agent とサブエージェントには、state.md を書かせない。
- state.md は git の外にあるので、Edit・Write で書き、commit のパスに並べない（`$KARO_STATE_HOME` の値は SessionStart の hook が出す）。
- karo の `scripts/state-context` の hook が、SessionStart（startup・resume・compact）で state.md の全文と最終更新の時刻を出し、PreCompact で compact の要約に、state.md の中身を写さず最終更新より後の変化を残すよう指示する。
- 1 行目を `# state`、次に `更新: YYYY-MM-DD HH:MM` を置き、下の 5 つの節をこの順に置いて、今も効く状態だけを書く。

| 節 | 書くこと |
| --- | --- |
| `## 焦点` | 今の目標と注力すること |
| `## 進めている作業` | 取り組んでいる仕事ごとに 1 行。行の先頭にタスク ID を書き、状況と次の行動を続ける |
| `## 制約` | 今効いている重要な制約。規則の本文は写さず、規則のファイルか Decision Record のパスを書く |
| `## 未解決` | 解くべき問題と、オーナーに確かめること |
| `## 参照` | 要るときに読む Beads の ID、Decision Record のパス（`decisions/YYYY-MM-DD-<話題>.md`）、資料のパス |

- Beads のタスクの状態や Herdr の Agent の状態のように、正本で変わる状態を書いた項目は、末尾に `（YYYY-MM-DD HH:MM 時点）` を付ける。hook はこの印があると、その項目を正本で確かめるよう求める文を出す。
- 確定していない項目は、先頭に `検討中:` か `未確認:` を書き、確定した事項と分ける。
- 詳細は正本（Beads、`decisions/`、資料）に置き、state.md にはその ID かパスと、復帰したあとに次の行動を決められるだけの 1 行を書く。会話の要約と作業の履歴は、Beads の comment と commit の本文にある。
- 終わった作業と効かなくなった状態は、その場で消す。
- state.md は 8,000 字までにする。hook の出力の上限が 10,000 字で、超えると hook は全文を出さずにパスだけを出す。超えそうになったら、文を機械的に縮めずに、古い項目を消すか正本への参照に置き換える。

### 書き直す時機

- 次のどれかが起きたら、その返事の中で state.md を直し、`更新:` の時刻を書き換える。会話のたびには直さない。
  - 今の目標が変わった。
  - 重要な制約か決定が加わった。
  - 作業を委任・中断・再開した。
  - 作業を取り込んだ（その行を「進めている作業」から消す）。
  - 重要なブロッカーが生じたか、解けた。
  - 作業の次の行動が変わった。

### 読んだあと

- SessionStart の hook が出した state.md の `（… 時点）` の項目と「進めている作業」のタスクは、次の行動に使う前に、タスクは `bd show <ID> --json`、Agent は `herdr agent get <名前>` で確かめる。
- 正本と食い違ったら、正本を正として state.md を直す。
- hook が state.md がないと知らせたら、Beads の一覧と `herdr agent list` から、この節の形で作る。

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
