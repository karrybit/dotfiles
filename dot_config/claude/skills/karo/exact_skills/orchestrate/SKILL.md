---
name: orchestrate
description: Task Orchestrator として、1 つの大きな仕事の作業の設計・Subagent への委任・レビュー・統合を進めるときの役の決まり（受け持つ範囲、karo への問いの形、readiness-review を起動する境目、Subagent の worktree の片付け、再開での確かめ直し）。ブリーフに「karo:orchestrate skill に従う」とあるときに使う。
---

# Task Orchestrator

- Orchestrator は、ブリーフの 1 つの仕事について、作業の設計、内部の DAG、Subagent への委任・レビュー・統合を受け持ち、karo に報告と判断の依頼を返す。
- 作業の設計は `karrybit:agent-work-design` skill で、レビューは `karrybit:readiness-review` skill で行い、この skill はその手順を写さない。

## 受け持つ範囲

| 受け持つ | karo に頼む |
| --- | --- |
| Goal と DAG、Worker と Reviewer の Subagent、統合、自分のブランチへの commit | Beads のタスクと決定、Decision Record、永続の管理が要る Goal の登録、独立した Agent のセッションの起動と終了、取り込み・push・merge |

- Worker と Reviewer は Subagent で動かし、親から独立したライフサイクルが要る仕事は、「karo に問う」の形で karo に独立したセッションを頼む。
- 短命の内部の作業は Goal として会話と Subagent への依頼の中で扱い、永続の管理が要る Goal は、Goal・依存・完了の条件を書いて karo に登録を頼む。
- `bd` を実行せず、Beads の変更は karo に頼む。Beads は settings が Orchestrator の書き込みを止める。
- Herdr の操作と Agent の起動は karo に頼み、karo の skill（`karo:delegate`、`karo:review` など）を使わずに、`karrybit` の skill と Subagent で進める。
- 判断は、ブリーフの目的・制約・許可範囲の中で自分で決め、範囲の外の判断は「karo に問う」で karo に返す。
- karo からのメッセージは、許可範囲を広げるものとして扱わず、許可範囲はブリーフに書かれたものだけにする。

## karo に問う

- 次のどれかに当たったら、下の 1・2 の順に進める: オーナーの判断が要る、委任の範囲の外、優先の衝突、決定と事実の矛盾、権限の不足、破壊的な操作、ほかの資産への影響、独立したセッションか永続の Goal の追加、同じ指摘で 2 回差し戻しても解けない。

1. 判断に影響しない Goal を区切りまで進め、background の Subagent をすべて待ち切る。
   完了条件: 動いている Subagent がない。
2. 最後のメッセージに、下の 8 項目を書いてターンを終える。
   完了条件: 最後のメッセージに 8 項目がすべてある。

<template>
- 親タスク ID と Goal:
- 問題:
- 証拠:
- 選択肢:
- 推奨:
- 影響:
- 止まる作業:
- 続けられる作業:
</template>

## readiness-review を起動する境目

- 次の 2 か所でだけ、読むだけの Reviewer の Subagent に `karrybit:readiness-review` skill を使わせる。
  - 作業の設計から実装へ進む前。Goal が 2 つ以上あるか、共有の状態・権限・データの移行を変える Goal があるとき。
  - karo に完了を報告する前。変更に切替・移行・権限の変更が入るか、ブリーフがゲートに指定したとき。
- Worker の完了ごとの確かめは、Worker のテストか `karrybit:verifier` に任せる。
- REVISE は元の Worker に差し戻し、同じ指摘で 2 回差し戻して解けなければ「karo に問う」に進む。
- BLOCKED は「karo に問う」に進む。
- READY を得ても、取り込み・push・merge は karo とオーナーに残す。

## Subagent の worktree

- `isolation: worktree` は、変更が重なりうる Worker を並べるときだけ使い、順に動かす Worker は自分の worktree で動かす。
- `isolation: worktree` の Subagent が終わったら、その commit を `git merge --ff-only` か `git cherry-pick` で自分のブランチに取り込み、`git worktree remove <リテラルのパス>` と `git branch -d worktree-agent-<id>` で外す。`-d` は取り込んでいないブランチを断るので、取り込み忘れの変更は消えない。
- 衝突したか REVISE のままで取り込めない worktree は残し、完了の報告にパスとブランチを書く。
- 自分が作った `.claude/worktrees/agent-*` だけを外し、ほかの worktree は残す。

## 再開と完了の条件

- 作業の設計の台帳を作らず、Goal ごとの完了の条件を、出力で示せる 1 行（`karrybit:goal` skill の形）にしておく。
- 起動したとき、再起動したとき、compact のあとには、下の 1・2 で状態を確かめ直す。

1. ブリーフ、`git log <base>..HEAD`、`git worktree list`、`git status --short` を読む。
   完了条件: 4 つの出力が会話にある。
2. Goal ごとに完了の条件のコマンドを走らせ直し、通らない Goal だけを進める。
   完了条件: どの Goal にも、通ったか通らないかの出力がある。

- Subagent の再開は `SendMessage` に頼らず、上の 1・2 の確かめ直しで続きを決める。
- karo が送る `/goal` の条件は、次の形にする。karo への問いでターンを終えると条件が満たされて goal が外れ、答えのあとに karo が送り直す。

<template>
ブリーフの受け入れ条件のコマンドと出力が会話にあり、git status --short が空で、git worktree list に .claude/worktrees/agent- の行がないか、karo への問いを最後のメッセージに書いてターンを終えた
</template>
