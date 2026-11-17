---
max_turns: 60
timeout_seconds: 1800
allowed_tools: [Read, Glob, Grep, Skill, Agent, Bash, Write, Edit]
tags: [implementation]
---

このリポジトリに、インクリメント I-2「export の取り出し」を実装してほしい。

- 目的: テナントの owner と admin が、自分のテナントの export の状態を見られるようにする。
- 関わる要求:
  - AC-1: 自分のテナントの `export_id` を指定すると、その export が返る。
  - AC-2: 存在しない `export_id` を指定すると `NotFound` になる。
- 設計の制約: `docs/design/export-download.md` の C1〜C3 と INV-1。関数は `app/exports.py` の `get_export(store, session, tenant_id, export_id)`。
- 今回の範囲: 触ってよいのは `app/exports.py` と `tests/` だけ。
- 確かめる条件: `python3 -m unittest discover -s tests -t .` が通る。

commit はせず、変更は作業ツリーに残して。終わったら、何をしてどう確かめたかを報告して。

この仕事は karrybit:implementer の Agent に頼み、返ってきた報告を手を加えずにそのまま最後の返事にして。その Agent を使えなければ、自分で行って同じように報告して。
