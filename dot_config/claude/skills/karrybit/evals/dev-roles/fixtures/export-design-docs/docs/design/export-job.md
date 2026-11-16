# Design Doc: 監査ログの CSV Export（Job）

## 1. 目的と範囲

- 目的: dev で、画面から CSV をダウンロードするまでを一気通貫で確かめるために、Job の基盤に CSV Export Job の検証版を作る。
- 範囲: dev の Job の基盤に配る Job だけ。
- 3 本の分担: この文書が Job の側の契約の正。API と画面と検証シナリオは `console-api.md`、ストレージと権限は `storage.md`。

## 2. 契約

| ID | 契約 | 値 |
| --- | --- | --- |
| J1 | Job の名前 | `audit-csv-export` |
| J2 | run-now のパラメータ | `tenant_id`、`start`、`end`、`export_id`。`start` を含み `end` を含まない UTC の時刻。冪等のキーは `export_id` |
| J3 | 入力のテーブル | テナントごとの監査ログのテーブル `audit_log.tenant_<tenant_id>` |
| J4 | 出力のキーとファイル名 | `<tenant_id>/<export_id>/audit-log.csv`。1 回の要求で 1 ファイル |
| J5 | CSV の列（暫定） | `event_id`、`occurred_at`、`payload` の順。UTF-8、LF、1 行目はヘッダ |
| J6 | 検証用のテストデータ | テナント A・B のテーブルに、期間 `2026-11-10T00:00:00Z`〜`2026-11-11T00:00:00Z` の中の行を 3 行ずつ（`payload` に `"marker":"A-1"`〜`"A-3"`、`"B-1"`〜`"B-3"`）と、期間の外の行を 1 行ずつ（`A-out`、`B-out`）入れる |
| J7 | 状態 | Job は成功か失敗だけで終わる。成功した run にだけ J4 のファイルがある |

## 3. 部品

| ファイル | 中身 |
| --- | --- |
| `jobs/csv_export/params.py` | パラメータを確かめ、読めなければテーブルに触れる前に失敗する |
| `jobs/csv_export/export.py` | J3 から期間の行を読み、J5 の CSV を J4 に書く |
| `jobs/csv_export/main.py` | 入口 |
| `jobs/csv_export/job.yml` | Job の定義。dev の target だけ |

## 4. 実装の計画

| PR | 中身 |
| --- | --- |
| PR-J1 | 3 の部品とテスト（パラメータ、テーブルがない、期間の端、別のテナント、空の期間、形式） |

- Job を dev に配るのは人が CLI で行う。配ったあとの Job の ID を `console-api.md` の C5 に写す。

## 5. 未確認

| ID | 未確認のこと |
| --- | --- |
| U3 | テナントを作ったときに、J3 のテーブルが自動でできるか |
| U4 | Job から J4 のキーにファイルを書けるか（`storage.md` の S3 の権限で足りるか） |
