---
name: parallel-work
description: 独立していて影響と作業量が小さい作業を、それぞれ別の worktree で subagent に並行実行させ、draft PR を作り、マージ後に worktree とローカルブランチを削除して環境を clean に戻す。実行モデル、worktree の既知の制約、draft PR の要件、統合順序と追随、後片付けを扱う。
disable-model-invocation: true
argument-hint: [作業の説明|タスクファイル|タスクID...]
---

# worktree での並行実行と draft PR

対象: `$ARGUMENTS`（未指定なら、何を並行して進めるかユーザーに確認する）

`analyze-tasks` の出力があれば入力に使えるが、**前提ではない**。作業の一覧がどこから来ても
この手順は成立する。

## 0. 着手条件

受け取った各作業が次を満たすか確認する。1つでも欠けるなら着手せず、分割してから戻る
（`analyze-tasks` がその用途に使えるが必須ではない）。

- 目的を1文で、「かつ」を使わずに言える
- 単体でビルドとテストが通る
- 単体でレビューできる
- 単体で revert できる
- **同時に進める他の作業と同じファイルを触らない**

最後の条件は特に確認する。同じファイルを触る2作業を並行させると、レビューではなくマージで
問題が出る。触るなら直列化するか、機械的に解決できる形（表の1行追加など）に限定する。

`analyze-tasks` を使っているリポジトリなら、タスク一覧は `analyze-tasks/backlog.md` にある
（固定パス。引数で渡されなくてもここを見る）。無ければ渡された作業だけで進める。

**タスクファイルに進行状態を書き込まない。** 何が進行中でどの PR がどの状態かは git と GitHub
から導出する（`git worktree list` と
`gh pr list --state all --json number,headRefName,isDraft,state`）。ファイルに写すと変更ごとに
書き換えが必要になり、二重の真実の源になってずれる。書き換えるのはマージ時のチェックボックス
1文字だけ。

## 1. 命名

タスク ID は Issue 番号（`#46`、ローカル分割した子は `#44-1`）。名前に使うときは `#` を外す。

| 対象 | 規則 | 例 |
| --- | --- | --- |
| ブランチ | `<ID>-<短い説明>` | `46-notify-deploy-status` / `44-1-aws-secrets` |
| worktree | `.claude/worktrees/<ID>` | `.claude/worktrees/46` / `.claude/worktrees/44-1` |

ブランチ名に ID を入れるのは、`git branch` と `git worktree list` だけで**どの Issue の作業か**が
分かるようにするため。後片付けで消す対象を特定するのにも使う。Issue が無い作業は ID の代わりに
短い slug を使う。

## 2. worktree と subagent

作業ごとに subagent を `isolation: worktree` で起動する。`worktree.baseRef = "fresh"` なので
worktree は origin のデフォルトブランチ起点になる。

- **順序依存のある作業だけは手動で作る。**
  `git worktree add .claude/worktrees/<id> -b <branch> <親ブランチ>`
- 1作業 = 1ブランチ = 1worktree = 1 draft PR。**1つの worktree に2作業を入れない**
- worktree は新規チェックアウトなので依存のインストールが必要。gitignore された前提ファイル
  （`.env` など）があるリポジトリには `.worktreeinclude` を置く

subagent に渡す指示の骨格:

```
あなたの作業ディレクトリはこの worktree です。ここから出ないこと。

1. 最初に `git switch -c <branch>` でブランチを作る
2. 次の1件だけを実装する: <目的を1文で>
   変更してよい範囲: <ファイル / ディレクトリ>
   これ以外は直さない。作業中に別の問題を見つけたら、直さず報告に書く
3. 検証: <コマンド>
4. 最初のコミットを作ったら、その時点で push して draft PR を作る
   `git push`（`-u` は付けない）
   `gh pr create --draft --body-file <path>`
5. 報告: ブランチ名、PR 番号、検証の結果、実施できなかった検証、範囲外で見つけたこと
```

手順1を省かせない。harness の自動命名に任せると、マージ後に削除すべきブランチを特定できない。

### 既知の制約

- `git worktree add` / `remove` は `.git/config` への書き込みがサンドボックスに拒否される
  ことがある。既知の権限ゲート操作と同じ扱いで、**初回から承認を求める**。リポジトリごとに
  挙動が違うので、拒否されてから試すのではなく先に確認する
- worktree セッションでは、静的に追跡できないシェル構文がブロックされる。非クォート区切りの
  heredoc（`<<EOF`）と brace 展開が該当する。**PR 本文は `--body-file` で渡す**のが確実で、
  複合コマンドは分けて実行する
- メインチェックアウトへの編集、`git -C` / `GIT_DIR` / `GIT_WORK_TREE` 経由のリダイレクトは
  ブロックされる。これは意図された隔離なので回避しない

## 3. draft PR

**必ず `--draft` を付けて作る。** `gh pr create --draft`。subagent に委譲するときも指示に含める。

**最初のコミットの直後に作る。** 最後にまとめて作ると、draft が「作業中である」ことの
可視化として機能しない。

本文に必ず入れるもの:

| 項目 | 理由 |
| --- | --- |
| 対象 Issue | ローカルのタスクと Issue の対応を PR 側からも辿れるようにする |
| この PR が担う作業 | 1単位であることを示す |
| 対象外 | 同じ Issue の残りをレビュアーが探さないようにする |
| 実施した検証と結果 | |
| **実施できなかった検証** | 省くと「全部通った」と読まれる |
| 依存する PR | 先にマージすべきものがあるなら明記する |

`git push` に `-u` / `--set-upstream` は付けない（`push.default = current` で足りる）。
`gh pr ready` は実行しない。draft を解除するのはユーザーが明示的に求めたときだけで、
そのときもユーザー自身に実行してもらう。

PR 番号はタスクファイルに書かない。ブランチ名から `gh pr list --head <branch>` で引ける。

## 4. 統合順序と追随

- 直列鎖は上流からマージする。独立な作業は任意順
- 先にマージされた作業があっても、残る worktree は draft のまま進める。base の更新は後追いで
  よく、競合が出た時点で rebase する
- 範囲外で見つけたことは直さず、タスクファイルの「対象外・保留」へ戻す

## 5. マージ後の後片付け

環境を clean に戻すまでが1作業。

```sh
git fetch --prune                       # リモート側の削除を反映する
git worktree remove .claude/worktrees/<id>
git branch -D <branch>
```

`/clean_gone` でも同じことができる（`[gone]` になったブランチとその worktree を削除する）。
どちらを使っても、最後に残骸がないことを確認する。

```sh
git worktree list                       # 想定外の worktree が残っていないか
git branch                              # マージ済みブランチが残っていないか
```

タスクファイルがあれば、**そのタスクのチェックボックスを入れる。ファイルへの書き込みはこれだけ。**
他の欄は触らない。

## 並行数の上限

人間がレビューできる数を超えて draft PR を作らない。上限は具体値を決めてユーザーと合意し、
タスクファイルの `並行数の上限` に書く。上限に達している間は次の波に着手しない。
