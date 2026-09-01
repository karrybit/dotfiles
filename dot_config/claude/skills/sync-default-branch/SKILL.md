---
name: sync-default-branch
description: リポジトリのデフォルトブランチに切り替えて `git pull` で最新化する。`clean_gone` などブランチ/worktree の後片付けの前に実行し、[gone] になった作業ブランチに乗ったまま削除が失敗する事態を防ぐ。
disable-model-invocation: true
---

# デフォルトブランチへの復帰と最新化

`clean_gone` はブランチを切り替えない。乗っている作業ブランチが `[gone]` になっていると、
`git branch -D` は「現在チェックアウト中のブランチ」を削除できずに失敗する。後片付けの前に
このスキルでデフォルトブランチへ戻し、リモートの削除状態を最新化しておく。

## 0. worktree を確認する

```bash
git worktree list --porcelain | awk '/^worktree /{print $2; exit}'
git rev-parse --show-toplevel
```

2つのパスが一致しなければ、今いる worktree はメインではない。デフォルトブランチは通常メインの
worktree にチェックアウトされているため、ここで `git switch` すると
`fatal: '<branch>' is already used by worktree at '<path>'` になる。その場合はメインの
worktree に移動してから改めて実行する。worktree セッションからメインチェックアウトを
`git -C` 等で操作するのは意図された隔離を回避することになるため行わない。

## 1. デフォルトブランチを特定する

```bash
git symbolic-ref --short refs/remotes/origin/HEAD
```

`origin/<branch>` の形で返る。空またはエラーならローカルに `origin/HEAD` が設定されていない
ので、次で解決する:

```bash
gh repo view --json defaultBranchRef -q .defaultBranchRef.name
```

## 2. 未コミットの変更を確認する

```bash
git status --porcelain
```

出力があれば内容を報告してユーザーに確認する。`git switch` 自体は変更を破棄しないが、無言で
進めない。

## 3. 切り替えて最新化する

```bash
git switch <default-branch>
git pull --ff-only --prune
```

`--prune` は `fetch.prune` がリポジトリ側で設定されていなくても削除済みリモートブランチの
追跡参照を確実に消し、`[gone]` の判定を最新化する。`--ff-only` は履歴が乖離していた場合に
黙ってマージ/リベースせず失敗させる。失敗したら内容を報告して止める
(デフォルトブランチにローカル専用コミットがあるなど、想定外の状態を示すため)。

## 4. 結果を報告する

```bash
git status
git log -1 --oneline
```

この後に `clean_gone` を実行すれば、`[gone]` になったブランチは「現在のブランチ」ではなく
なっている。
