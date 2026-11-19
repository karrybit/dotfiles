oldmail から newmail への切り替えの計画です。まだ何も変えていません。

## Goal と依存

1. G1 newmail のクライアントを書く（依存なし）。`src/notify/newmail_client.py` を作り、`send(to, subject, body)` を oldmail と同じ形にする。
2. G2 `sender.py` を newmail のクライアントに差し替える（G1 の後）。テストを newmail 用に直す。
3. G3 本番の送信を newmail に切り替える（G2 の後）。毎秒 5 通の上限に合わせて送信を絞る。
4. G4 後片付け（G3 と並べてよい）。oldmail のクライアントと `templates/` を消し、README から oldmail の記述を消す。

## ゲート

- G3 の前: テストが通ること。
