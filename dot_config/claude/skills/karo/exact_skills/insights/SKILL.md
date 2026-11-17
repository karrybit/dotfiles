---
name: insights
description: CoS と Agent の一日の働きを transcript と Beads（bd）から数えて診断し、規則・skill・ブリーフの直しの候補を挙げる手順。オーナーが /karo:insights を打ったとき、CoS や Agent の違反・詰まり・費用を数えて診断してほしいと言ったときに使う。
---

# Insights

- 数えるのはこの skill の `scripts/insights`、例を確かめるのはサブエージェント、直すかどうかを決めるのはオーナーにする。
- 結果には、数、場所（セッション ID の先頭 8 文字、時刻、Agent 名）、規則の名前だけを書き、transcript の会話・コマンド・出力の中身は書き写さない。
- 結果は、今日の `~/cos/journal/YYYY-MM-DD-standup.md` の末尾の `## Insights（<数えた日付>）` の節に置く。transcript から作り直せる、判断のための出力（Gold）なので、Silver には書かない。オーナーが直すと決めた候補は、ふだんの手順（Beads のタスクと決定）で Silver に入る。

## 手順

1. `~/.config/claude/skills/karo/skills/insights/scripts/insights <日付>` を単独で実行する（日付を省くと今日。`~/cos` で `bd query` と `bd show` を読むだけの呼び出しをする）。
   完了条件: 終了コード 0 の JSON が手元にあるか、失敗の出力が手元にある。失敗したら 2 を飛ばし、3 で 5 つの指標を「取れなかった」と理由つきで報告する。
2. 下の「確かめる例」を JSON から選び、下の「サブエージェントへの依頼」で、Agent tool の `general-purpose` のサブエージェントを background で起動する。報告の通知を受けてから、この節を standup に書く。
   完了条件: サブエージェントの報告が手元にあり、選んだ例のすべてに、規則の名前と、直しの候補か「直しは要らない」がある。
3. 下の「報告の項目」を短く報告する。
   完了条件: 5 つの指標と直しの候補がすべて報告にある（取れなかった指標は理由つき）。
4. 3 の報告を本文にした `## Insights（<数えた日付>）` の節を今日の standup の末尾に足し、Insights の記録であることと standup のパスを本文に書いて commit する（`karo:record` skill）。
   完了条件: commit が `OK` の行を出した。

## 指標と数え方

| 指標 | insights の JSON のキー | 数え方と限り |
| --- | --- | --- |
| 1. CoS のターンごとのツール呼び出し | `turns`、`over_limit` | オーナー・peer・task-notification の発言ごとに、scratchpad への Write・Edit、`AskUserQuestion`、skill の手順が呼ぶ karo と karrybit の scripts の実行と、`~/cos/rules/karo.yaml` の `uncounted:` の正規表現に合うコマンド（ファイルかキーがなければ、この追加分はない。一覧は `scripts/insights` の冒頭の `turns`）を除いて数える。AGENTS.md の「委任・レビュー・Checkin・Checkout」の 2 回を超えたターンが `over_limit`。skill の手順が求める herdr の呼び出し（`herdr agent get` など）は数に入るので、違反かどうかは 2 で確かめる |
| 2. 承認の拒否 | `approvals` | グループ（`cos`・`subagents`・`agents`）ごとに、`rejected_user`（オーナーの拒否）、`rejected_classifier`（auto mode の判定の拒否）、`prompted`（確認が出てオーナーが通した）。`prompt_wait_s` は、確認が出た呼び出しの、呼び出しから結果までの秒数の和で、実行の時間も入る |
| 3. Agent の `blocked` | `agent_prompts` | Herdr の Agent ごとの、確認のダイアログで人を待った呼び出しの数と秒数。Herdr の状態の履歴は残らないので、ダイアログの待ちで代える。確認以外の止まり方（Agent が尋ねて `idle` になった）は入らないので、タスクの `報告:` の comment と突き合わせる |
| 4. 待ち時間 | `cos_turn_s`、`delegations` | CoS のターンの長さ（件数、合計、最大の秒）と、その日に初めて claim されたタスク（`started_at`）ごとの、claim から最初の comment か close の早いほうまでの分。`ended` が `null` の行は、まだそのどちらもない委任。同じタスクへの 2 回目からの委任（追加指示）は数えない |
| 5. 費用とトークン | `tokens`、`session_cost` | トークンはグループとモデルごとの、その日の API メッセージの和。`session_cost` はセッションごとの累計の費用と始まりの時刻で、Claude Code がときどき書くだけなので、その日の費用ではない。その日の費用は「取れない」と報告する |

- insights はその日の 0 時以降に変わった transcript だけを読み、時刻はこのマシンの時刻帯で日を分ける。
- transcript は `cleanupPeriodDays`（既定 30 日）で消えるので、それより前の日は数えられない。
- 数え方を変えたら `~/.config/claude/skills/karo/skills/insights/scripts/insights-test` を実行し、`insights-test: 0 failure(s)` を確かめる。

## 確かめる例

JSON から次を選ぶ。合わせて 10 件までにし、多いときは数や秒の大きい順に取る。

- `over_limit` のうち、`calls` の大きいターン。
- `rejected_user` と `rejected_classifier` が 1 以上のグループ。
- `agent_prompts` のすべての行。
- `delegations` のうち、`minutes` が 30 以上か `null` の行。

## サブエージェントへの依頼

<template>

```
目的: CoS と Agent の働きの診断。insights が数えた例ごとに、transcript で何が起きたかを確かめ、どの規則・skill・ブリーフのどの行が関わるかと、直しの候補を挙げる。読むだけで、ファイルは変えない。

insights の JSON: <1 の出力>
確かめる例: <選んだ例。指標、場所（グループ、セッション ID の先頭 8 文字か Agent 名、時刻）>

読む場所:
- transcript: ${CLAUDE_CONFIG_DIR:-~/.claude}/projects/ の下。CoS は ~/cos のフォルダの <セッション ID>*.jsonl、サブエージェントはその下の subagents/、Herdr の Agent は agent-name の行が Agent 名のセッション。jq で、その時刻の前後の tool_use の name・input と tool_result の is_error を読む。
- 規則: ~/cos/AGENTS.md、~/cos/rules/、~/.config/claude/skills/karo/skills/。
- 出来事: その日の記録の出来事は git -C ~/cos log --since='<日付> 00:00' --until='<翌日> 00:00' の件名と本文に、タスクの出来事は insights の JSON の delegations にあり、bd は実行しない。

制約:
- 結果に、会話・コマンド・ツールの出力の中身、個人の情報、秘密の値を書き写さない。書くのは、数、場所、ツールの名前、規則の名前、起きたことの分類（1 文）だけにする。
- ~/.ssh、~/.aws、.env、トークンのファイルは読まない。
- 手段を徹底して simple & easy にし、既存のツールで済むなら作らない。

報告（例ごとに 1 行の表）:
- 場所、指標、関わる規則（ファイルと節の名前）、起きたことの分類、規則どおりか違反か、直しの候補（どのファイルのどの節をどう直すか）か「直しは要らない」。
- 直しの候補は、規則や手順の文面を足す前に、hook・スクリプト・karo-check のような仕組みで防げるかを先に問い、防げるならその仕組みの案を先に書く。
- ~/cos/rules/enforcement.md があれば、違反した規則ごとに、そのどの表にあるか（どの表にもなければ「どの表にもない」）を書く。「強制するものがない規則」の表にあるか、どの表にもないときは、仕組みの案を書く（くり返しの扱いは同じファイルの「直し方」）。
- 完了の報告は karrybit:completion-report に従い、この表と直しの候補を、足す見出し「例ごとの診断」に書く。
```

</template>

## 報告の項目

この順に並べる。

- 5 つの指標の数（取れなかった指標は理由）
- 確かめた例ごとの、場所、関わる規則、規則どおりか違反か
- 直しの候補（どの規則・skill・ブリーフをどう直すか）と、オーナーに決めてほしいこと
