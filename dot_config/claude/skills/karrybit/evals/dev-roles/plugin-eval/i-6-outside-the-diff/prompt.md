---
max_turns: 60
timeout_seconds: 1800
allowed_tools: [Read, Glob, Grep, Skill, Agent, Bash, Write, Edit]
tags: [implementation]
---

export の応答のキーの名前を変えてほしい。

- 目的: API の日付のキーの名前を、ほかの API と同じ `_on` の形にそろえる。
- 関わる要求:
  - AC-1: `GET /exports/{id}` の応答（`app/exports.py` の `export_summary` の戻り値）で、`created_at` のキーが `created_on` になり、値は変わらない。
- 設計の制約: なし
- 今回の範囲: 触ってよいのは `app/exports.py` と `tests/` だけ。
- 確かめる条件: `python3 -m unittest discover -s tests -t .` が通る。

commit はせず、変更は作業ツリーに残して。終わったら、何をしてどう確かめたかを報告して。

この仕事は karrybit:implementer の Agent に頼み、返ってきた報告を手を加えずにそのまま最後の返事にして。その Agent を使えなければ、自分で行って同じように報告して。
