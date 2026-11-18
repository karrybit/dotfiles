---
name: frontmatter
description: '$KARO_HOME のノートのフロントマター（type、項目の埋め方、置き場所）の書き方と、状態が変わったときに直すフィールド。ノートを作る・直すとき、フロントマターを書くとき、karo-check がフロントマターの問題を出したときに使う。'
user-invocable: false
---

# 記録のフロントマター

- `$KARO_HOME` の記録のフォルダ（`$KARO_HOME/AGENTS.md` の「書き込み先」の表のフォルダ）のノートは、1 行目から OKF（Open Knowledge Format v0.2）の YAML フロントマターを持つ。
- 層・鮮度の考え方（何をいつ書くか）は `karrybit:data-information-design` skill にあり、この skill は karo のフィールドの書き方を持つ。
- 種類ごとの必須のフィールドと置き場所は `$KARO_HOME/rule/frontmatter-schema.yaml` が正本で、`~/.config/claude/skills/karo/scripts/karo-check` がそれで確かめる。schema のキー（`types`・`layers`・`paths`・`exclude`）の意味は `karrybit:okf-lint` skill の「schema の形」にある。
- 対象はこれらのフォルダの `.md` すべてで、対象にしないものは `frontmatter-schema.yaml` の `exclude` にある（imozuru が書く `investigation/YYYY-MM-DD-<話題>/sources/` の原文など）。

## フィールド

| フィールド | 書き方 |
| --- | --- |
| `type` | 下の表の値 |
| `description` | 1 文の要約。ファイル名の言い換えでなく、中身の結論か目的を書く |
| `date` | `YYYY-MM-DD`、引用符なし。ノートの日（standup の日、決めた日、MTG の日、調べた日） |
| `tasks` | タスク ID のブロック形式のリスト（`  - karo-a2v`）。タスク ID のない仕事は外のチケットのキー（`ABC-123`） |
| `projects` | プロジェクトの名前のブロック形式のリスト。値は Project のノートの、`project/repo/` か `project/misc/` より後ろのパスから `.md` を除いたもの（`github.com/acme/demo`、`work`） |
| `status` | 下書きは `draft`、置き換わったものは `deprecated`。仕上がったものには書かない |
| `resource` | ノートが表す実物の URL（リポジトリ、PR） |
| `sources` | `- { id, resource, title }` のリスト。外の原文（議事録、Slack、資料、ドキュメント）の URL |
| `stale_after` | 見直しの日時。`2026-12-05T00:00:00+09:00` |

- ほかの道具が書いたキーは、消さずにそのまま残す。
- 値が `` ` ``・`[`・`*`・`&`・`!`・`|`・`>`・`'`・`"`・`%`・`@` で始まるとき、`: ` か ` #` を含むときは、値を単一引用符で囲む。
- フロントマターのあとに空行を置き、本文を `## ` の見出しから始める。

## 種類

| 置き場所 | `type` | 埋め方 |
| --- | --- | --- |
| `standup/YYYY-MM-DD.md` | `Standup` | `date` はファイル名。`tasks` は報告で挙げたタスク |
| `project/repo/<vcs>/<org>/<repo>.md`、`project/misc/<theme>.md` | `Project` | `resource` はリポジトリの URL（`misc/` は書かない）。`<vcs>/<org>/<repo>` は `resource` の URL のホストとパスで、リモートのないリポジトリは `local/<owner>/<repo>`。`projects` は自分の名前 |
| `project/misc/<theme>/YYYY-MM-DD-<資料名>.md` | `Playbook` | 下書きのあいだは `status: draft` |
| `project/design/YYYY-MM-DD-design-doc-<話題>.md` | `Design Doc` | `date` はファイル名。`status` は書かない |
| `project/repo/<vcs>/<org>/<repo>/review/` | `Review` | `tasks` はファイル名のタスク ID。`resource` はレビューした PR |
| `source/meeting/YYYY-MM-DD-<MTG>.md` | `Meeting Notes` | 1 つのファイルに 1 つの MTG だけを置き、本文の `## ` の見出しの 1 つをその MTG の名前にする。`sources` には、その MTG の議事録と資料だけを、1 つずつ URL と名前で書く |
| `investigation/YYYY-MM-DD-<話題>.md` | `Investigation` | `sources` に読んだ外の原文 |
| `doc/<話題>.md` | `Document` | `sources` に外の元の資料 |
| `investigation/YYYY-MM-DD-<話題>/map.md` | `Research Map` | `description` は `題:` のあとの文（`題:` は付けない） |

- どれにも当てはまらないノートの `type` の追加をオーナーが承認したら、`frontmatter-schema.yaml` の `types`・`layers`・`paths` を同じ commit で直し、この表に行を足す karo の直しをオーナーに伝える（この表は karo の skill にあり、`$KARO_HOME` の commit には入らない）。

## 追記したとき・状態が変わったとき

| 出来事 | 直すフィールド |
| --- | --- |
| standup に追記した | なし |
| 決定を新しい決定で置き換えた | なし（`bd supersede`。`karo:tasks` skill の「判断待ちと決定」） |
| 下書きが仕上がった | `status: draft` の行を消す |
| 調査や資料が新しいものに置き換わった | 古いほうに `status: deprecated` |
| ノートが別のタスクにも使われるようになった | `tasks` にそのタスク ID を足す |
| タスクの状態・優先度・担当が変わった | なし（`bd` で変える。`karo:tasks` skill） |

- 表の出来事が起きたら、`$KARO_HOME/AGENTS.md` の「記録の更新」の書き込みと一緒にフィールドを直し、同じ commit に入れる。完了条件: 表の右の列のフィールドを直したファイルが、その commit に入っている。
