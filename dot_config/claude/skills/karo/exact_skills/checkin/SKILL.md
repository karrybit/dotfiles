---
name: checkin
description: 一日の始まりに、Daily Standup として CoS から報告する手順。オーナーが /karo:checkin を打ったとき、朝の挨拶をしたとき、昨日・前回からの進捗、Agent の状況、今日やることを尋ねたときに使う。
---

# Checkin

- この skill は、`~/cos` の記録、Beads（`bd`）、Herdr から材料を集め、報告し、記録に残す手順を持つ。外の情報源（タスクの管理、チャット、予定表など）の取り方は、`~/cos/rules/checkin.md` の「外の情報源」の節にある。
- `bd` は、`~/cos/rules/beads.md` の「呼び方」に従い、1 つずつ単独のコマンドで実行する。

## 手順

1. 報告の材料を集める。
   - 前回の Standup: `~/cos/journal/` の `YYYY-MM-DD-standup.md` の最新ファイルの日付を基準にする。
   - そのファイルに `karo:checkout` skill が残した `### 明日やること` の候補。今日の推奨アクションの候補にする。
   - その日付以降の `~/cos` の `git log --since='<その日付> 00:00'` の件名と本文。
   - その日付以降に動いたタスク: `bd list --all --updated-after <その日付> --limit 0 --json` の ID を、`bd show <ID>... --json --include-comments` に渡して、状態の変化と comment を読む。
   - `herdr agent list` と、`assignments.md` の稼働中の各 Agent への `herdr agent get`。
   - 開いているタスクは `bd list --status open,in_progress,blocked,deferred --limit 0 --json`、判断待ちは `bd human list --status open --json`、7 日以上動いていないタスクは `bd stale --days 7 --limit 0 --json`。
   - 外の情報源: `~/cos/rules/checkin.md` の「外の情報源」の節にある源ごとに、節に書かれた取り方で取る。ファイルか節がなければ、外の情報源は使わない。

   完了条件: `assignments.md` の稼働中の Agent すべてについて、Herdr の状態か「不明」が手元にあり、上の `bd` の出力がすべて手元にある（動いたタスクがなければ `bd show` は要らない）。「外の情報源」の節の源のそれぞれについて、結果か「取得できなかった」が手元にある（節がなければ、外の情報源を使わなかったことが手元にある）。
2. 下の「報告の項目」を、前回からの変化とオーナーが対応すべきことを先にして、短く報告する。各項目にはタスク ID を付ける。
   完了条件: 5 つの項目がすべて報告にある。
3. オーナーがその場で決めたことは、AGENTS.md の「記録の更新」の表の「オーナーが決めた」の行のファイルを、1 つの指示にまとめて record で反映する。必要なら `karo:delegate` skill で Agent に指示する。
   完了条件: オーナーが決めたことごとに、record が `queued` を出した。
4. 報告内容と決まったことを `~/cos/journal/YYYY-MM-DD-standup.md` に `追記:` で保存し（フロントマターは record が付ける）、`state.md` を更新する指示を 1 つにまとめ、`commit 本文:` に Checkin の記録であることを書いて、record で書く。
   完了条件: record が `queued` を出した。

## 報告の項目

この順に並べる。外の情報源の結果は、`rules/checkin.md` の「外の情報源」の節がその源ごとに決めた項目に入れ、取得できなかった源は、その項目に「取得できなかった」と書く。

- 前回からの主な進捗
- 動いている Agent と担当作業（Herdr の状態をそのまま書く）
- 完了した成果物とレビュー待ち
- ブロッカーとオーナーの判断が必要なこと（選択肢と推奨を添える）。7 日以上動いていないタスクは「要確認」としてここに入れる
- 今日の推奨アクション
