---
name: okf-lint
description: OKF（Open Knowledge Format）のフロントマターを持つ Markdown のノートのフォルダを、呼び出し側が渡す schema（YAML）に照らして確かめる scripts/okf-lint と手順。ノートを書いた・動かした・消したあとに確かめるとき、schema に合わないノートやぶら下がった参照の一覧がほしいときに使う。
---

# ノートのフォルダを schema で確かめる

## 範囲

- この skill は、フォルダの中のノートのフロントマター、置き場所、lineage、パスのリンクを、呼び出し側の schema に照らして確かめ、`stale_after` を過ぎたノートを知らせる。
- 呼び出し側は、schema のファイルと確かめるフォルダを渡す。
- schema で書けない呼び出し側の決まり（本文の行の形、ID の形、ファイルどうしの食い違いなど）は、呼び出し側が、okf-lint のあとに自分の script で確かめる。

## 呼び出し

```text
${CLAUDE_SKILL_DIR}/scripts/okf-lint [--only <パス>]... <schema> <フォルダ>
```

- okf-lint は bash、yq（mikefarah の v4）、fd、rg を使う。
- `--only` には、変えた・足した・消したファイルのフォルダからのパスを渡す（名前を変えたときは前と後の両方）。そのファイルと、そのファイルを読む検査を持つファイル（`derived_from` にそのパスを挙げたノート、消したファイルならそこへリンクするファイルと `supersedes` で指すノート）だけを確かめる。
- 問題ごとに `<パス><TAB><問題>`、`stale_after` を過ぎたノートごとに `<パス><TAB>stale since <stale_after>` を stdout に、件数を stderr の `okf-lint: <件数> stale note(s)` と `okf-lint: <件数> problem(s)` に出す。
- 終了コードは、問題がなければ 0、あれば 1、引数か schema の誤りは 2。`stale since` は問題に数えない。

## schema の形

| キー | 中身 |
| --- | --- |
| `types` | type の名前 → 必須のフィールドのリスト。`type` そのものはどの type でも必須 |
| `paths` | type → そのノートのフォルダからのパスが合う POSIX ERE。ない type はどこに置いてもよい |
| `layers` | type → `bronze`・`silver`・`gold`。ほかの値の type は層を比べない |
| `lineage` | `sources` か `derived_from` を持つべき type のリスト |
| `files` | フロントマターを持たないファイルのフォルダからのパス → 層 |
| `exclude` | 読まないパスの POSIX ERE のリスト |

<example>
```yaml
exclude:
  - '^logs/raw/'
types:
  Log: [date]
  Note: [date, description, owner]
  Guide: [description]
layers:
  Log: bronze
  Note: silver
  Guide: gold
paths:
  Log: '^logs/[0-9]{4}-[0-9]{2}-[0-9]{2}\.md$'
  Note: '^notes/[a-z][0-9]-[^/]+\.md$'
  Guide: '^guides/[^/]+\.md$'
lineage: [Note, Guide]
files:
  summary.md: gold
```
</example>

## 確かめること

- ノートは、`exclude` に合わない `.md` のうち、1 行目が `---` のものと、`paths` のどれかに合うもの。そのほかの `.md`（README など）と、fd が読み飛ばすファイル（隠しファイル、`.gitignore` に合うもの）は読まない。
- ノートごとに、次を問題にする。
  - フロントマターがない、YAML として読めない、`type` がない、`types` にない `type`、必須のフィールドが空。
  - `status` が `draft`・`stable`・`deprecated` のどれでもない。
  - `stale_after` が秒とオフセットを持つ ISO 8601 の日時（`2030-01-01T00:00:00+09:00`、`…Z`）でない。
  - パスがその type の `paths` に合わない。
  - `lineage` の type が `sources` も `derived_from` も持たない。
  - `derived_from` の項目（`#` から後ろは見ない）のファイルがない。項目の層がノートの層より上（`bronze` < `silver` < `gold`）。ノートの層は type の `layers`、フロントマターのないファイルの層は `files` で決まる。
  - `supersedes` のファイルがない。
- ノートと `files` のファイルの本文で、`[名前](<フォルダ>/<ファイル>)` の形で、最初の段がフォルダの直下のフォルダであるリンクの先がなければ問題にする。コードブロックとインラインコードの中、URL、`/` を含まない名前のリンクは読まない。
- `derived_from`、`supersedes`、本文のリンクのパスは、ノートの場所からでなく、渡したフォルダから読む。
- `stale_after` を過ぎていて `status` が `deprecated` でないノートは、`stale since` で知らせる。

## 手順

1. ノートを書いたか、動かしたか、消したら、変えたパスを `--only` に渡して okf-lint を走らせる。フォルダ全体を確かめるときは `--only` を付けない。
   完了条件: stderr に `okf-lint: <件数> problem(s)` の行がある。
2. 出た問題ごとに、ノートか、ノートを指すほうの `derived_from`・`supersedes`・リンクを直す。
   完了条件: 出た問題のすべてに直しがある。
3. 1 と同じ引数で走らせ直す。
   完了条件: `okf-lint: 0 problem(s)` が出て、終了コードが 0。

- `stale since` のノートは、中身を確かめ直して `stale_after` を新しい日時にするか、`status: deprecated` にする。
- okf-lint を直したときは、`${CLAUDE_SKILL_DIR}/scripts/okf-lint-test` を走らせ、`okf-lint-test: 0 failure(s)` を確かめる。
