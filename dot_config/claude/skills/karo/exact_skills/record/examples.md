# record の書き込みの指示の例

`SKILL.md` の「指示の例」に書いた場面で読む。指示の形と項目の決まりは `SKILL.md` にある。

よく使う 3 つの指示を、起きる順に並べる。karo の `scripts/record-test` が、この 3 つをこの順に record に渡し、すべて通ることを確かめる。例のタスク `cos-k3m` は、CoS が先に `bd create` で作ってある（タスクの状態は `bd` で書くので、指示には出てこない）。

<example>
新しい依頼を受けた（新しい話題の会話のファイルを、フロントマターから作る）:

```
書き込み指示
commit 件名: cos-k3m: record the request to sort the fb list
commit 本文:
~~~~
Start the thread on sorting the fb list by update date.
~~~~

新規: threads/cos-k3m-fb-sort.md
タスク: cos-k3m
~~~~
---
type: Thread
description: fb の一覧を更新日の新しい順にする
topic: fb の並び順
date: {日付}
tasks:
  - cos-k3m
projects:
  - work
---

### オーナー · {日付} {時刻}

fb の一覧を、更新日の新しい順に並べたい。

***

### CoS · {日付} {時刻}

タスクにした。
~~~~
```
</example>

<example>
委任した（`assignments.md` に行を足す）:

```
書き込み指示
commit 件名: cos-k3m: record the delegation
commit 本文:
~~~~
Add the agent for the fb list sort to the assignments.
~~~~

行を足す: assignments.md 稼働中
~~~~
Agent 名: cos-k3m
タスク: cos-k3m
役割: 実装
Herdr workspace: w30
pane: w30:p1
worktree: dotfiles の main
branch: main
開始日: {日付}
~~~~
```
</example>

<example>
取り込んで Agent を終了した（`assignments.md` の行を終了に移し、閉じた workspace を `commit 本文:` に書く）:

```
書き込み指示
commit 件名: cos-k3m: record the closed agent
commit 本文:
~~~~
Land the fb list sort and close the agent; workspace w30 is closed.
~~~~

置き換え: assignments.md
~~~~
| cos-k3m | cos-k3m | 実装 | w30 | w30:p1 | dotfiles の main | main | {日付} |
~~~~
~~~~
~~~~
行を足す: assignments.md 終了
~~~~
Agent 名: cos-k3m
タスク: cos-k3m
役割: 実装
worktree: dotfiles の main
branch: main
開始日: {日付}
終了日: {日付}
~~~~
```
</example>
