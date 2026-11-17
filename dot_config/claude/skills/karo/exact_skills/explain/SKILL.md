---
name: explain
description: 'HTML の解説を git の外の store（`$KARO_DATA_HOME/html/<UUID>/` の index.html と metadata.json）に置く手順。metadata.json を jq で探して既存の解説を渡すか決め、作る部分は karrybit:explain に書き先と metadata.json の規則を渡して任せる。オーナーが資料・リポジトリ・仕組みの解説を HTML で頼んだとき、前の解説を開きたいとき、作り直しを頼んだときに、karrybit:explain の代わりに使う（この skill が karrybit:explain を呼ぶ）。'
---

# HTML の解説を store に置く

- HTML の解説は、1 ファイルの HTML で資料や仕組みを解説するもの。1 つの解説は store の `<root>/<id>/` のフォルダで、`index.html` と `metadata.json` を持つ。store は git の外にある。
- この skill は、karo の運用（store の場所、id、`metadata.json`、探し方、置き方）だけを持つ。作り方、評価のしかた、依頼の型を直すときは `karrybit:explain` skill にある。
- 下の `<karo-check>` は `~/.config/claude/skills/karo/scripts/karo-check` で、この `~/` の形のまま書く。

## store

- root は次の式で出す（`KARO_DATA_HOME` が未設定か空なら `${XDG_DATA_HOME:-$HOME/.local/share}/karo` の下）。

  ```sh
  root=${KARO_DATA_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/karo}/html
  ```

- id は `uuidgen | tr A-Z a-z` の小文字の UUID だけにする。解説を作るたびに新しい id を出す（作り直しと、既存の解説の更新も新しい id にする）。
- 完成した解説は、`metadata.json` のある `<root>/<id>/` だけ。作るあいだは root の中の隠しフォルダ `<root>/.tmp.XXXXXX` に置き、`metadata.json` を最後に書き、検査が通ってから `mv` で `<root>/<id>` に置く。
- Bash のシェルの変数は次の呼び出しに残らないので、手順で出した root・id・一時フォルダは、出力された絶対パスの値で次のコマンドに書く。

## metadata.json

- 必須は `id`（フォルダ名と同じ UUID）、`title`（解説の題）、`source`、`created_at`（`date -Iseconds` の出力の形。`2026-01-01T09:00:00+09:00`）。
- `source` は、元の資料が git の資料かどうかで次の 2 つの形のどちらかにする。
  - git の資料: `kind` は `git`。`repository` はリモートの URL（`git remote get-url origin`）で、リモートがなければ ghq の形の `local/<owner>/<repo>`。`path` はリポジトリの中の相対パス。`revision` は読んだ commit の 40 桁（`git rev-parse <commit>`）。
  - git でない資料: `kind` は資料の種類（`confluence`、`web` など）、`location` は URL、`version` はページの版の番号（取れたときだけ）。
- 任意は、`tasks`（解説を頼まれたタスク ID）、`projects`（`karo:frontmatter` skill の `projects` の行の値）。
- 入れるのは上の項目の値だけにする。HTML の本文、絶対パス、秘密、個人名は入れない。

<example>

```json
{
  "id": "0f6c7d9e-3b1a-4c52-9e34-5a8d1b7c2e40",
  "title": "demo のデプロイの手順",
  "created_at": "2026-01-01T09:00:00+09:00",
  "source": {
    "kind": "git",
    "repository": "https://github.com/acme/demo",
    "path": "doc/deploy.md",
    "revision": "0123456789abcdef0123456789abcdef01234567"
  },
  "tasks": ["t-test0001"],
  "projects": ["github.com/acme/demo"]
}
```

</example>

- 検査のコマンドは次のとおり。出力が `true` で終了コードが 0 なら通る。

  ```sh
  jq -e --arg id '<id>' '.id == $id and (.title | type == "string") and (.created_at | test("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}[+-][0-9]{2}:[0-9]{2}$")) and (if .source.kind == "git" then (.source.repository | type == "string") and (.source.path | type == "string") and (.source.revision | test("^[0-9a-f]{40}$")) else (.source.kind | type == "string") and (.source.location | type == "string") end) and ([.. | strings | select(startswith("/"))] == [])' '<一時フォルダ>/metadata.json'
  ```

## 手順

1. 元の資料の `source` を上の「metadata.json」の 2 つの形で決め、同じ元の資料の解説を探す。呼び出し側が元の資料の場所・版を渡したときは、その値を使う。探すコマンドは、store の root の式に続けて次を走らせる（`fd` は隠しフォルダの `.tmp.*` を見ない）。

   ```sh
   mkdir -p "$root" && printf '%s\n' "$root" && fd -g metadata.json -d 2 "$root" -X jq -r --arg s '<repository か location>' 'select(.source.repository == $s or .source.location == $s) | [.id, .source.path // "", .source.revision // .source.version // "", .created_at, .title] | @tsv'
   ```

   - 版やタスクで探すときは、`select(...)` の中を `.source.revision == "<40 桁>"` か `any(.tasks[]?; . == "<タスク ID>")` に替える。

   完了条件: root の絶対パスと、同じ元の資料の解説の一覧（0 件もある）が出力にある。
2. 既存の解説を渡すか、新しく作るかを決める。
   - 同じ `source`（git の資料は `repository`・`path`・`revision`、git でない資料は `location`・`version`）の解説があり、オーナーが作り直しを頼んでいなければ、作らずにその `<root>/<id>/index.html` を渡す。
   - 版が違うとき、作り直しを頼まれたとき、既存の解説の更新を頼まれたときは、3 から新しい id の解説を作り、前の解説はそのまま残す。

   完了条件: 渡す既存の `index.html` の絶対パスか、新しく作ることが決まっている。
3. 新しく作るときは、`id=$(uuidgen | tr A-Z a-z) && tmp=$(mktemp -d '<root>/.tmp.XXXXXX') && printf '%s\n' "$id" "$tmp" "$(date -Iseconds)"` で id、一時フォルダ、`created_at` を出す。
   完了条件: id、一時フォルダの絶対パス、`created_at` の 3 行が出力にある。
4. `karrybit:explain` skill を Skill tool で呼び、その手順を最後まで進める。渡す値は次のとおり。
   - HTML の書き先: `<一時フォルダ>/index.html`。
   - 控えのファイル: `<一時フォルダ>/metadata.json`。書き方の規則は上の「metadata.json」。入れる値は、3 の id と `created_at`、1 の `source`、頼まれたタスクとプロジェクトで、`title` は HTML の題にする。検査は上の「metadata.json」の検査のコマンド。
   - 説明の文書の書き先: オーナーが説明の文書も残すよう頼んだときだけ渡す。書き先は `$KARO_HOME/doc/<話題>.md`、フロントマターは `karo:frontmatter` skill の種類の表の `Document` の行（sources は元の資料と版）、検査は `<karo-check> --only doc/<話題>.md`。`$KARO_HOME` の記録なので、書いたあとは `karo:record` skill に従う。
   - 頼まれた内容の原文: 頼まれた発言の本文と時刻。今のセッションにない過去の発言は、`$KARO_HOME/rule/information-design.md` の「探す」の表のとおり cass で引く。
   - 呼び出し側が元の資料の場所・版・読み方を渡したときは、それもそのまま渡す。

   完了条件: `karrybit:explain` の返事に、`<一時フォルダ>/index.html` と `<一時フォルダ>/metadata.json` の絶対パスがある。
5. 上の「metadata.json」の検査のコマンドを自分で走らせ、通ったら `[ ! -e '<root>/<id>' ] && mv '<一時フォルダ>' '<root>/<id>' && ls '<root>/<id>'` で置く。
   - 4 か 5 が通らないときは、一時フォルダをそのまま残し、そのパスと通らなかった内容をオーナーに伝える。

   完了条件: `ls` が `index.html` と `metadata.json` の 2 つを出した。

## 見せる

- オーナーが解説を見たいと言ったら、`~/.config/claude/skills/karo/scripts/view-open <root>/<id>/index.html <id の先頭 8 文字>` を単独の Bash で実行し、terminal-browser の `view - <id の先頭 8 文字>` の pane に開く。view-open は、新しい pane なら `<pane の ID> view - <名前>` を出し、右の terminal-browser の pane に tab として足したときはそう書いた 1 行を出す。オーナーが新しい pane で開きたいと言ったときだけ、`view-open --no-merge <パス> <名前>` で呼ぶ。
- オーナーが閉じてと言ったら、`herdr pane close <pane の ID>` を単独の Bash で実行して閉じる（中のブラウザも終わる）。pane の中の操作はオーナーに任せ、キーは送らない。
- view-open が 0 でない終了コードで終わったときと、オーナーが view-open の実行の確認を断ったときは、`index.html` のパスをオーナーに伝える。
