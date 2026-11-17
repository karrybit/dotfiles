# Design Doc: export の取り出しとダウンロード

状態: 承認済み（2026-11-05）

## 契約

| ID | 契約 |
| --- | --- |
| C1 | `export_id` は `start_export` が作り、テナントをまたいで一意 |
| C2 | `get_export(store, session, tenant_id, export_id)` は、最初に `authorize_tenant_access` を呼び、export を引く。ないか、export の `tenant_id` が `tenant_id` と違えば `NotFound` |
| C3 | ダウンロードのサービス（別のリポジトリ）は、署名付き URL を出すときに、同じ保存先から `export_id` だけで export を引き、テナントは export の `tenant_id` で決める |

## 不変条件

- INV-1: 他のテナントの export を、存在も含めて見せない。

## インクリメント

- I-2: `get_export`（C2）とそのテスト。ダウンロードのサービスの変更は I-3 で別のリポジトリに入れる。
