---
name: checkout
description: 一日の終わりに、karo が今日を振り返り、明日やることの候補を残し、記録と Agent を片付ける手順。オーナーが /karo:checkout を打ったとき、一日の終わりの挨拶をしたとき、今日の振り返りを尋ねたときに使う。
---

# Checkout

- 記録の書き込みは、手順 4 の 1 つの commit にまとめる（`karo:record` skill）。タスクは Beads（`bd`）にあり、`bd` は `karo:tasks` skill の「呼び方」に従って実行する。

## 手順

1. 材料を集める。
   - `$KARO_HOME` の `git log --since='<今日の日付> 00:00'` の件名と本文。
   - `karo:tasks` skill の「今の状況を読む」の表の、「開いているタスク」、「判断待ち」、「ある日から閉じたタスク」と「ある日から作ったタスク」（どちらも今日の日付から）と、その節の Agent とタスクの突き合わせ。
   - 引数なしの `~/.config/claude/skills/karo/scripts/karo-check` を単独のコマンドで実行した出力。

   完了条件: 表の 4 つの行の出力と、突き合わせの完了条件を満たした結果と、karo-check の問題と stale の一覧が手元にある。
2. Agent を片付ける。動いている Agent のうち役目を終えた Agent（karo の決まり（SessionStart の hook が入れる文）の「委任と取り込み」の定義）を、`karo:delegate` skill の「Agent を終了する」の 1 で閉じ、その 2 に当たるときは 2 も行う。`working` の Agent は閉じずに一覧にする。
   完了条件: 役目を終えた Agent ごとに `close` の JSON か止まった理由が手元にあり、`working` の Agent の一覧が手元にある。
3. 下の「報告の項目」を短く報告する。各項目にはタスク ID を付ける。
   完了条件: 5 つの項目がすべて報告にある。
4. 次をすべて書き、standup を commit する。
   - 報告: `$KARO_HOME/standup/YYYY-MM-DD.md`（今日の日付）の末尾に `## Checkout（YYYY-MM-DD）` の節を足す。節の下の `### 今日の振り返り` に「報告の項目」の「明日やること」のほかの項目を、`### 明日やること` に「明日やること」を書く。今日のファイルがなければ、`karo:record` skill の「書く」のとおりフロントマターから作る。報告で挙げたタスクがフロントマターの `tasks` になければ足す。
   - `$KARO_STATE_HOME/state.md`: `karo:record` skill の「state.md を書く」のとおり、今日終えた作業を消し、残ったことと明日やることに合わせて焦点と次の行動を直す。
   - commit の本文: Checkout の記録であることと standup のパス、2 で閉じた Agent の名前。

   完了条件: commit が `OK` の行を出した。
5. `bd backup sync` を単独で実行し、Beads のバックアップを取る。
   完了条件: 終了コードが 0。失敗したら、その出力をオーナーに伝える。
6. `cass forget --older-than 90d --apply` を単独で実行し、最後の発言から 90 日を過ぎた会話を cass から消す。
   完了条件: 終了コードが 0。失敗したら、その出力をオーナーに伝える。

## 報告の項目

この順に並べる。

- 今日終えたこと（今日 `closed` にしたタスクと取り込んだ作業）
- 残ったこと（`in_progress`・`blocked`・`open` のタスクと、`working` の Agent。Herdr の状態をそのまま書く）
- 判断待ち（1 の判断待ちの decision の bead ごとに、問いと、本文の選択肢と推奨）
- 明日やること（翌朝の `karo:checkin` で最初に扱う候補を、優先する順に）
- 片付け（閉じた Agent、karo-check の問題と stale）
