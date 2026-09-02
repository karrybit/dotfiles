---
name: sync-default-branch
description: リポジトリのデフォルトブランチに切り替えて `git pull` で最新化し、マージ済みのローカルブランチを根拠つきで削除する。PR がマージされた後の後片付けに使う。
disable-model-invocation: true
---

# デフォルトブランチへの復帰と、マージ済みブランチの片付け

PR がマージされた後の後片付けを行う。デフォルトブランチへ戻して最新化し、マージ済みの
ローカルブランチを削除する。デフォルトブランチへ先に移ることが削除の前提でもある
(`git branch -d` は現在チェックアウト中のブランチを削除できない)。

削除対象はマージ済みである根拠から決める (手順5)。`[gone]` マーカーは判定に使わない。`-u` を
付けずに push する運用ではブランチに upstream が設定されず、リモートブランチが削除されても
`%(upstream:track)` は何も返さないため、`[gone]` を起点にする後片付けはこの環境で何も
見つけない。根拠は `~/.local/share/agents/docs/sandbox-and-environment-gotchas.md`。

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

`--prune` は `fetch.prune` がリポジトリ側で設定されていなくても、削除済みリモートブランチの
追跡参照を確実に消す。残っていると `git branch -a` が存在しないリモートブランチを並べ、手順5の
報告が実態とずれる。`--ff-only` は履歴が乖離していた場合に
黙ってマージ/リベースせず失敗させる。失敗したら内容を報告して止める
(デフォルトブランチにローカル専用コミットがあるなど、想定外の状態を示すため)。

## 4. 結果を報告する

```bash
git status
git log -1 --oneline
```

デフォルトブランチに乗った状態になったので、手順5の削除対象に現在のブランチが含まれることは
ない。

## 5. マージ済みブランチを片付ける

デフォルトブランチ自身と現在のブランチを除いた各ローカルブランチについて、マージ済みである
根拠を確かめる。根拠が取れたものを削除し、取れなかったものは残して報告する。

### 5a. 祖先としてマージ済みのもの

```bash
git branch --merged <default-branch>
```

ここに出るブランチは tip がデフォルトブランチの祖先になっている。`git branch -d` が受け付ける
ので、そのまま削除する。

### 5b. squash / rebase でマージされたもの

squash マージされたブランチはデフォルトブランチの祖先にならないので 5a には出ない。`git cherry`
も判定に使えない (単一コミットの squash は patch-id が一致するが、複数コミットの squash は
全コミットを未反映と判定する)。判定は forge に問う:

```bash
gh pr list --head <branch> --state all --json number,state,mergedAt \
  --jq '.[] | select(.state == "MERGED")'
```

リモートブランチが削除済みでも PR は引ける。未知のブランチ名にはエラーではなく空を返す。
`MERGED` が返ったものは PR 番号を根拠として `git branch -D` で削除する (`-d` は
`not fully merged` で拒否する)。空が返ったブランチは未マージか PR 未作成なので、残して報告する。

### 5c. worktree に出ているブランチ

```bash
git worktree list --porcelain
```

worktree にチェックアウトされているブランチは削除できない。worktree の除去は独立した破棄操作
なので、ここでは行わず対象として報告し、ユーザーの判断を待つ。

### 5d. 削除後に `.git/config` を確認する

```bash
git config --get-regexp '^branch\.'
```

サンドボックスは `.git/config` への書き込みを拒否するため、この運用で作られるブランチは
upstream を持たず、削除しても debris は残らない。残るのは VS Code の `vscode-merge-base` や
`gh` の `github-pr-base-branch` のように、サンドボックス外のツールが書いた
`[branch "<name>"]` セクションだけ。削除したブランチ名のセクションが残っていたら報告する
(除去には `.git/config` への書き込みが必要で、ここからはできない)。

### 5e. 結果を報告する

削除したブランチとその根拠 (5a なら祖先、5b なら PR 番号)、残したブランチとその理由、
`.git/config` に残ったセクションを列挙する。
