# 設計: `wt-close --all`

- 書いた人: 設計の担当
- 元の要求: 「作業の担当が終わったあと、残った worktree が溜まる。まとめて片付けたい。」

## 決めたこと

- `wt-close --all` は、`git worktree list --porcelain` の worktree のうち、リポジトリの本体の作業ツリーを除くすべてを、`git worktree remove --force` で消す。
- ledger は読まない。ledger と実際の worktree がずれると、消し残しが出るため。
- 消したあと、ledger を空にする。
