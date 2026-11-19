---
name: record
description: '$KARO_HOME の記録の置き場所（書き込み先・情報源）と探し方の表、状態が変わったときに書くものの表、記録のファイルを Edit・Write で書き、karo の commit の script で commit する手順と、ノートのフロントマターの書き方（type、項目の埋め方、置き場所、状態が変わったときに直すフィールド）と、karo の長い目の決定の Decision Record の書き方と置き換え方と、karo の今の状態の state.md の形と書き直す時機と、NG の直し方と、調べ物を karrybit:researcher のサブエージェントに頼むときに依頼に書く karo の規則。記録のファイルを書くとき、記録を探すとき、ノートのフロントマターを書くか直すとき、オーナーが karo の運用・設計の方針を決めたか変えたとき、委任・取り込み・終了を記録するとき、state.md を書き直すとき、commit か karo-check が問題を出したとき、調べ物や MTG の記録づくりを頼むときに使う。'
user-invocable: false
---

# 記録を書いて commit する

- 記録のファイルは、下の「書き込み先」の表の記録のファイル。タスク・判断待ち・タスクかプロジェクトに閉じた決定は記録のファイルに書かず、`bd` で書く（`karo:tasks` skill）。karo 自身の長い目の運用・設計の決定は、下の「Decision Record を書く」で `$KARO_HOME/decisions/` に書く。過去の会話も書き写さず、要るときは cass で引く（`karo:recall` skill）。
- 下の `<scripts>` は `~/.config/claude/skills/karo/scripts` で、この `~/` の形のまま書く。
- ノートを作る前と、ノートのフロントマターを書くか直す前に、この skill のフォルダの `frontmatter.md` を読む。フィールドの書き方、種類ごとの置き場所と埋め方、状態が変わったときに直すフィールドがある。

## 書く

- 新しいファイルは Write で、今あるファイルへの追記と直しは Edit で、`$KARO_HOME` の下の絶対パスに書く（`$KARO_HOME` の値は SessionStart の hook が出す）。
- Edit・Write のあと、post-edit の hook が `.md` を rumdl で整え、`<scripts>/karo-check --only <そのファイル>` で確かめる。hook が問題を返したら、そのファイルを直してから commit する。hook が返すのは書いたファイルの問題か検査そのものの失敗だけで、消すか名前を変えた Project のノートを `projects` に挙げるほかのノートの問題は commit が止める。
- standup（`standup/YYYY-MM-DD.md`）がまだなければ、Write で `type: Standup`・`date`・`description`・`tasks`・`projects`（当たるものがなければ `[]`）のフロントマターから作る（`frontmatter.md` の「種類」の `Standup` の行）。
- `state.md` は、下の「state.md を書く」に従って書く。
- 運用の出来事（タスクを持たない依頼で記録を変えたこと）は、commit の本文に書く。
- 長い本文（サブエージェントの調査の結果、imozuru の原文）は、そのサブエージェントや imozuru に `$KARO_HOME` の書き先へ直接書かせ、終わったらそのパスを commit に渡す。

## 書き込み先

この表と下の「情報源」の表が、情報ごとの正本の置き場所を決める。パスは `$` で始まるものを除き `$KARO_HOME` からのパス。

| 場所 | 内容 |
| --- | --- |
| `.beads`（Beads。`bd` で書く） | タスク・判断待ち・タスクかプロジェクトに閉じた決定と、タスクの出来事（claim・close の event と comment。レビューの要旨も comment）。書き方は `karo:tasks` skill |
| `decisions/YYYY-MM-DD-<話題>.md` | karo 自身の長い目の運用・設計の決定（Decision Record）と、その理由。下の「Decision Record を書く」 |
| `$KARO_STATE_HOME/state.md` | karo の今の状態。git の外。下の「state.md を書く」 |
| `standup/YYYY-MM-DD.md` | checkin（Daily Standup）と checkout の記録 |
| `source/meeting/YYYY-MM-DD-<MTG>.md` | 1 つの MTG の決定・宿題と、議事録への参照 |
| `investigation/YYYY-MM-DD-<話題>.md` | 調べた結果と出典 |
| `investigation/YYYY-MM-DD-<話題>/` | imozuru で集めた調査の原文（`sources/`）と map.md。同じ名前の調査ノートの隣に置く |
| `project/repo/<vcs>/<org>/<repo>.md` | リポジトリの運用の約束。`<vcs>/<org>/<repo>` はホストからの形（例 `github.com/acme/demo`、リモートのないリポジトリは `local/<owner>/<repo>`） |
| `project/repo/<vcs>/<org>/<repo>/review/` | レビューの原本（新しくは書かない） |
| `project/design/YYYY-MM-DD-design-doc-<話題>.md` | Design Doc。実現したいこと（機能）ごとに 1 本で、複数のリポジトリをまたいでよい。下の「置き場所の補足」のとおり反映したら消す |
| `project/misc/<theme>.md` | リポジトリを持たない話題の運用の約束 |
| `project/misc/<theme>/YYYY-MM-DD-<資料名>.md` | その話題の手順。直しても名前を変えない |
| `doc/<話題>.md` | 話題ごとにまとめた資料（人に渡すものも、karo やオーナーが読み返すものも） |
| `$KARO_DATA_HOME/html/<UUID>/` | HTML の解説。git の外で、commit しない。書き方は `karo:explain` skill |

- 記録は 3 つの層に分ける。Bronze は観察の原本（review、`investigation/*/sources/`、外の原文の URL）、Silver は比べられる形に整えて事実の正を 1 か所に持つ記録（Beads、`decisions/`、`source/meeting/`、`investigation/`、`project/repo/*.md`、`project/misc/<theme>.md`）、Gold は判断や行動のための出力で Silver から作り直す（`state.md`、`standup/`、`doc/`、`project/misc/<theme>/`、`project/design/`）。層は置き場所で決まり、karo-check は層を確かめない。
- このセッションで初めて記録の置き場所を決める前と、置き場所が決まっていない種類の情報を書く前と、記録を探す前に、`karrybit:data-information-design` skill を使い、その skill が受け取る値（層の置き場所、置き場所の補足、探す表、検証）はこの節と下の「置き場所の補足」「探す」から渡す。

### 情報源

| 知りたいこと | 情報源 |
| --- | --- |
| Agent の実行状態と、タスク・workspace・pane・worktree・branch の対応 | `karo:tasks` skill の「今の状況を読む」の突き合わせ。取得できなければ「不明」と報告する |
| 終えた Agent の worktree と branch | そのタスクの Beads の `報告:` の comment |
| タスク・担当・判断待ち・タスクかプロジェクトに閉じた決定 | SessionStart の hook が出す Beads の一覧、`bd`（`karo:tasks` skill） |
| karo 自身の長い目の決定と理由 | `decisions/` の Decision Record（下の「探す」） |
| 経緯と理由 | 下の「探す」の手順と `git log` |
| 今のセッションにも記録にもない過去の会話 | cass。当たりは過去の証拠で、今の決定の正本ではない（`karo:recall` skill） |
| 会議や議論の内容 | `source/meeting/` の MTG の記録と、オーナーが接続した外のサービス（読む範囲は `$KARO_HOME/AGENTS.md` にあればそれに従う） |

### 置き場所の補足

| 情報 | 書き方 |
| --- | --- |
| 外の原文（チャット、議事録、チケット、PR） | 使うノートの `sources` か、記録の commit の本文に URL を書く |
| 外に送った文面 | そのタスクの bead の notes に、要旨 1 行と送った先の permalink を書く（`karo:tasks` skill の「項目の対応」） |
| MTG で決まったこと | `source/meeting/YYYY-MM-DD-<MTG>.md` の「決定」「宿題」の見出しの下 |
| 調べた結果の中のオーナーに決めてほしいこと | decision の bead を起票し、その ID をノートに書き添える |
| 機能の設計の案（ADR と spec に反映する前） | Design Doc（日付は作った日）。決定は反映先のリポジトリの ADR に、今の仕様は spec に反映し、その PR の URL をすべてタスクの comment に書いてから、Design Doc を消す。反映先は、その機能が変えるリポジトリのすべて |
| プロジェクトの運用の約束 | 今の状態と効く決定の一覧は書かない（Beads の label `project:<name>` で引き、karo 自身の長い目の決定は `decisions/` で引く） |
| 外の原文の lineage | フロントマターの `sources` に `{ id, resource, title }`。Investigation は本文で読んだものをここに写す |
| 本文の中のノートへのリンク | `[<名前>](<$KARO_HOME からのパス>)`（例: `[リリースの手順](project/misc/work/2026-01-05-release.md)`） |

## 記録の更新

- 状態が変わったら、次の作業に移る前に、下の表のとおり `bd` で書き、記録のファイルを書いて下の「commit する」で commit する。`bd` と commit を実行するまで、その変化は完了していない。
- 表の出来事が下の「state.md を書く」の「書き直す時機」に当たるときは、同じ返事の中で `state.md` も直す。

| 出来事 | `bd` で行うこと（`karo:tasks` skill） | 書いて commit するファイル |
| --- | --- | --- |
| オーナーから仕事を頼まれた | タスクを作る（その場で終えた仕事も作り、終えたら閉じる） | なし（運用の依頼は下の箇条） |
| 委任した | Agent の名前で claim する | なし |
| Agent の完了を確認した | `報告:` の comment（Agent の worktree と branch を書く） | なし |
| レビュー結果を受け取った・中継した | `レビュー依頼:`・`変更依頼:`・`承認:`・`判定:` の comment（`karo:review` skill） | なし |
| 作業を取り込んだ（karo の land、push、PR の merge） | タスクを閉じる | なし |
| 判断が必要になった | decision の bead を作り、タスクの blocker にする | なし |
| オーナーが決めた | decision の bead を閉じるか、`決定:` の comment。karo の長い目の方針なら、閉じる理由に Decision Record のパスだけを書く | karo の長い目の方針なら、`decisions/` の Decision Record |
| Agent を終了した | 取り込まずに止めたときは claim を外す | なし |

- どのタスクにも属さない運用の依頼（Agent の終了、状況の確認、karo の記録や規則の直し）では、Beads のタスクを作らない。記録を変えるときは返事を送る前に commit し、本文に、依頼が触れたタスク ID か `karo`、何をなぜしたか（規則を足したときはその理由）、出典 `会話 YYYY-MM-DD HH:MM` を書く。
- タスクのない外のチケットの依頼は、運用の依頼として扱わず、Beads に新しいタスクを作る。
- 返事の要らないメモ（「メモ: ○○」）は、関わるタスクの Beads の `メモ:` の comment にし（当たるタスクがなければタスクを作る）、記録したことだけを返す。
- 閉じたタスクと決定は Beads に残す（消すか畳むコマンドは settings の `deny` が止める）。

## 探す

- コマンドは `$KARO_HOME` で実行する。`bd` は単独の呼び出しにする（`karo:tasks` skill の「呼び方」）。
- 全文検索は、Beads は `karo:tasks` skill の「タスクを進める」の 1、ファイルは `rg -n '<語>' standup source investigation decisions`、commit の本文は `git log -i --grep '<語>'` で行う。
- タスク ID の正規表現は `[A-Za-z][A-Za-z0-9]*(-[A-Za-z0-9]+)+(\.[0-9]+)*` にする。

| 問い | 手順（1 行が 1 回の呼び出し） |
| --- | --- |
| セッション開始・compact 後 | SessionStart の hook の出力（`state.md`、Beads の一覧）。Beads の一覧がなければ、`karo:tasks` skill の「今の状況を読む」の「開いているタスク」と「判断待ち」 |
| タスクの今の一覧 | `karo:tasks` skill の「今の状況を読む」の表 |
| タスクの経緯と今の状態 | `bd show <タスクID> --json --include-comments`、続けて `bd history <タスクID> --events --json`、続けて `rg -n <タスクID> "${KARO_STATE_HOME:-${XDG_STATE_HOME:-$HOME/.local/state}/karo}/state.md"; rg -lUP '\A---\n(?:(?!---\n).*\n)*?tasks:\n(?:  - .+\n)*  - <タスクID>\n' -g '!investigation/*/sources/**' .` |
| 過去の会話 | `karo:recall` skill |
| タスクの分析（依存・ボトルネック・次の候補） | `karo:tasks` skill の「分析する（bv）」 |
| ある日からの出来事 | `karo:tasks` skill の「今の状況を読む」の「ある日から動いたタスク」、続けて `git log --since YYYY-MM-DD` |
| 委任するプロジェクトに効く決定と運用 | `cat project/*/<name>.md`、続けて `bd list --all --type decision --status closed --label-any project:<name>,project:all --json`、続けて `bd dep list <それらの ID> --direction up --type supersedes --json`（返った ID は置き換え済み）。karo の仕組みを変える委任では、下の「karo の今の長い目の決定」も読む |
| karo の今の長い目の決定 | `rg -L '^status: deprecated$' decisions`。理由と出典はそのファイルの本文 |
| karo の長い目の決定を語で探す | `rg -n '<語>' decisions` |
| タスクとプロジェクトの決定を語で探す | `bd list --all --type decision --desc-contains '<語>' --json` |
| Beads の決定の理由と出典 | `bd show <決定の ID> --json` |
| MTG で決まったこと | `rg -n -A6 '^#+ (決定\|宿題)' source/meeting/YYYY-MM-DD-*.md` |
| プロジェクトの現状 | `cat project/*/<name>.md`、開いているタスクは「タスクの今の一覧」に `--label project:<name>` を足す |
| HTML の解説（作る前） | `karo:explain` skill の 1 と 2 |
| `doc/` の資料の最新版 | `cat doc/<話題>.md`。前の版は `git log -p -- doc/<話題>.md` |
| 外に作ったもの・送った文面 | `bd list --all --notes-contains '<ID か URL の一部か相手>' --json`、続けて `bd list --all --desc-contains '<同じ語>' --json`、続けて `rg -n '<同じ語>' standup source` |
| 調査の原文 | `investigation/YYYY-MM-DD-<話題>/map.md` の論点から原文の行へ。`rg -n '<語>' investigation/YYYY-MM-DD-<話題>/sources` |
| 下書き・置き換え済み | `rg -lUP '\A---\n(?:(?!---\n).*\n)*?status: (?:draft\|deprecated)' -g '!investigation/*/sources/**' .`。Decision Record の置き換え先は古い記録の「状態」の節 |

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

- 決定を変えるときは、新しい記録を書き、その `## 参照` に古い記録のリンクを書く。古い記録は消さずに、`frontmatter.md` の「追記したとき・状態が変わったとき」の表の「決定を新しい決定で置き換えた」の行のとおり直し、2 つを同じ commit に入れる。誤字と事実の誤りの訂正は、古い記録を Edit で直すだけにする。
- 判断待ちの decision の bead から決まった決定は、記録を書いてから、bead を `bd close <決定> --reason '決定: decisions/<記録>.md' --json` で閉じる。決定の全文は記録にだけ置き、bead には書き写さない。
- Decision Record は理由を持ち、karo が今従う規則は持たない。規則は、オーナーの仕事の仕方なら `$KARO_HOME/AGENTS.md`・`$KARO_HOME/rule/` に、karo の仕組みなら karo plugin に書き、規則の行から記録のパスを指す。

## state.md を書く

- `$KARO_STATE_HOME/state.md` は karo の今の状態（Working Memory）で、karo だけが書く。委任した Agent とサブエージェントには、state.md を書かせない。
- state.md は git の外にあるので、Edit・Write で書き、commit のパスに並べない（`$KARO_STATE_HOME` の値は SessionStart の hook が出す）。
- karo の `scripts/state-context` の hook が、SessionStart（startup・resume・clear・compact・fork）で state.md の全文と最終更新の時刻を出し、PreCompact で compact の要約に、state.md の中身を写さず最終更新より後の変化を残すよう指示する。
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
| 情報源のアクセスの制約 | 外のサービスは読むだけにすること。`$KARO_HOME/AGENTS.md` に外のサービスや MTG の議事録を読む範囲の決まりがあれば、その文を写して書く |
| ノートの規則 | 書く前に `frontmatter.md`（この skill のフォルダ。依頼には絶対パスで書く）を Read で読み、その「フィールド」と、書き先の種類の行（調べ物は `Investigation`、MTG は `Meeting Notes`、imozuru の map.md は `Research Map`）に従うこと |
| 検査 | `~/.config/claude/skills/karo/scripts/karo-check --only <ノートの $KARO_HOME からのパス>` を `~/` の形のまま単独で実行する（imozuru を使ったら `--only investigation/YYYY-MM-DD-<話題>/map.md` も足す）。合格は、終了コードが 2 でなく、出力に `<ノートのパス><TAB>` で始まる行がないこと。ほかのノートの行は数えないので、件数の行（`karo-check: <件数> problem(s) in the --only scope`）が 0 でなくてもよい。終了コード 2 は検査そのものの失敗（`$KARO_HOME` に入れない、yq・fd・rg を動かせない） |
| 追加の skill | 分野や論点を探る調査には `imozuru:imozuru` を使ってよく、原文の保存先はノートと同じ名前のフォルダ `$KARO_HOME/investigation/YYYY-MM-DD-<話題>/` |
| 分担 | ノートの commit は karo が commit の script で行い、判断待ち（decision の bead）は karo が `bd` で作る。サブエージェントは commit も `bd` もしない |

- 報告を受けたら、ノートの結論を左右する主張のどれもが、確かめた出典の箇所か、「未確認」の印と結論への影響を持つかを確かめる。どちらもない主張があればやり直させ、なければ報告の「commit に入れるファイル」を下の「commit する」で 1 つの commit にしてからオーナーに報告する。

## commit する

1. 1 つの返事に要る書き込みをすべて書いたら、それを 1 つの commit にする。`<scripts>/commit '<件名>' '<本文>' <パス>...` を単独の Bash の呼び出しで（パイプ・リダイレクト・`&&` をつながずに）実行する。
   - 件名は `<タスクID>[, <タスクID>]...: <何を変えたか>` の形にし、そのやり取りのタスク ID で始める。タスクのないやり取りでは、ID を置かずに何を変えたかだけを書く。
   - 本文には、なぜ変えたか（オーナーのどの指示か、どの決定・出典に基づくか）を書く。件名と本文は、それぞれ改行を含まない 1 行にし、`'` で囲む（本文に `'` を入れない）。
   - パスは `$KARO_HOME` からの相対パスで、この commit に入れるファイルをすべて並べる（消したファイルも、名前を変えたファイルは前と後の両方も並べる）。commit は並べたパスだけを stage し、commit に入る中身（HEAD に並べたパスの今の中身を足したもの）を `<scripts>/karo-check --only` で、そのパスと、消すか名前を変えた Project のノートを `projects` に挙げるほかのノートについて確かめる。並べていないファイルの直しは中身に入らないので、ほかのノートを直したらそのノートも並べる。記録の全体は確かめないので、全体は `karo:land`・`karo:checkout` の引数なしの karo-check が確かめる。

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
- `<パス><TAB><問題>` の行（karo-check の出力）: フロントマターを `frontmatter.md` に合わせて直す。並べたパスでなく、消した Project のノートを `projects` に挙げるほかのノートの行（`unknown project`）なら、そのノートの値を直し、そのノートも commit のパスに並べる。
- `karo-check:` で始まり件数のない行と終了コード 2（`cannot run <道具>`）: 検査そのものが動いていない。ノートを直さず、その行をオーナーに伝える。
- `git diff --check` の出力（行末の空白、末尾の空行など）: 出た行を直す。
- `usage:` の行: 引数が足りないか、本文が空。件名・本文・パスをそろえて実行し直す。
- オーナーの判断が要って直せない NG は、理由の行をオーナーに伝える。書いたファイルは commit されないまま残る。
