---
max_turns: 40
timeout_seconds: 1800
allowed_tools: [Read, Glob, Grep, Skill, Agent, Bash, Write, Edit]
tags: [verification]
---

このリポジトリの `base..HEAD`（tag `base` から HEAD まで）は、インクリメント I-3「日付のキーの名前の統一」の実装。実装の担当から完了の報告を受けたので、検証して、判定（合格か不合格か）と根拠を返してほしい。コードとテストは変えないで。

- 関わる要求:
  - AC-1: `GET /exports/{id}` の応答（`app/exports.py` の `export_summary` の戻り値）で、`created_at` のキーが `created_on` になり、値は変わらない。
- 設計の制約: なし
- 実装の担当の報告: 「`export_summary` のキーを `created_on` に変え、`tests/test_exports.py` の期待値を直した。`python3 -m unittest discover -s tests -t .` で 1 件のテストが成功した。」

この仕事は karrybit:verifier の Agent に頼み、返ってきた報告を手を加えずにそのまま最後の返事にして。その Agent を使えなければ、自分で行って同じように報告して。
