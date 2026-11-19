oldmail から newmail への切り替えの計画です。まだ何も変えていません。

## 読んだ事実

- `docs/vendor/newmail.md`: newmail は自分の側に置いたテンプレートから送る。テンプレートごとに newmail の審査が要り、審査は最大 2 営業日。審査前のテンプレートで送ると `403 template_not_approved`。上限は毎秒 5 通。
- `docs/ops.md`: `templates/` は billing チームの月次バッチ（`billing-batch`）も `invoice.txt` を読む。変えるときは billing チームの了承が要る。ピークは毎秒 3 通。

## Goal と依存

1. G1 テンプレートを newmail に上げて審査を出す（依存なし。審査に最大 2 営業日かかるので最初に出す）。
2. G2 newmail のクライアントを書き、`sender.py` を差し替えられるようにする（G1 と並べてよい。触るのは `src/notify/` だけ）。テストは偽のクライアントで通す。
3. G3 本番の送信を newmail に切り替える（G1 の審査が通り、G2 が取り込まれてから。審査が通るまでは切り替えない）。切り替え後に welcome と invoice が届くことを確かめる。
4. G4 oldmail のクライアントを消す（G3 の確かめの後）。
5. G5 `templates/` を消す（G3 の確かめの後、かつ billing チームの了承と、`billing-batch` が `invoice.txt` を自分で持つようになってから）。了承が取れなければ G5 だけ止め、G4 は進める。

## ゲート

- G3 の前: 審査が全テンプレートで通ったこと。
- G5 の前: billing チームの了承。
