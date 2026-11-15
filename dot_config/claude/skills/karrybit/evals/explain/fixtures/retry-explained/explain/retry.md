# retry の説明

- 元の資料: このリポジトリの `retry.py` と `README.md`（`HEAD` の commit。`git show HEAD:<path>` で読む）
- 読み手と使い道: retry を使い始める開発者が、何が再試行され、いつ諦めるかを掴んで呼び出し側の例外処理を書く
- 頼まれた内容: retry の仕組みを、使い始める開発者向けに説明してほしい

## 全体像

retry は、渡された関数を呼び、一時的な失敗のときだけ待ってから呼び直す。待つ時間は試すたびに倍の上限まで伸び、その範囲で乱数で決まる。3 回とも失敗すると、最後の例外を持つ `RetryError` を上げる。

中心の概念:

- 試行: `call()` を 1 回呼ぶこと。1 回の `retry` で最大 3 回（`retry.py:5`、`retry.py:28`）。責務は結果か例外を返すこと。待ち時間は受け持たない。
- 再試行の対象の例外: `retry_on` に入る例外。既定は `ConnectionError` と `TimeoutError`（`retry.py:23`）。ほかの例外は再試行しない。
- 待ち時間: 失敗した試行のあとに眠る秒数。0 から `min(8.0, 0.5 * 2**attempt)` の一様な乱数（`retry.py:18-20`）。
- `RetryError`: 最後の試行も失敗したときに上がる例外。`last` に最後の例外を持つ（`retry.py:10-15`）。

似た名前の区別: `RetryError` は諦めたことを表し、`retry_on` に入らない例外はそのまま上がるので `RetryError` にならない（`retry.py:26`、`retry.py:31-33`）。

関係:

- `retry` —呼ぶ→ `call`（呼び出し。`retry.py:30`）
- `retry` —呼ぶ→ `backoff`（呼び出し。`retry.py:34`）
- `RetryError` —持つ→ 最後の例外（包含。`retry.py:15`）
- `retry_on` —決める→ 再試行するか（因果。`retry.py:31`）

動き:

1. `call()` を呼ぶ。返れば、その値を返して終わる（`retry.py:30`）。
2. `retry_on` に入らない例外なら、そのまま上がって終わる（`retry.py:26`）。
3. `retry_on` に入る例外で、最後の試行なら `RetryError` を上げて終わる（`retry.py:32-33`）。
4. それ以外は `backoff(attempt)` 秒眠り、1 に戻る（`retry.py:34`）。

この文書が答える問い:

- [どの例外が再試行されるか](#再試行の対象)
- [いつ諦めて何が上がるか](#諦めるとき)
- [試行の間にどれだけ待つか](#待ち時間)

## 再試行の対象

再試行されるのは `retry_on` に入る例外だけで、既定は `ConnectionError` と `TimeoutError`。

- `retry_on=` で組を替えられる（`retry.py:23`、`README.md:16-17`）。
- ほかの例外は 1 回目でもそのまま上がる（`retry.py:26`）。

## 諦めるとき

3 回目の試行も `retry_on` の例外で失敗すると、`RetryError` を上げる。

- `RetryError.last` は 3 回目の例外で、`raise ... from exc` で元の例外もつながる（`retry.py:15`、`retry.py:33`）。
- 3 回目のあとには眠らない（`retry.py:32-34`）。

## 待ち時間

試行 `attempt`（0 から数える）のあとに、0 から `min(8.0, 0.5 * 2**attempt)` 秒の乱数だけ眠る。

- 1 回目のあとは 0〜0.5 秒、2 回目のあとは 0〜1 秒（`retry.py:20`）。試行が 3 回なので、8 秒の上限には届かない（推論。`retry.py:5`、`retry.py:7`）。
- `sleep=` で眠る関数を替えられる（`retry.py:23`、`README.md:22`）。

## 参照

値と、確かめられなかったことの一覧。

### 値

| 名前 | 値 | 出典 |
| --- | --- | --- |
| `MAX_ATTEMPTS` | 3 | `retry.py:5` |
| `BASE_DELAY` | 0.5 | `retry.py:6` |
| `MAX_DELAY` | 8.0 | `retry.py:7` |

### 食い違いと確かめられなかったこと

この版の資料どうしと、資料と実物の食い違いはない。

- テストがないため、乱数の分布は `random.uniform` の呼び出しから読んだだけで、動かして確かめていない（未確認。`retry.py:20`）。
