---
name: checkout
description: 一日の終わりに、CoS が今日を振り返り、明日やることの候補を残し、記録と Agent を片付ける手順。オーナーが /karo:checkout を打ったとき、一日の終わりの挨拶をしたとき、今日の振り返りを尋ねたときに使う。
---

# Checkout

- 記録の書き込みは、手順 5 の record の指示 1 つにまとめる。タスクは Beads（`bd`）にあり、`bd` は `karo:beads` skill の「呼び方」に従い、1 つずつ単独のコマンドで実行する。

## 手順

1. 材料を集める。
   - `~/cos` の `git log --since='<今日の日付> 00:00'` の件名と本文。
   - `assignments.md`。
   - 開いているタスクは `bd list --status open,in_progress,blocked,deferred --limit 0 --json`、判断待ちは `bd human list --status open --json`、今日閉じたタスクは `bd list --all --closed-after <今日の日付> --limit 0 --json`、今日作ったタスクは `bd list --all --created-after <今日の日付> --limit 0 --json`。
   - `herdr agent list` と、`assignments.md` の稼働中の各 Agent への `herdr agent get`。
   - 引数なしの `~/.config/claude/skills/karo/scripts/karo-check` を単独のコマンドで実行した出力。

   完了条件: `assignments.md` の稼働中の Agent すべてについて Herdr の状態か「不明」が手元にあり、4 つの `bd` の出力と、karo-check の問題と stale の一覧が手元にある。
2. Agent を片付ける。稼働中の Agent のうち役目を終えた Agent（AGENTS.md の「委任・レビュー・Checkin・Checkout」の定義）を、`karo:delegate` skill の「Agent を終了する」の 1 で閉じ、その 3 に当たるときは 3 も行う。その 2 の記録は、手順 5 の指示に入れる。`working` の Agent は閉じずに一覧にする。
   完了条件: 役目を終えた Agent ごとに `close` の JSON か止まった理由が手元にあり、`working` の Agent の一覧が手元にある。
3. 片付ける `assignments.md` の行を決める（AGENTS.md の「古くなった情報」）。終了の行のうち、終了日から 14 日経ったもの。
   完了条件: 一覧が手元にある（対象がなければ「なし」）。
4. 下の「報告の項目」を短く報告する。各項目にはタスク ID を付ける。
   完了条件: 5 つの項目がすべて報告にある。
5. 次をすべて 1 つの指示にまとめて record で書く。
   - 報告: `~/cos/journal/YYYY-MM-DD-standup.md`（今日の日付）の末尾に `## Checkout（YYYY-MM-DD）` の節を `追記:` で足す。節の下の `### 今日の振り返り` に「報告の項目」の「明日やること」のほかの項目を、`### 明日やること` に「明日やること」を書く。今日のファイルがなくても `追記:` で書く（フロントマターは record が付ける）。報告で挙げたタスクがフロントマターの `tasks` になければ、`置き換え:` で足す。
   - 3 の `assignments.md` の行: `置き換え:` で消す。
   - 2 で閉じた Agent: `karo:delegate` skill の「Agent を終了する」の 2 の中身。
   - `commit 本文:`: Checkout の記録であることと standup のパス、2 で閉じた Agent の本文。
   - `state.md`: 1 の `bd` の出力と `assignments.md` から書き直す。

   完了条件: record が `queued` を出した。
6. `bd backup sync` を単独で実行し、Beads のバックアップを取る。
   完了条件: 終了コードが 0。失敗したら、その出力をオーナーに伝える。

## 報告の項目

この順に並べる。

- 今日終えたこと（今日 `closed` にしたタスクと取り込んだ作業）
- 残ったこと（`in_progress`・`blocked`・`open` のタスクと、`working` の Agent。Herdr の状態をそのまま書く）
- 判断待ち（`bd human list` の decision の bead ごとに、問いと、本文の選択肢と推奨）
- 明日やること（翌朝の `karo:checkin` で最初に扱う候補を、優先する順に）
- 片付け（閉じた Agent、`assignments.md` から外した行、karo-check の問題と stale）
