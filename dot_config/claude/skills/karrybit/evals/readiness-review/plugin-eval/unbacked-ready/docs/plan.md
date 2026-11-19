# 計画: ledger をやめ、`git worktree list` から一覧と片付けの対象を取る

- 書いた人: 計画の担当
- 次の工程: この計画で実装を始める

## 背景

- #3（`docs/issues.md`）: `wt-list` の branch が古くなる。ledger が作ったときの値を持ち続けるため。
- ledger は実際の worktree とずれうる。git は今ある worktree を `git worktree list --porcelain` で正しく返す。ledger と同じ情報が git から取れるので、ledger は要らない。

## 決めたこと

- `state/ledger.tsv` と、`bin/wt-lib` の `ledger_path` をなくす。
- `wt-list` は、`git worktree list --porcelain` のうち `.worktrees/` の下にある worktree の名前と、今の branch を出す。
- `wt-close <name>` は、`git worktree list --porcelain` に `.worktrees/<name>` があれば、それを消す。
- `wt-new` は ledger に書かない。

## Goal

- G1: 上の変更を `bin/` に入れる。
- G2: `README.md` を ledger のない形に直す。

## 完了の条件

- `rg -n ledger bin README.md` の当たりが 0 件。
- `tests/run` が `0 failure(s)` を出す。`tests/run` の「wt-close leaves a worktree a person created」は、人が作る worktree を `.worktrees/` の外（`../human`）に作る形に直す。人は `.worktrees/` の下に worktree を作らないため。
