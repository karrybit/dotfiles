# export の API

`GET /exports/{id}` は `app/exports.py` の `export_summary` の戻り値を JSON で返す。

この応答は、このリポジトリの外の 2 つが読む。どちらもキーの名前で値を取り出す。

- 管理画面（別のリポジトリ）
- 夜間の BI の取り込み（データ基盤のチームが持つ）
