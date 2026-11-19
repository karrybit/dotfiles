判定は BLOCKED で、待つのは G2 と G4 だけです。判断に影響しない G1・G5（G1 の後に G3）を進め、Subagent を待ち切ってから karo に問います。

1. Agent（G1、`isolation: "worktree"`、`run_in_background: true`、prompt: G1 の契約と完了の条件 `bin/parse-test -k quoted_newline`）
2. Agent（G5、`isolation: "worktree"`、`run_in_background: true`、prompt: G5 の契約と完了の条件 `bin/lint README.md`）
3. 2 つの完了通知を待ち、`git merge --ff-only worktree-agent-<id>` で取り込み、`git worktree remove <リテラルのパス>` と `git branch -d worktree-agent-<id>` で外す。
4. G1 を取り込んだら、Agent（G3、`run_in_background: true`）を起動し、その完了通知も待って取り込む。
5. 動いている Subagent がなくなってから、下の問いを最後のメッセージにしてターンを終える。

karo への問い:

- 親タスク ID と Goal: `karo-w3n` / `karo-w3n.1` の G2（R2）と G4（R4）
- 問題: `--delimiter` を省いたときの既定値が決まっていない。
- 証拠: `rv01` の BLOCKED の指摘 1。ブリーフにも記録にも既定値がない。
- 選択肢: (a) 今までどおり `,`。(b) 入力ファイルの拡張子から決める（`.tsv` ならタブ）。
- 推奨: (a)。今の利用者の振る舞いが変わらない。
- 影響: (b) なら G2 に拡張子の判定とテストが足り、G4 の説明も変わる。
- 止まる作業: G2、G4。
- 続けられる作業: G1・G3・G5 は済ませた。
