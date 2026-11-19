---
name: insights
description: karo と Agent の一日の働きを transcript と Beads（bd）から数えて診断し、規則・skill・ブリーフの直しの候補を挙げる手順。オーナーが /karo:insights を打ったとき、karo や Agent の違反・詰まり・待ちを数えて診断してほしいと言ったときに使う。
---

# Insights

- 数えるのはこの skill の `scripts/insights`、例を確かめるのはサブエージェント、直すかどうかを決めるのはオーナーにする。
- 結果には、数、場所（セッション ID の先頭 8 文字、時刻、Agent 名）、規則の名前だけを書き、transcript の会話・コマンド・出力の中身は書き写さない。
- 結果は、今日の `$KARO_HOME/standup/YYYY-MM-DD.md` の末尾の `## Insights（<数えた日付>）` の節に置く。transcript から作り直せる、判断のための出力（Gold）なので、Silver には書かない。オーナーが直すと決めた候補は、ふだんの手順（Beads のタスクと決定、karo 自身の長い目の方針は `decisions/` の Decision Record）で Silver に入る。

## 手順

1. `~/.config/claude/skills/karo/skills/insights/scripts/insights <日付>` を単独で実行する（日付を省くと今日。`$KARO_HOME` で `bd query` と `bd show` を読むだけの呼び出しをする）。
   完了条件: 終了コード 0 の JSON が手元にあるか、失敗の出力が手元にある。失敗したら 2 を飛ばし、3 で 4 つの指標を「取れなかった」と理由つきで報告する。
2. 下の「確かめる例」を JSON から選び、下の「サブエージェントへの依頼」で、Agent tool の `general-purpose` のサブエージェントを background で起動する。報告の通知を受けてから、この節を standup に書く。
   完了条件: サブエージェントの報告が手元にあり、選んだ例のすべてに、規則の名前と、直しの候補か「直しは要らない」がある。
3. 下の「報告の項目」を短く報告する。
   完了条件: 4 つの指標と直しの候補がすべて報告にある（取れなかった指標は理由つき）。
4. 3 の報告を本文にした `## Insights（<数えた日付>）` の節を今日の standup の末尾に足し、Insights の記録であることと standup のパスを本文に書いて commit する（`karo:record` skill）。
   完了条件: commit が `OK` の行を出した。

## 指標と数え方

| 指標 | insights の JSON のキー | 数え方と限り |
| --- | --- | --- |
| 1. karo のターンごとのツール呼び出し | `turns`、`over_limit` | オーナー・peer・task-notification の発言ごとに、scratchpad への Write・Edit、`AskUserQuestion`、skill の手順が呼ぶ karo と karrybit の scripts の実行と、`bd` の呼び出しと、`$KARO_CONFIG_HOME/config.yaml` の `uncounted:` の正規表現に合うコマンド（ファイルかキーがなければ、この追加分はない。一覧は `scripts/insights` の冒頭の `turns`）を除いて数える。オーナーの AGENTS.md が決めるターンごとの呼び出しの上限（型の例では「作業の分け方」の 2 回）を超えたターンが `over_limit`。skill の手順が求める herdr の呼び出し（`herdr agent get` など）は数に入るので、違反かどうかは 2 で確かめる |
| 2. 承認の拒否 | `approvals` | グループ（`karo`・`subagents`・`agents`）ごとに、`rejected_user`（オーナーの拒否）、`rejected_classifier`（auto mode の判定の拒否）、`prompted`（確認が出てオーナーが通した）。`prompt_wait_s` は、確認が出た呼び出しの、呼び出しから結果までの秒数の和で、実行の時間も入る |
| 3. Agent の `blocked` | `agent_prompts` | Herdr の Agent ごとの、確認のダイアログで人を待った呼び出しの数と秒数。Herdr の状態の履歴は残らないので、ダイアログの待ちで代える。確認以外の止まり方（Agent が尋ねて `idle` になった）は入らないので、タスクの `報告:` の comment と突き合わせる |
| 4. 待ち時間 | `karo_turn_s`、`delegations` | karo のターンの長さ（件数、合計、最大の秒）と、その日に初めて claim されたタスク（`started_at`）ごとの、claim から最初の comment か close の早いほうまでの分。`ended` が `null` の行は、まだそのどちらもない委任。同じタスクへの 2 回目からの委任（追加指示）は数えない |

- insights はその日の 0 時以降に変わった transcript だけを読み、時刻はこのマシンの時刻帯で日を分ける。
- transcript は `cleanupPeriodDays`（既定 30 日）で消えるので、それより前の日は数えられない。
- 数え方を変えたら `~/.config/claude/skills/karo/skills/insights/scripts/insights-test` を実行し、`insights-test: 0 failure(s)` を確かめる。

## 確かめる例

JSON から次を選ぶ。合わせて 10 件までにし、多いときは数や秒の大きい順に取る。

- `over_limit` のうち、`calls` の大きいターン。
- `rejected_user` と `rejected_classifier` が 1 以上のグループ。
- `agent_prompts` のすべての行。
- `delegations` のうち、`minutes` が 30 以上か `null` の行。

## 直し方

オーナーに正されたときと、直しの候補を挙げるときに使う。正されたことと決めたことの表は、オーナーの `$KARO_HOME/rule/enforcement.md` の「強制するものがない規則（くり返したもの）」と「仕組みで塞がないと決めた規則」に置く（ファイルがなければ作るようオーナーに伝える）。

- オーナーに正されたら、その失敗を直し、関わる規則が下の「強制するものがある規則」とオーナーの 2 つの表のどれにもなければ、「強制するものがない規則」の表に行を足す。
- 正された規則が表にあり、強制するものが「なし」なら、くり返しとして扱い、同じ変更で強い層に上げる。
- 正された規則が「仕組みで塞がないと決めた規則」の表にあれば、その行を「強制するものがない規則」の表に戻す（次の `karo:insights` が直しの候補にする）。
- 仕組みで塞いだら、行を外し、強制するものを karo plugin の直しとして下の表に足すようオーナーに伝える。
- 検討したうえで仕組みで塞がないと決めたら、行を「仕組みで塞がないと決めた規則」の表に移し、理由と出典を書く。
- 層は強い順に、道を 1 つにする（記録は commit の script だけが commit する、など）、karo の `scripts/commit` か `scripts/karo-check` の検査、hook、テスト、文書にする。上の層で塞げないときだけ下の層にする。
- 新しい検査を足すときは、記録にある実際の過去の失敗を入力にして、変更の前の版で落ちることを karo の `*-test` で示す。
- 検査の NG の文には、何をどう直すか（使う項目、列の名前、コマンド）を書く。
- 失敗が起きなくなった規則は、表から外す。

### 強制するものがある規則

| 規則（書いてある場所） | 強制するもの |
| --- | --- |
| herdr は単独で呼ぶ（karo の決まりの「sandbox」） | karo の `scripts/call-check`（hook） |
| karo の scripts は `~` の形で呼ぶ（karo の決まりの「sandbox」） | karo の `scripts/call-check`（hook。`karo:herdr-agent` の scripts を含む） |
| karo の rebase は `karo:land` skill で行い、sandbox の外でやり直さない（karo の決まりの「sandbox」） | karo の `scripts/call-check`（hook。sandbox の外の `git rebase` を止める。`--abort` は通す）、`karo:land` の `scripts/land` |
| 記録は「書き込み先」の表のファイルにだけ書く（`karo:record` の「書き込み先」） | karo の `scripts/commit`（commit するパスの確かめ） |
| 新しい記録のノートにフロントマターを付ける（`karo:record` の `frontmatter.md`） | karo の `scripts/karo-check`（`post-edit` の hook が書いたノートに、`scripts/commit` が commit に入る中身に、`--only` で呼ぶ） |
| タスク ID の形（`karo:record` の `frontmatter.md`） | karo の `scripts/karo-check`（フロントマターの `tasks` の ID の形） |
| 取り込まれていない commit や ignored なファイルが残る worktree は閉じない（`karo:delegate`「Agent を終了する」） | `karo:herdr-agent` の `agent-ctl close` |
| Agent の承認ダイアログに送るキーは Enter と q だけ（`karo:herdr-agent` の「karo が答えてよいダイアログ」） | `blocked` の Agent は `karo:herdr-agent` の `safe-key`、`idle` の Agent は settings の `permissions.ask` にある `herdr agent send-keys`（オーナーの確認） |

## サブエージェントへの依頼

依頼は、下の文の制約に `karo:delegate` skill の「依頼に毎回書く決まり」の行を足したものにする。

<template>

```
目的: karo と Agent の働きの診断。insights が数えた例ごとに、transcript で何が起きたかを確かめ、どの規則・skill・ブリーフのどの行が関わるかと、直しの候補を挙げる。読むだけで、ファイルは変えない。

insights の JSON: <1 の出力>
確かめる例: <選んだ例。指標、場所（グループ、セッション ID の先頭 8 文字か Agent 名、時刻）>

読む場所:
- transcript: ${CLAUDE_CONFIG_DIR:-~/.claude}/projects/ の下。karo は $KARO_HOME のフォルダの <セッション ID>*.jsonl、サブエージェントはその下の subagents/、Herdr の Agent は agent-name の行が Agent 名のセッション。jq で、その時刻の前後の tool_use の name・input と tool_result の is_error を読む。
- 規則: ~/.config/claude/skills/karo/hooks/session-rules.md（karo の決まり）、~/.config/claude/skills/karo/skills/、$KARO_HOME/AGENTS.md、$KARO_HOME/rule/。
- 出来事: その日の記録の出来事は git -C $KARO_HOME log --since='<日付> 00:00' --until='<翌日> 00:00' の件名と本文に、タスクの出来事は insights の JSON の delegations にあり、bd は実行しない。

制約:
- 結果に、会話・コマンド・ツールの出力の中身、個人の情報、秘密の値を書き写さない。書くのは、数、場所、ツールの名前、規則の名前、起きたことの分類（1 文）だけにする。
- ~/.ssh、~/.aws、.env、トークンのファイルは読まない。
- 手段を徹底して simple & easy にし、既存のツールで済むなら作らない。

報告（例ごとに 1 行の表）:
- 場所、指標、関わる規則（ファイルと節の名前）、起きたことの分類、規則どおりか違反か、直しの候補（どのファイルのどの節をどう直すか）か「直しは要らない」。
- 直しの候補は、規則や手順の文面を足す前に、hook・スクリプト・karo-check のような仕組みで防げるかを先に問い、防げるならその仕組みの案を先に書く。
- 違反した規則ごとに、~/.config/claude/skills/karo/skills/insights/SKILL.md の「強制するものがある規則」の表と、$KARO_HOME/rule/enforcement.md があればその 2 つの表の、どれにあるか（どれにもなければ「どの表にもない」）を書く。「強制するものがない規則」の表にあるか、どの表にもないときは、仕組みの案を書く（くり返しの扱いは同じ SKILL.md の「直し方」）。
- この表と直しの候補は、完了の報告に足す見出し「例ごとの診断」に書く。
```

</template>

## 報告の項目

この順に並べる。

- 4 つの指標の数（取れなかった指標は理由）
- 確かめた例ごとの、場所、関わる規則、規則どおりか違反か
- 直しの候補（どの規則・skill・ブリーフをどう直すか）と、オーナーに決めてほしいこと
