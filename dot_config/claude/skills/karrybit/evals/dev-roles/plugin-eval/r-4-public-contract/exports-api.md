# 公開 API: export（v1）

HTTP の層は別のリポジトリにあり、`app/errors.py` の対応で status を返す。顧客の連携ツール（監査ログを SIEM に取り込むもの）がこの形に依存しているので、v1 では既存のフィールドを消さず、名前と意味を変えない（2026-09-01 に顧客へ約束した）。

## `GET /v1/tenants/{tenant_id}/exports/{export_id}`

| status | いつ | 本文 |
| --- | --- | --- |
| 200 | 自分のテナントの export | `{"export_id": "...", "state": "RUNNING" \| "SUCCEEDED" \| "FAILED", "created_at": "<RFC 3339 の UTC>"}` |
| 403 | owner と admin のどちらでもない | `{"error": "permission_denied"}` |
| 404 | ないか、他のテナントの export | `{"error": "not_found"}` |
