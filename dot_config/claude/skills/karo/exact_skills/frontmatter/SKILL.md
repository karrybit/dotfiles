---
name: frontmatter
description: '~/cos のノートのフロントマター（type、項目の埋め方、置き場所、lineage）の書き方と、karo-check が出した問題の直し方。ノートを作る・直すとき、フロントマターを書くとき、karo-check がフロントマターの問題を出したときに使う。'
user-invocable: false
---

# 記録のフロントマター

- `~/cos` の記録のフォルダ（`~/cos/AGENTS.md` の「書き込み先」の表のフォルダ）のノートは、1 行目から OKF（Open Knowledge Format v0.2）の YAML フロントマターを持つ。
- フロントマターは記録の索引で、引き方は `karo:information-design` skill の「5. 探す」にある。
- 種類ごとの必須のフィールドと置き場所は `~/cos/rules/frontmatter-schema.yaml` が正本で、`~/.config/claude/skills/karo/scripts/karo-check` がそれで確かめる。schema のキー（`types`・`layers`・`paths`・`lineage`・`files`・`exclude`）の意味は `karrybit:okf-lint` skill の「schema の形」にある。
- 対象はこれらのフォルダの `.md` すべてで、対象にしないものは `frontmatter-schema.yaml` の `exclude` にある（imozuru が書く `investigations/YYYY-MM-DD-<話題>/sources/` の原文など）。

## フィールド

| フィールド | 書き方 |
| --- | --- |
| `type` | 下の表の値 |
| `description` | 1 文の要約。ファイル名の言い換えでなく、中身の結論か目的を書く |
| `topic` | threads の短い話題（`threads/template.md` と `threads/memo.md` も持つ）。thread-show が pane の label と glow の見出しにする |
| `date` | `YYYY-MM-DD`、引用符なし。ノートの日（journal の日、決めた日、MTG の日、会話を始めた日、調べた日） |
| `tasks` | タスク ID のブロック形式のリスト（`  - cos-a2v`）。タスクのない threads は `tasks: []`。タスク ID のない仕事は外のチケットのキー（`ABC-123`） |
| `projects` | プロジェクトの名前のブロック形式のリスト。値は Project のノートの、`projects/repos/` か `projects/misc/` より後ろのパスから `.md` を除いたもの（`github.com/acme/demo`、`work`） |
| `status` | 下書きは `draft`、置き換わったものは `deprecated`。仕上がったものには書かない |
| `resource` | ノートが表す実物の URL（リポジトリ、PR） |
| `sources` | `- { id, resource, title }` のリスト。外の原文（議事録、Slack、資料、ドキュメント）の URL |
| `derived_from` | ~/cos の中の元のノートのパスのリスト。行を指すときは `#` のあとに journal の `HH:MM` か threads の `YYYY-MM-DD HH:MM` |
| `stale_after` | 期限のある事実を書いた調査の見直しの日時。`2026-12-05T00:00:00+09:00` |

- キーは `type`、`description`、`topic`、`date`、`tasks`、`projects`、`status`、`resource`、`sources`、`derived_from`、`stale_after` の順に書く。
- 既存の reviews のファイルにある、ほかの道具が書いたキー（Plannotator の `decision`・`worktree`・`reviewed`）は、そのまま後ろに残す。
- 値が `` ` ``・`[`・`*`・`&`・`!`・`|`・`>`・`'`・`"`・`%`・`@` で始まるとき、`: ` か ` #` を含むときは、値を単一引用符で囲む。
- 旧形の ID（Beads の ID の形でないタスク・判断待ち・決定の ID）が記録に出たら、`~/cos/rules/legacy-ids.md` があればそれを読む。

## 種類

| 置き場所 | `type` | 埋め方 |
| --- | --- | --- |
| `journal/YYYY-MM-DD.md` | `Journal` | 過去分のみで、新しいファイルは作らない。`date` はファイル名 |
| `journal/YYYY-MM-DD-standup.md` | `Standup` | `date` はファイル名。`tasks` は報告で挙げたタスク。`derived_from` は、元にしたノートがあれば書く |
| `projects/repos/<vcs>/<org>/<repo>.md`、`projects/misc/<theme>.md` | `Project` | `resource` はリポジトリの URL（`misc/` は書かない）。`<vcs>/<org>/<repo>` は `resource` の URL のホストとパスで、リモートのないリポジトリは `local/<owner>/<repo>`。`projects` は自分の名前 |
| `projects/misc/<theme>/YYYY-MM-DD-<資料名>.md` | `Playbook` | 下書きのあいだは `status: draft`。`derived_from` に元のノート |
| `projects/repos/<vcs>/<org>/<repo>/YYYY-MM-DD-design-doc-<話題>.md` | `Design Doc` | `date` はファイル名。`derived_from` に元の調べ物か threads の発言。`status` は書かない |
| `projects/repos/<vcs>/<org>/<repo>/reviews/` | `Review` | `tasks` はファイル名のタスク ID。`resource` はレビューした PR |
| `journal/YYYY-MM-DD-<MTG>.md` | `Meeting Notes` | `sources` に議事録・資料ごとの URL と名前 |
| `investigations/YYYY-MM-DD-<話題>.md` | `Investigation` | `sources` に読んだ原文。~/cos の中だけを元にしたら `derived_from`。期限のある事実（ツールの版、issue の状態）を書いたら `stale_after` |
| `docs/<話題>.md` | `Document` | `derived_from` か `sources` に元 |
| `investigations/YYYY-MM-DD-<話題>/map.md` | `Research Map` | `description` は `題:` のあとの文（`題:` は付けない） |
| `docs/<id>/<version>/index.md` | `Explain` | `description` は解説の話題と結論の 1 文。`resource` は元の資料の URL（git はリポジトリ、Confluence はページ）。URL のない資料は `~/cos` からのパス（例: `investigations/<ファイル>`）。`projects` はプロジェクトの名前（上の `projects` の行）。`tasks` は解説を頼まれたタスク。`derived_from` に頼まれた threads の発言。版はフォルダの名前で表し、フィールドに書かない |
| `threads/<タスクID>-<話題>.md`、`threads/YYYY-MM-DD-<話題>.md` | `Thread` | `description` は会話で何をするかの 1 文。`topic` は pane の label に収まる短い話題。`date` は作った日。`tasks` はその話題で進めるタスクの ID（議論だけの話題は `tasks: []`）。`projects` はタスクの label `project:<名前>` の名前で、タスクがなければ話題が関わるプロジェクトの名前 |
| `threads/memo.md` | `Memo` | |
| `threads/template.md` | `Template` | |

- どれにも当てはまらないノートを作るときは、作る前にオーナーに `type` の追加を提案する。
- `type` の追加が承認されたら、`frontmatter-schema.yaml` の `types`・`layers`・`paths` を同じ commit で直し、この表に行を足す karo の直しをオーナーに伝える（この表は karo の skill にあり、`~/cos` の commit には入らない）。

## 1. ノートを作る

1. 置き場所から `type` を決め、上の 2 つの表と `frontmatter-schema.yaml` の必須のフィールドを埋めたフロントマターを、ファイルの 1 行目から書く。続けて空行、`## ` の見出しで本文を始める（threads は発言の `### ` の見出しから始める）。threads は、本文を `threads/template.md` から写し、フロントマターはこの規則から書く（template の `type: Template` は写さない）。
   完了条件: 1 行目が `---` で、必須のフィールドがすべて値を持つ。
2. ノートを書く。いつ誰が検証するかは、下の「4. 検証」の指す `karo:information-design` skill の「6. 検証」にある。
   完了条件: record が `queued` を出したか、「4. 検証」が 0 件。

## 2. 追記したとき・状態が変わったとき

| 出来事 | 直すフィールド |
| --- | --- |
| standup・threads に追記した | なし |
| 決定を新しい決定で置き換えた | なし（`bd supersede`。`karo:beads` skill の「判断待ちと決定」） |
| 下書きが仕上がった | `status: draft` の行を消す |
| 調査や資料が新しいものに置き換わった | 古いほうに `status: deprecated` |
| `stale_after` を過ぎた調査を確かめ直した | 新しい日時にするか、`status: deprecated` |
| ノートが別のタスクにも使われるようになった（thread なら、その話題で新しいタスクを作ったか、派生タスクの会話を書いた） | `tasks` にそのタスク ID を足す |
| タスクの状態・優先度・担当が変わった | なし（`bd` で変える。`karo:beads` skill） |

- 表の出来事が起きたら、`~/cos/AGENTS.md` の「記録の更新」の書き込みの指示の中でフィールドを直し、同じ commit に入れる。完了条件: 表の右の列のフィールドを直す項目が、その指示に入っている。

## 3. 決まりに合わないノートを見つけたとき

1. 「4. 検証」で、問題のあるノートの一覧を出す。
   完了条件: 問題ごとにパスと中身が一覧にある。
2. ファイル名と置き場所で決まるもの（`type`、journal（standup と MTG を含む）・investigations・threads の `date`、`tasks` から決まる `projects`）の直し方を決める。
   完了条件: 一覧のその種類の問題のすべてに、直す値がある。
3. 判断が要るもの（`description`、threads の `description`・`topic`・`tasks`、`projects`、`derived_from`、置き場所の決まらないノートの `type`）は本文を読んで、埋める値を決める。
   完了条件: 一覧の問題のすべてに、直す値がある。
4. 2 と 3 で決めた直しを 1 つの指示にまとめて record で書く（record が変えたノートとそれに関係するノートを検査してから commit する）。どの規則に合わせたかと、判断で埋めた値の根拠は、同じ指示の `commit 本文:` に書く。サブエージェントや Agent が直接直したノートの渡し方は `karo:record` skill の「走らせる」にある。
   完了条件: record が `queued` を出した。

- ほかの道具が書いたキーは、消さずにそのまま残す。

## 4. 検証

- `karo:information-design` skill の「6. 検証」を実行する。完了条件: `karo-check: 0 problem(s)` が出て、終了コードが 0。
