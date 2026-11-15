---
name: checkout
description: 一日の終わりに、CoS が今日を振り返り、明日やることの候補を残し、記録と Agent を片付ける手順。オーナーが /karo:checkout を打ったとき、一日の終わりの挨拶をしたとき、今日の振り返りを尋ねたときに使う。
---

# Checkout

- 記録の書き込みは、手順 7 の record の指示 1 つにまとめる。
- 違反した規則を仕組みで塞ぐ Agent（correct）に委任するかと、その依頼の型は、`~/cos/rules/checkout.md` の「correct」の節にある。

## 手順

1. 材料を集める。
   - 今日の journal と、`~/cos` の `git log --since='<今日の日付> 00:00'`。
   - `assignments.md` と、開いているタスク、判断待ち、今日閉じたタスク（`~/cos/rules/information-design.md` の「探す」のその行）。
   - `herdr agent list` と、`assignments.md` の稼働中の各 Agent への `herdr agent get`。
   - 引数なしの `~/.config/claude/skills/karo/scripts/karo-check` を単独のコマンドで実行した出力。

   完了条件: `assignments.md` の稼働中の Agent すべてについて Herdr の状態か「不明」が手元にあり、karo-check の問題と stale の一覧が手元にある。
2. Agent を片付ける。稼働中の Agent のうち役目を終えた Agent（AGENTS.md の「委任・レビュー・Checkin・Checkout」の定義）を、`karo:delegate` skill の「Agent を終了する」の 1 で閉じる。その 2 の記録は、手順 7 の指示に入れる。`working` の Agent は閉じずに一覧にする。
   完了条件: 役目を終えた Agent ごとに `close` の JSON か止まった理由が手元にあり、`working` の Agent の一覧が手元にある。
3. 片付ける `assignments.md` の行を決める（AGENTS.md の「古くなった情報」）。終了の行のうち、終了日から 14 日経ったもの。
   完了条件: 一覧が手元にある（対象がなければ「なし」）。
4. `karo:insights` skill の手順 1 から 3 で、今日の働きを数えて診断する。
   完了条件: insights の「報告の項目」がすべて手元にある。
5. correct の候補を決め、候補があれば Agent に委任する。
   - `~/cos/rules/checkout.md` の「correct」の節の候補の決め方で、4 で違反とされた規則から候補を選ぶ。
   - ファイルか節がないとき、候補がないとき、`assignments.md` の稼働中に役割が `correct` の行があるときは、委任せず、その理由を Insights の報告に書く。
   - 候補があれば、すべての候補を 1 つの Agent に渡す。`shortid` でタスク ID を作り、節の依頼の型を埋めてブリーフにし、`karo:delegate` skill の「新しいタスクを委任する」の 2・3・5 で委任する。ブランチは節の形にする。その 4 の記録は、手順 7 の指示に入れる。

   完了条件: `agent-ctl start` の JSON の `status` が `working` で、background の agent-report が走っているか、委任しなかった理由が手元にある。
6. 下の「報告の項目」を短く報告する。各項目にはタスク ID を付ける。
   完了条件: 6 つの項目がすべて報告にある。
7. 次をすべて 1 つの指示にまとめて record で書く。
   - 報告: `~/cos/journal/YYYY-MM-DD-standup.md`（今日の日付）の末尾に `## Checkout（YYYY-MM-DD）` の節を `追記:` で足す。節の下の `### 今日の振り返り` に「報告の項目」の「明日やること」と「Insights」のほかの項目を、`### 明日やること` に「明日やること」を、`### Insights` に「Insights」を書く。今日のファイルがなければ `新規:` で作り、フロントマターは `rules/frontmatter.md` の `journal/YYYY-MM-DD-standup.md` の行に従う。報告で挙げたタスクがフロントマターの `tasks` になければ、`置き換え:` で足す。
   - 3 の `assignments.md` の行: `置き換え:` で消す。
   - 2 で閉じた Agent: `karo:delegate` skill の「Agent を終了する」の 2 の中身。
   - 5 で委任したとき: `新規: tasks/<タスクID>.md`（`description` は候補の規則、`state` は `delegated`、`agent` はタスク ID、`## 依頼` に standup のパス）、`assignments.md` の稼働中に `行を足す` で行（役割は `correct`、ほかの列は `karo:delegate` skill の「新しいタスクを委任する」の 4）、journal に `[delegate]` の行（対象はタスク ID、本文は workspace とブランチ、出典は standup のパス）。
   - journal: `[note]` の行を 1 つ（対象は `cos`、出典は standup のパス）。
   - `state.md`: `tasks/` と `assignments.md` から書き直す。

   完了条件: record が `queued` を出した。

## 報告の項目

この順に並べる。

- 今日終えたこと（今日 `done` にしたタスクと取り込んだ作業）
- 残ったこと（`delegated`・`in-review`・`changes-requested`・`approved` のタスクと、`working` の Agent。Herdr の状態をそのまま書く）
- 判断待ち（タスクのファイルの `## 判断待ち` の q-ID ごとに、選択肢と推奨）
- 明日やること（翌朝の `karo:checkin` で最初に扱う候補を、優先する順に）
- 片付け（閉じた Agent、`assignments.md` から外した行、karo-check の問題と stale）
- Insights（手順 4 の報告。直しの候補はオーナーが決める。手順 5 で委任した correct のタスク ID と候補か、委任しなかった理由も書く）
