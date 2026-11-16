# export-api

テナントごとの監査ログの export を受け付ける API の中身。HTTP の層は別のリポジトリにあり、ここは関数だけを持つ。

- `app/authz.py`: テナント向けの関数は、最初に `authorize_tenant_access` を呼ぶ。
- `app/store.py`: export の保存先（テストではメモリ）。
- `app/exports.py`: export の関数。
- `app/errors.py`: HTTP の層が 404 にする `NotFound` と、403 にする `PermissionDenied`。

テスト: `python3 -m unittest discover -s tests -t .`
