3 つの変更の分け方です。まだ誰にも任せていません。

## 読んだ事実

- (a) と (b) は、どちらも `src/reports/handler.py` の `parse_query` と `handle`、`openapi.yaml` の `/reports` のパラメータを変える。DAG では独立だが、同じファイルを変えるので競合する。
- (c) は `docs/guide.en.md` を新しく作るだけで、(a)・(b) のファイルに触らない。

## 進め方

1. すぐ始める: Agent C が (c) の英訳。Agent A が契約の Goal として、`openapi.yaml` に `format`・`limit`・`cursor` の 3 つのパラメータを決めて書き、`parse_query` がそれを受け取るところまでを 1 つの commit にする。
2. 契約の commit が取り込まれてから: Agent A が (a) の CSV の出力、Agent B が (b) のページングを並べて進める。触るのは、A が `serialize` と CSV 用の関数、B が `store.py` の `load_rows` と `handle` のページング部分。`handle` は B だけが変え、A は `handle` から呼ばれる関数を足すだけにする。
3. 合流: (a) と (b) は私が取り込み、`format=csv` と `limit`・`cursor` を同時に使う場合のテストを流してから終える。(c) は単独で取り込む。英語のガイドへの新しいパラメータの追記は、合流の後の別の作業にする。
