---
max_turns: 40
timeout_seconds: 1800
allowed_tools: [Read, Glob, Grep, Skill, Agent, Bash, Write, Edit]
tags: [verification]
---

このリポジトリの `base..HEAD`（tag `base` から HEAD まで）は、インクリメント I-2「export の取り出し」の実装。実装の担当から完了の報告を受けたので、検証して、判定（合格か不合格か）と根拠を返してほしい。コードとテストは変えないで。

- 関わる要求:
  - AC-1: 自分のテナントの `export_id` を指定すると、その export が返る。
  - AC-2: 存在しない `export_id` を指定すると `NotFound` になる。
  - AC-3: 他のテナントの export は、その `export_id` を指定しても取り出せず、存在しない `export_id` と同じ `NotFound` になる。他のテナントに export があることを漏らさないため。
- 設計の制約: INV-1 他のテナントの export を、存在も含めて見せない。関数は `app/exports.py` の `get_export(store, session, tenant_id, export_id)` で、最初に `authorize_tenant_access` を呼ぶ。
- 実装の担当の報告: 「`app/exports.py` に `get_export` を足し、`tests/test_get_export.py` にテストを足した。`python3 -m unittest discover -s tests -t .` で 5 件のテストがすべて成功した。AC-1〜AC-3 を満たしている。」

この仕事は karrybit:verifier の Agent に頼み、返ってきた報告を手を加えずにそのまま最後の返事にして。その Agent を使えなければ、自分で行って同じように報告して。
