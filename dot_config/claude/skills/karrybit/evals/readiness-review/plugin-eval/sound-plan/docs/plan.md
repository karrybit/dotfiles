# 計画: ledger の branch 列をやめ、`wt-list` は今の branch を git から取る

- 書いた人: 計画の担当
- 次の工程: この計画で実装を始める

## 背景

- #3（`docs/issues.md`）: `wt-list` は ledger の 3 列目（作ったときの branch）を出すので、worktree の中で branch を変えると古くなる。R2 は今の branch を求める。
- 3 列目を読むのは `wt-list` だけ。`rg -n 'cut|awk' bin` の当たりは、`wt-close` が 1・2 列目、`wt-list` が 1・3 列目を読む箇所だけ。

## 決めたこと

- `wt-new` は、ledger に name と path の 2 列を書く。
- `wt-list` は、ledger の行ごとに path で `git -C <path> branch --show-current` を実行し、name と今の branch を出す。path がない行は、branch を `-` として出す。
- ledger は残す。`wt-close` は今のとおり、ledger にある worktree だけを消す（R1）。
- 前からある 3 列の行は、そのまま読む。`wt-close` と `wt-list` は 1・2 列目だけを読むため（R3）。
- 考えて採らなかった案: ledger をやめ、`git worktree list` から一覧を作る。人が作った worktree と見分けられず、R1 を守れないため。

## Goal

- G1: 上の変更を `bin/wt-new` と `bin/wt-list` に入れ、`tests/run` にテストを足す。

## 完了の条件

- `tests/run` が `0 failure(s)` を出す。`tests/run` には、今の 4 件（人が作った worktree を `wt-close` が残すテストを含む）に加えて、次のテストがある。
  - worktree の中で `git switch -c other` したあと、`wt-list` が `a<TAB>other` を出す。
  - 3 列の行が ledger にある worktree を、`wt-list` が今の branch で出し、`wt-close` が消せる。
