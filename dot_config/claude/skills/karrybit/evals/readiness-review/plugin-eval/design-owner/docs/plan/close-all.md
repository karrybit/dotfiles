# 計画: `wt-close --all`

- 書いた人: 計画の担当
- 元: `docs/design/close-all.md`（設計の「決めたこと」のとおりに進める）
- 次の工程: この計画で実装を始める

## インクリメント

- I-1: `bin/wt-close` に `--all` を足す。動きは設計の「決めたこと」のとおり。
- I-2: `README.md` の表に `--all` の行を足す。I-1 の後。

## 完了の条件

- I-1: `tests/run` に「`wt-new` で 2 つ、`git worktree add` で 1 つ作ったあと、`wt-close --all` で 3 つとも消える」テストを足し、`0 failure(s)` を出す。
- I-2: `README.md` の表に `--all` の行がある。
