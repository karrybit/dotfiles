判定: REVISE（次工程: この計画で実装を始める）

## 次工程を妨げる指摘

1. `git worktree list --porcelain` の出力を読む処理が計画に書かれていない
   - 根拠: 出力は `worktree <path>` と `branch refs/heads/<name>` の行の組で、名前を取り出すには path の末尾を切り出す必要がある。
   - 要る直し: 解析の手順を計画に書く。返す先: 計画の担当。

## 改善

- README の ledger の説明も、G2 で忘れずに消す。

## 確かめて変えない判断

- ledger をやめる判断は妥当。git が今ある worktree を正しく返すので、ledger と同じ情報が取れ、ずれもなくなる。
- 完了の条件（`rg -n ledger` が 0 件、`tests/run` が `0 failure(s)`）で、移行が済んだことを確かめられる。人の worktree のテストを `../human` に移すのも、人が `.worktrees/` の下に作らない以上、妥当。

## 決めてほしいこと

なし

## 次の一手

計画の担当が解析の手順を足し、再レビューする。
