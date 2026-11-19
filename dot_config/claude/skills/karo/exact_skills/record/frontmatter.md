# 記録のフロントマター

記録のノートを作るとき、ノートのフロントマターを書くか直すとき、karo-check がフロントマターの問題を出したとき、調べ物の依頼にノートの規則として渡すときに読む。

- `$KARO_HOME` の記録のフォルダ（この skill の `SKILL.md` の「書き込み先」の表のフォルダ）のノートは、1 行目から OKF（Open Knowledge Format v0.2）の YAML フロントマターを持つ。
- 層・鮮度の考え方（何をいつ書くか）は `karrybit:data-information-design` skill にあり、このファイルは karo のフィールドの書き方を持つ。
- どのノートも `date` と `description` を持つ。`type`・`tasks`・`projects` は任意で、`tasks` と `projects` はノートを作るきっかけになったタスクとプロジェクトを `rg` で引けるように、あれば書く。
- 必須のフィールドの正本は karo plugin の `scripts/frontmatter-schema.yaml` の `required`（karo-check が読む。`$KARO_HOME` に schema のファイルがあっても読まない）。種類ごとの必須と置き場所は検査しない。
- `~/.config/claude/skills/karo/scripts/karo-check` が、必須のフィールド、`date` の形、あれば `tasks` の ID の形と `projects` の名前、リンク、wiki link を確かめる。確かめることの範囲は `scripts/karo-check` の冒頭にある。
- 対象はこれらのフォルダの `.md` すべてで、対象にしないものは `frontmatter-schema.yaml` の `exclude` にある（imozuru が書く `investigation/YYYY-MM-DD-<話題>/sources/` の原文など）。

## フィールド

| フィールド | 書き方 |
| --- | --- |
| `description` | 必須。1 文の要約。ファイル名の言い換えでなく、中身の結論か目的を書く |
| `date` | 必須。`YYYY-MM-DD`、引用符なし。ノートの日（standup の日、決めた日、MTG の日、調べた日、Project のノートを作った日） |
| `type` | 任意。下の「種類」の表の値 |
| `tasks` | 任意。タスク ID のブロック形式のリスト（`  - karo-a2v`）。タスク ID のない仕事は外のチケットのキー（`ABC-123`） |
| `projects` | 任意。プロジェクトの名前のブロック形式のリスト。値は Project のノートの、`project/repo/` か `project/misc/` より後ろのパスから `.md` を除いたもの（`github.com/acme/demo`、`work`） |
| `status` | 下書きは `draft`、置き換わったものは `deprecated`。仕上がったもの（Accepted の Decision Record を含む）には書かない |
| `supersedes` | 置き換えた古いノートの、`$KARO_HOME` からのパス |
| `resource` | ノートが表す実物の URL（リポジトリ、PR） |
| `sources` | `- { id, resource, title }` のリスト。外の原文（議事録、Slack、資料、ドキュメント）の URL |
| `stale_after` | 見直しの日時。`2026-12-05T00:00:00+09:00` |

- ほかの道具が書いたキーは、消さずにそのまま残す。
- 値が `` ` ``・`[`・`*`・`&`・`!`・`|`・`>`・`'`・`"`・`%`・`@` で始まるとき、`: ` か ` #` を含むときは、値を単一引用符で囲む。
- フロントマターのあとに空行を置き、本文を `## ` の見出しから始める。

## 種類

置き場所ごとの `type` の値と埋め方の目安。karo-check は種類と置き場所を確かめない。

| 置き場所 | `type` | 埋め方 |
| --- | --- | --- |
| `standup/YYYY-MM-DD.md` | `Standup` | `date` はファイル名。`tasks` は報告で挙げたタスク |
| `project/repo/<vcs>/<org>/<repo>.md`、`project/misc/<theme>.md` | `Project` | `resource` はリポジトリの URL（`misc/` は書かない）。`<vcs>/<org>/<repo>` は `resource` の URL のホストとパスで、リモートのないリポジトリは `local/<owner>/<repo>`。`projects` は自分の名前 |
| `project/misc/<theme>/YYYY-MM-DD-<資料名>.md` | `Playbook` | 下書きのあいだは `status: draft` |
| `project/design/YYYY-MM-DD-design-doc-<話題>.md` | `Design Doc` | `date` はファイル名。`status` は書かない |
| `project/repo/<vcs>/<org>/<repo>/review/` | `Review` | 今までのレビューの原本で、新しくは作らない（レビューの要旨は Beads の comment に書く。`karo:review` skill）。`tasks` はファイル名のタスク ID。`resource` はレビューした PR |
| `decisions/YYYY-MM-DD-<話題>.md` | `Decision Record` | `description` は決定の名前になる 1 文。`date` はファイル名の日（決めた日）。`projects` は `$KARO_HOME` 自身の Project のノートの名前。本文の節は `SKILL.md` の「Decision Record を書く」 |
| `source/meeting/YYYY-MM-DD-<MTG>.md` | `Meeting Notes` | 1 つのファイルに 1 つの MTG だけを置き、本文の `## ` の見出しの 1 つをその MTG の名前にする。`sources` には、その MTG の議事録と資料だけを、1 つずつ URL と名前で書く |
| `investigation/YYYY-MM-DD-<話題>.md` | `Investigation` | `sources` に読んだ外の原文 |
| `doc/<話題>.md` | `Document` | `sources` に外の元の資料 |
| `investigation/YYYY-MM-DD-<話題>/map.md` | `Research Map` | `description` は `題:` のあとの文（`題:` は付けない） |

- どれにも当てはまらないノートは、`type` を書かずに `date` と `description` だけで書いてよい。

## 追記したとき・状態が変わったとき

| 出来事 | 直すフィールド |
| --- | --- |
| standup に追記した | なし |
| 決定を新しい決定で置き換えた | Decision Record は、新しいほうに `supersedes`、古いほうに `status: deprecated` と、`## 状態` の節の `Superseded` の行。Beads の決定は直すフィールドなし（`bd supersede`。`karo:tasks` skill の「判断待ちと決定」） |
| 下書きが仕上がった | `status: draft` の行を消す |
| 調査や資料が新しいものに置き換わった | 古いほうに `status: deprecated` |
| ノートが別のタスクにも使われるようになった | `tasks` にそのタスク ID を足す |
| タスクの状態・優先度・担当が変わった | なし（`bd` で変える。`karo:tasks` skill） |

- 表の出来事が起きたら、この skill の `SKILL.md` の「記録の更新」の書き込みと一緒にフィールドを直し、同じ commit に入れる。表の右の列のフィールドを直したファイルを、その commit のパスに並べる。
