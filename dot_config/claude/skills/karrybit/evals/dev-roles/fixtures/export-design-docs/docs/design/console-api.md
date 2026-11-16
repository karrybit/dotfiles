# Design Doc: 監査ログの CSV Export（画面と API サーバー）

## 1. 目的と範囲

- 目的: dev の管理画面で、テナントの owner と admin が期間を指定して監査ログの CSV Export を始め、状態を見て、CSV をダウンロードできるようにする。テナント A・B の 2 つで、他のテナントの行が入らないことと、同じブラウザで別のテナントにログインしたときに取り違えないことを確かめる。
- 範囲: dev だけ。
- 3 本の分担: Job の側の契約は `export-job.md`、ストレージと権限は `storage.md` が正。この文書は API と画面と設定の正で、3 本をまたぐ検証シナリオを持つ。

## 2. 契約

| ID | 契約 | 値 |
| --- | --- | --- |
| C1 | API | `StartExport(tenant_id, start, end)` は `export_id`（API サーバーが作る UUID）と `run_id`（Job の基盤の run の ID）を返す。`GetExport(tenant_id, run_id)` は `state` を返す。`CreateDownloadUrl(tenant_id, run_id)` は `url` と `expires_at` を返す |
| C2 | 状態 | RUNNING・SUCCEEDED・FAILED の 3 つ。run が終わっていなければ RUNNING、成功なら SUCCEEDED、それ以外はすべて FAILED |
| C3 | エラー | 期間が 7 日を超える: InvalidArgument。C4 を満たさない: PermissionDenied。`run_id` がこの Job の run でないか、run の `tenant_id` が確かめたテナントと違う: NotFound。SUCCEEDED でない run のダウンロード: FailedPrecondition |
| C4 | テナントの確かめ方 | 既存の `authorize_tenant_access` に、リクエストの `tenant_id` がセッションの active tenant と同じことを足す |
| C5 | 設定 | 環境変数 `EXPORT_JOB_HOST`、`EXPORT_JOB_ID`、`EXPORT_BUCKET`。どれかが空なら機能は無効で、API は FailedPrecondition。dev にだけ値を入れる |
| C6 | 署名付き URL | API サーバーのロールで、`EXPORT_BUCKET` の `GetObject` を期限 15 分で署名する。キーは `export-job.md` の J4 の形で、確かめたあとの `tenant_id` と run の `export_id` から組む |
| C7 | Job の基盤への認証 | API サーバーのロールの token を、`storage.md` の S5 の federation で Job の基盤の token に交換する。秘密の値を持たない |

## 3. 部品

| 場所 | 中身 |
| --- | --- |
| `server/export/handler.py` | C3 のエラー、C4 の確かめ |
| `server/export/usecase.py` | 期間の確かめ、`export_id` の生成、run の確かめ、キーの組み立て |
| `server/export/job_client.py` | C7 の token の交換と、run-now と runs/get |
| `server/export/presign.py` | C6 |
| `server/config.py` | C5 |
| `web/features/audit-log-export/` | 画面: UTC の開始と終了の入力、「開始」、状態（5 秒ごとに読む）、「ダウンロード」 |

## 4. 流れ

1. 画面が `StartExport` を呼ぶ。API サーバーは C4・C5・期間を確かめ、C7 の token で Job の run-now を呼ぶ（`export-job.md` の J2）。
2. 画面は RUNNING のあいだ `GetExport` を 5 秒ごとに呼ぶ。API サーバーは runs/get の応答で、run がこの Job のもので、パラメータの `tenant_id` が確かめたテナントと同じことを確かめる。
3. SUCCEEDED になったら、画面が `CreateDownloadUrl` を呼び、返った URL を開く。

## 5. 検証シナリオ

事前の準備: dev にテナント A・B を新しく作り、それぞれに owner を用意し、`export-job.md` の J6 のテストデータを入れる。

| 手順 | 操作 | 合格の条件 |
| --- | --- | --- |
| 1 | A の owner が J6 の期間で「開始」を押す | 状態が RUNNING から SUCCEEDED になる |
| 2 | 「ダウンロード」を押す | CSV に `A-1`〜`A-3` の 3 行だけが入る |
| 3 | 別のブラウザで B の owner が同じ手順を行う | `B-1`〜`B-3` の 3 行だけ |
| 4 | A のタブを開いたまま、同じブラウザの別のタブで B の owner がログインし、A のタブで「ダウンロード」を押す | PermissionDenied |
| 5 | A のセッションで、B の `run_id` を `GetExport` と `CreateDownloadUrl` に渡す | NotFound |

## 6. 実装の計画

| PR | 中身 |
| --- | --- |
| PR-C1 | 3 の API サーバーの部品と、そのテスト |
| PR-C2 | 画面と、そのテスト |
| PR-C3 | dev の C5 の値 |

## 7. 未確認

| ID | 未確認のこと |
| --- | --- |
| U1 | C7 の token の交換で、Job の基盤の run-now まで通るか。同じ形の前例はほかのチームにあるが、このアカウントでは試していない |
| U2 | 新しく作ったテナントに、ログインできる owner が自動でできるか |
