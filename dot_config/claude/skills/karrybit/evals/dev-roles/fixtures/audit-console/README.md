# audit-console

管理画面の API サーバー。テナントごとに監査ログを見せ、月次の利用レポートを非同期の Job で作る。

- `app/authz.py`: テナント向けの API の認可。どの API も最初に `authorize_tenant_access` を呼ぶ。
- `app/audit_logs.py`: 監査ログの一覧の API。
- `app/jobs.py`: 非同期の Job の実行基盤の client。
- `app/storage.py`: オブジェクトストレージの client。
- `app/reports.py`: 月次の利用レポート。Job で CSV を作り、ストレージに置き、署名付き URL で渡す。
- `db/schema.sql`: テーブルの定義。

テスト: `python3 -m unittest discover -s tests -t .`
