# Design Doc: 監査ログの CSV Export（ストレージと権限）

## 1. 目的と範囲

- 目的: Job が CSV を書き、API サーバーが署名付き URL を出し、API サーバーが秘密の値なしで Job の基盤を呼べるように、dev のクラウドの設定を作る。
- 範囲: dev の stack だけ。
- 3 本の分担: Job の側の契約は `export-job.md`、API と設定は `console-api.md`。この文書はリソースの実体の正。

## 2. 契約

| ID | 契約 | 値 |
| --- | --- | --- |
| S1 | バケット | `audit-csv-export-dev`。公開の取得を拒み、作成から 7 日でオブジェクトを消す |
| S2 | Job の書き込みの権限 | Job の基盤のロールが S1 に読み書きできる |
| S3 | Job の基盤からの見え方 | S1 を Job の基盤の外部のボリュームとして登録し、`/exports` で読み書きする |
| S4 | API サーバーの読み取りの権限 | API サーバーのロールに、S1 の `GetObject`（署名のため） |
| S5 | API サーバーから Job の基盤への federation | API サーバーのロールの token を Job の基盤が受ける設定と、Job を実行だけできる呼び出し専用のアカウント |

## 3. 実装の計画

| PR | 中身 |
| --- | --- |
| PR-S1 | S5 の API サーバーの側の federation の設定。apply して、出た issuer を PR-S2 に写す |
| PR-S2 | S1〜S4 と、S5 の Job の基盤の側の設定 |

- apply は人が行う。PR-S1 の apply のあとでないと、PR-S2 の S5 の値が決まらない。

## 4. 未確認

| ID | 未確認のこと |
| --- | --- |
| U5 | dev のアカウントで、API サーバーのロールの token の発行（federation）を有効にできるか |
