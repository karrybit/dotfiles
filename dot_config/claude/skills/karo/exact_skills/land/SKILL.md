---
name: land
description: cos の Agent のブランチを `~/cos` の main に取り込む手順（rebase、fast-forward、crit の一覧の更新、記録全体の確かめ）。cos の Agent の作業を main に取り込むとき、Agent に頼まれて cos のブランチを main に載せ替えるときに使う。
argument-hint: <branch> [--rebase]
---

# cos の取り込み

- 引数は、取り込むブランチの名前（`<semantics>/agent/<title>`）と、任意の `--rebase` だけを受け取る。
- 引数に `--rebase` があれば、手順の 1 だけを行って返す。なければ、手順の 1〜3 を行う。
- 取り込みは、この skill の `scripts/land` を `~/.config/claude/skills/karo/skills/land/scripts/land` の `~` の形で書き、`~/cos` から単独のコマンドで実行する。
- land は、`scripts/land` の冒頭にある確かめをすべて通ってから、hook と fsmonitor を止めた git だけを sandbox の外で動かす（`sandbox.excludedCommands` と `allow` に入れてあり、確認は出ない）。
- land は、確かめが 1 つでも合わなければ、何もせずに理由を 1 行出して止まる。
- land が止まったら、そこで手順を止め、land の出した 1 行を返す。

## 手順

1. ブランチが main より遅れていれば、`~/.config/claude/skills/karo/skills/land/scripts/land <branch> --rebase` で、worktree の中でブランチを main に載せ替える。競合したら land が rebase を戻し、競合したファイルを出すので、Agent に直させる。
   完了条件: ブランチが main より遅れていない。
2. `~/.config/claude/skills/karo/skills/land/scripts/land <branch>` で、main をブランチに fast-forward する。そのあと post-commit の hook が crit を起動し直し、crit の一覧に増えたファイルと消えたファイルを反映させる。hook が `NG crit:` の行を返したら、main は進んでいるので、その行をオーナーに伝える。
   完了条件: `~/cos` の main がブランチの先頭を指し、hook の `NG crit:` の行がないか、その行をオーナーに伝えた。
3. 引数なしの `~/.config/claude/skills/karo/scripts/karo-check` を単独のコマンドで実行し、記録全体を確かめる。commit の検査は commit したファイルだけを見るので、その外にある、取り込みが持ち込んだ問題はここで見つける。問題が出たら、出たファイルを直して commit する（`karo:record` skill）。
   完了条件: `karo-check: 0 problem(s)` が出たか、直しの commit が `OK` の行を出した。

## 返すもの

- 取り込めたときは、land が出した `main fast-forwarded to <commit>` の commit を返す。`--rebase` のときは、`rebased onto main at <commit>` の commit を返す。
- 止まったときは、止まった手順の番号と、land が出した 1 行（競合したファイルの一覧を含む）を返す。
