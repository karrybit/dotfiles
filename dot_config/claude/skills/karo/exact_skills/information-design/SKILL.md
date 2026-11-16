---
name: information-design
description: '~/cos の記録の層（Bronze・Silver・Gold）、新しい情報の置き場所の決め方、lineage と鮮度、記録の探し方、検証。置き場所が決まっていない情報を書く前、記録を探すとき、セッション開始と compact のあとに状況を読むときに使う。'
user-invocable: false
---

# 記録の情報設計

- `~/cos` の記録を、Bronze・Silver・Gold の 3 つの層に分けて置く。
- 目的は 2 つ。同じ事実の正を 1 か所に持って食い違いをなくすことと、よく来る問いに少ない手数で届くこと。

## 層

| 層 | 何か | 置き場所 | 書き方 |
| --- | --- | --- | --- |
| Bronze | 観察の原本。方針の範囲で原文に忠実に残す | `threads/`、`projects/repos/<vcs>/<org>/<repo>/reviews/`、`investigations/YYYY-MM-DD-<話題>/sources/`。外の原文（Slack、Google Docs、Asana、GitHub）は URL だけ | 追記のみ、または道具が書く。あとから書き換えない |
| Silver | 比べられる形に整えた記録。事実の正 | Beads（`~/cos/.beads`。タスク・判断待ち・決定とタスクの出来事）、`journal/` の MTG の記録と過去の日次ファイル、`assignments.md`、`investigations/`（`sources/` を除く）、`projects/repos/<vcs>/<org>/<repo>.md`、`projects/misc/<theme>.md` | ID・日付・プロジェクトの名前を揃え、出典を付ける |
| Gold | 判断や行動のための出力 | `state.md`、`journal/YYYY-MM-DD-standup.md`、`docs/`、`projects/misc/<theme>/YYYY-MM-DD-<資料名>.md`、`projects/repos/<vcs>/<org>/<repo>/YYYY-MM-DD-design-doc-<話題>.md` | Silver から作り直す。Gold にしかない事実を作らない |

- `type` と層の対応、`type` と置き場所の対応は、`~/cos/rules/frontmatter-schema.yaml` の `layers` と `paths` が正本。

## 1. 新しい情報の置き場所を決める

- 新しい情報は、下の表を上から順に当てはめ、最初に当たった行の置き場所に置く。完了条件: 書いた事実の正が Silver の 1 か所にあり、Bronze と Gold からはそこを指している。

| 情報 | 置き場所と書き方 |
| --- | --- |
| 外の原文（Slack、議事録、チケット、PR） | ~/cos に写さず、使うノートの `sources` か record の指示の `commit 本文:` に URL を書く。写すのは、消えるおそれがあり、「4. Safety」の範囲に収まる部分だけ |
| オーナーとの会話 | `threads/` のその話題のファイルに追記する（話題の分け方は `karo:threads` skill）。どのタスクにも属さない運用の依頼は threads に書かない（`~/cos/AGENTS.md` の「会話の記録」） |
| 外に送った文面 | そのタスクの bead の notes に、要旨 1 行と送った先の permalink を書く（`karo:beads` skill の「項目の対応」）。本文の正は送った先にあるので全文は写さない |
| タスクの出来事（委任、報告、レビュー、決定、質問、終了） | Beads の event と comment（`karo:beads` skill の「comment の語」） |
| タスクを持たない運用の出来事 | その出来事で変えた記録の、record の指示の `commit 本文:` |
| タスクの依頼・成果物・状態と判断待ち | Beads（`karo:beads` skill）。title は何をするかだけにし、経過は comment に書く |
| Agent の担当の変化 | `assignments.md` の行を直す |
| 複数のタスクかプロジェクトに効く決定 | Beads の decision の bead（`karo:beads` skill の「判断待ちと決定」）。そのタスクの中だけの決定は、`決定:` の comment で足りる |
| MTG で決まったこと | `journal/YYYY-MM-DD-<MTG>.md` の「決定」「宿題」の見出しの下 |
| リポジトリの設計の案（ADR と spec に反映する前） | `projects/repos/<vcs>/<org>/<repo>/YYYY-MM-DD-design-doc-<話題>.md`（Design Doc。日付は作った日）。`derived_from` に元の調べ物か threads を書き、Design Doc にしかない事実を作らない。決定はそのリポジトリの ADR に、今の仕様は spec に反映し、その PR の URL をタスクの comment に書いてから、Design Doc を消す |
| 調べた結果 | `investigations/YYYY-MM-DD-<話題>.md`。調査の中にオーナーに決めてほしいことがあれば、decision の bead を起票してその ID を書き添える |
| プロジェクトの運用の約束（リポジトリ、確かめ方、取り込み方） | リポジトリは `projects/repos/<vcs>/<org>/<repo>.md`（`<vcs>/<org>/<repo>` は `karo:frontmatter` skill の種類の表の Project の行）、リポジトリを持たない話題は `projects/misc/<theme>.md`。今の状態と効く決定の一覧は書かない（Beads の label `project:<name>` で引く） |
| リポジトリを持たない話題の手順 | `projects/misc/<theme>/YYYY-MM-DD-<資料名>.md`。日付は作った日で、直しても名前を変えない |
| 作った HTML の解説 | `docs/<id>/<version>/`。置き方は `karo:explain` skill |
| 判断や行動のためにまとめたもの | `state.md`、`journal/YYYY-MM-DD-standup.md`、`docs/<話題>.md`（版ごとにファイルを作らず、同じファイルを直す） |

## 2. Lineage を書く

| 書くもの | 書き方 |
| --- | --- |
| 外の原文 | フロントマターの `sources` に `{ id, resource, title }`。Investigation は本文で読んだものをここに写す |
| ~/cos の中の元のノート | `derived_from` にパス。行の指し方は `karo:frontmatter` skill の `derived_from` の行（例: `journal/2026-01-05.md#12:40`、`threads/cos-k3m-fb-sort.md#2026-01-06 14:42`） |
| 本文の中のノートへのリンク | `[<名前>](<~/cos からのパス>)`（例: `[リリースの手順](projects/misc/work/2026-01-05-release.md)`）。karo-check が、リンク先のファイルがあることを確かめる |

- `derived_from` は、自分と同じか下の層だけを指す（Gold → Silver・Bronze、Silver → Silver・Bronze）。
- ノートを動かすときは、同じ commit で、そのパスを指す `derived_from`・本文のリンクを新しいパスに直す。karo-check がぶら下がったリンクを NG にする。
- リンクでない本文の中の古いパスは、Bronze と journal では直さず、`fd <基本名>` で辿る。

完了条件: `frontmatter-schema.yaml` の `lineage` の種類のノートが `sources` か `derived_from` を持ち、「6. 検証」が 0 件。

## 3. Freshness を書く

- 期限のある事実（ツールの版、issue の状態、審査の回答待ち、契約の内容）を書いた Silver には、`stale_after` を書く。
- `stale_after` の期限を過ぎたときの直し方は、`karo:frontmatter` skill の「2. 追記したとき・状態が変わったとき」の表にある。
- 最後に変わった日は `git log -1 --format=%cs -- <path>` で出す。フロントマターに更新日を書かない。
- Gold は作り直すもので、古さを印で表さない。
- `state.md` の焦点には、行の先頭にタスク ID を書く。
- 決定の一部だけが変わったときも新しい決定を作る（置き換えの書き方は `karo:beads` skill の「判断待ちと決定」）。

完了条件: 「6. 検証」の stale が 0 件か、オーナーに報告済み。

## 4. Safety

- Bronze でも次は残さない。秘密（トークン、パスワード、cookie、セッション）、個人情報で仕事に要らないもの、配布の条件がわからない著作物の全文。
- 残さないものを見つけたら、値を写さずにオーナーに報告する。

## 5. 探す

- 先に下の表の手順で探し、届かないときだけ本文を全文検索する。
- 全文検索は Silver の場所から始め、threads は最後にする。Beads は `bd search '<語>' --json`（title）と `bd list --all --desc-contains '<語>' --json`（本文）、ファイルは `rg -n '<語>' journal investigations`、commit の本文は `git log -i --grep '<語>'` で探す。
- コマンドは `~/cos` で実行する。`bd` は単独の呼び出しにする（`karo:beads` skill の「呼び方」）。
- タスク ID の正規表現は `cos-[a-z0-9]{3,8}(\.[0-9]+)*` にする。旧形の ID（Beads の ID の形でないタスク・判断待ち・決定の ID）を探すときは、`~/cos/rules/legacy-ids.md` があればそれを読む。
- 下の `<scripts>` は `~/.config/claude/skills/karo/scripts` で、この `~/` の形のまま書く。

| 問い | 手順（1 行が 1 回の呼び出し） |
| --- | --- |
| セッション開始・compact 後（`~/cos/AGENTS.md` の「セッション開始時と compact 後」の 1 の読み方） | SessionStart の hook の出力（`state.md`、`bd prime`、Beads の一覧、話題の一覧）、続けて `sed -n '/^## 稼働中/,/^## 終了/p' assignments.md`。hook の出力に Beads の一覧がなければ、下の「開いているタスク」と「判断待ち」の行 |
| 開いているタスク（ID・状態・優先度・担当・label・件名） | `bd list --status open,in_progress,blocked,deferred --json`（type が `decision` のものは判断待ち） |
| 判断待ち | `bd human list --status open --json` |
| 着手できるタスク | `bd ready --exclude-type decision --json` |
| ある日から閉じたタスク | `bd list --all --closed-after YYYY-MM-DD --json` |
| タスクの経緯と今の状態 | `bd show <タスクID> --json --include-comments`、続けて `bd history <タスクID> --events --json`、続けて `rg -n <タスクID> state.md; rg -lUP '\A---\n(?:(?!---\n).*\n)*?tasks:\n(?:  - .+\n)*  - <タスクID>\n' -g '!investigations/*/sources/**' .` |
| （続き）最近の発言と、古い会話に残る決定 | `<scripts>/thread-index --task <タスクID>` で話題のファイルを引き、`karo:threads` skill の「話題に戻る」の 1 |
| ある日からの出来事 | `bd list --all --updated-after YYYY-MM-DD --json`、続けて `bd show <ID...> --json --include-comments`、続けて `git log --since YYYY-MM-DD`（運用の出来事は commit の本文にある）。過去の日次ファイルがある日は `cat journal/YYYY-MM-DD.md` も読む |
| 委任するプロジェクトに効く決定と運用 | `cat projects/*/<name>.md`、続けて `bd list --all --type decision --status closed --label-any project:<name>,project:all --json`、続けて `bd dep list <それらの ID> --direction up --type supersedes --json`（返った ID は置き換え済み） |
| 決定を語で探す | `bd list --all --type decision --desc-contains '<語>' --json`（決定の文は本文にあり、comment は検索されない） |
| 決定の理由と出典 | `bd show <決定の ID> --json` |
| MTG で決まったこと | `rg -n -A6 '^#+ (決定\|宿題)' journal/YYYY-MM-DD-*.md` |
| プロジェクトの現状 | `cat projects/*/<name>.md`、開いているタスクは上の `bd list` に `--label project:<name>` を足す、効く決定は上と同じ |
| HTML の解説（作る前） | `karo:explain` skill の 1 と 2 |
| 人に渡す資料の最新版 | `cat docs/<話題>.md`。前の版は `git log -p -- docs/<話題>.md` |
| 外に作ったもの・送った文面（Asana、PR、Slack） | `bd list --all --notes-contains '<ID か URL の一部か相手>' --json`、続けて `bd list --all --desc-contains '<ID か URL の一部か相手>' --json`、続けて `rg -n '<ID か URL の一部か相手>' journal` |
| 調査の原文 | `investigations/YYYY-MM-DD-<話題>/map.md` の論点から原文の行へ。`rg -n '<語>' investigations/YYYY-MM-DD-<話題>/sources` |
| 下書き・置き換え済み | `rg -lUP '\A---\n(?:(?!---\n).*\n)*?status: (?:draft\|deprecated)' -g '!investigations/*/sources/**' .`。置き換え済みの決定は上の「委任するプロジェクトに効く決定と運用」の `bd dep list` |
| 古いパス（journal や threads の中） | `fd '<基本名>'` |

- 本文の全文検索で見つかったノートのフロントマターが問いのキー（`tasks`、`projects`）を持っていなければ、`karo:frontmatter` skill の「3. 決まりに合わないノートを見つけたとき」の手順で直す。

完了条件: 答えの根拠が、表の手順で読んだ出力か、開いたファイルにある。

## 6. 検証

セッション開始時（`~/cos/AGENTS.md` の「セッション開始時と compact 後」の 2）に、次を実行する。記録を直接書くサブエージェントと Agent は、終える前に、変えたノートだけを `~/.config/claude/skills/karo/scripts/karo-check --only <~/cos からのパス>` で確かめる（ほかのノートの問題は、変えてよい範囲の外なので数えない）。CoS の書き込みは record が確かめる（範囲は `karo:record` skill の冒頭）。

```sh
~/.config/claude/skills/karo/scripts/karo-check
```

- karo-check は、問題ごとに `<パス><TAB><問題>` を出し、1 件でもあれば 0 以外で終わる。
- karo-check が確かめることの範囲は、karo の `scripts/karo-check` の冒頭にある。karo-check は `bd` を呼ばず、Beads の ID は形だけを確かめる。フロントマター・置き場所・Lineage・パスのリンクの検査は、karo-check が呼ぶ karrybit の `okf-lint` skill が行う。
- 失敗に数えない警告が 2 つある。`stale since` は `stale_after` を過ぎたノート。`task in body not in tasks` は、thread の本文に出てくるタスク ID がその `tasks` にないもの。
- `task in body not in tasks` が出たら、派生タスクの会話なら `tasks` に足し、ほかのタスクへの言及ならそのままにする。別の話題が混ざっているなら、オーナーに報告する。
- karo の `scripts/karo-check` か `~/cos/rules/frontmatter-schema.yaml` を直したら、`~/.config/claude/skills/karo/scripts/karo-check-test` も実行する。karo-check-test は、正しい小さな記録が通り、壊したノートの写しがそれぞれ検出されることを確かめる。

完了条件: `karo-check: 0 problem(s)` が出て終了コードが 0。検証を直したときは、`karo-check-test: 0 failure(s)` も出る。
