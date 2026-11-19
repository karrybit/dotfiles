---
name: tasks
description: '$KARO_HOME のタスク・判断待ち・タスクかプロジェクトに閉じた決定を Beads（bd）で扱い、bv の robot mode で依存と優先順位を分析する手順と規則（作る前の重複の確かめ、委任・レビュー・取り込みに伴う状態、comment の語、判断待ちと決定、回復）。bd でタスク・判断待ち・決定を作る・変える・閉じる前、今のタスクと判断待ちの状況や、ある問いがもう決まったかを尋ねられたとき、次に何をするか・優先順位・ボトルネック・並べて進める計画を相談されたとき、Agent の状態と Beads が食い違ったとき、bd prime の手引きとこの skill が食い違って見えたときに使う。'
---

# タスク・判断待ち・決定（Beads と bv）

- タスク・判断待ち・タスクかプロジェクトに閉じた決定とその状態の正本は Beads（`bd`）で、状態を変えるのは `bd` だけにする。karo 自身の長い目の運用・設計の決定の正本は `$KARO_HOME/decisions/` の Decision Record で、書き方は `karo:record` skill の「Decision Record を書く」にある。bv は同じタスクの集合を読んで分析し、その出力は推薦と診断にとどめる（下の「分析する（bv）」）。
- Agent の起動と操作は `karo:delegate`、成果物のレビューは `karo:review`、`$KARO_HOME` への取り込みは `karo:land` の skill の手順にある。この skill は、それらに伴うタスクの状態と記録の書き方を決める。
- bd のコマンドの一覧と挙動は `bd prime` と `bd <コマンド> --help` に、bv のコマンドは `bv --robot-help` と `bv --robot-capabilities` にある。「karo での使い方」が `bd prime` の勧めと食い違って見えたら「karo での使い方」に従う。

## karo での使い方

### 置き場所と書く人

- DB は `$KARO_HOME/.beads` の 1 つで、`$KARO_HOME` の git には入れない（`bd init --stealth`。karo-check が確かめる）。プロジェクトは label `project:<名前>` で分ける。`<名前>` はノートの `projects` の値と同じ形（`karo:record` skill の `frontmatter.md` の「フィールド」。例 `project:github.com/acme/demo`）。
- ID・type・status・設定は bd の既定のまま使う。
- `bd` で書くのは karo だけにする。作業 Agent と Review Agent のブリーフの制約には「`bd` を実行しない。タスクの状態を変えない」の 1 行を入れ、Agent の完了報告は karo が `bd comment` で入れる。

### 呼び方

- `bd` と `bv` は、パイプやリダイレクトでつながずに単独の呼び出しで実行し、`bd` には `--json` を付ける（allow の規則は単独の呼び出しにしか効かない）。
- `bd` の環境変数は `$KARO_HOME/.claude/settings.json` の `env` が渡す。Agent の名前で claim するときだけ `--actor <Agent 名>` を付ける。
- 本文（description、comment）は scratchpad のファイルに Write で書き、`--body-file <パス>`（comment は `--file <パス>`）で渡す。
- `bd create` には、本文を付ける。
- title は 160 文字（500 バイト）までにし、残りは本文に書く。
- 止めるサブコマンドと確認を出すサブコマンドは、`$KARO_HOME/.claude/settings.json` の `deny` と `ask` にある。

### 項目の対応

| karo の項目 | Beads |
| --- | --- |
| 後回し（backlog） | status `deferred`（`bd defer <ID> --json`） |
| 着手できる（ready） | status `open` |
| 委任した | status `in_progress`、assignee が Agent 名（`bd update <ID> --claim --actor <Agent 名> --json`） |
| レビュー中・変更依頼・承認（merge 待ち） | status `in_progress` のまま。段階は下の「comment の語」で残す |
| 取り込んだ（done） | status `closed`、reason `取り込み: <commit か PR>` |
| 取り下げた（dropped） | status `closed`、reason `dropped: <理由>`、label `dropped` |
| ready になったら言われなくても委任に進む（オーナーが決めたタスクだけ） | label `auto-start` |
| 件名 | title |
| 依頼と、確かめ済みの事実と制約 | description |
| 受け入れ条件 | `--acceptance` |
| 成果物（PR・Asana・調査ノートの URL、外に送った文面の要旨と permalink） | notes（`bd update <ID> --append-notes '成果物: <要旨> <URL>' --json`） |
| 優先度 高・中・低 | `-p 1`・`-p 2`・`-p 3`。わからなければ `-p 2`。`-p 0` と `-p 4` は使わない |
| 担当 | assignee（Agent 名、`karo`、`owner`） |
| 種類 | 仕事は内容で `bug`・`task`・`feature`・`chore`・`epic` から選び、迷ったら `task`。判断待ちと決定は `decision` |

### タスクを進める

1. 新しい仕事を受けたら、`bd search '<語>' --json`（title）と `bd list --all --desc-contains '<語>' --json`（本文）で、閉じたタスクも含めて似たタスクを探す。
   完了条件: 似たタスクがあればそこに comment か notes で足してある。なければ 2 に進む。
2. `bd create '<title>' -t task -p 2 -l project:<名前> --acceptance '<受け入れ条件>' --body-file <本文> --json` で作る。分けた仕事は `--parent <ID>`、作業の中で見つかった仕事は `--deps discovered-from:<ID>` で表す。先のタスクが閉じるまで着手できないときだけ、作ったあとに `bd dep add <新> <先> --json` で新しいタスクを先のタスクの後ろに置く（`bd create --deps blocks:<先>` は逆の向きで、先のタスクが新しいタスクを待つ）。着手はできて、閉じる前に要るだけのもの（merge の順、dev での確かめ）は受け入れ条件に書き、`bd dep add <新> <先> --type related --json` でつなぐ。
   完了条件: ID が返り、`bd show <ID> --json` に title・description・label があり、blocks の依存は閉じるまで着手できない先のタスクだけを指す。
3. 委任するときは、Agent を起動する前に `bd update <ID> --claim --actor <Agent 名> --json` で claim する。status が `deferred` のタスクは、先に `bd undefer <ID> --json` で `open` に戻す。claim が断られたら（ほかの名前が持っている）委任せずにオーナーに伝え、起動に失敗したら `bd unclaim <ID> --if-assignee <Agent 名> --json` で戻す。
   完了条件: `bd show <ID> --json` の status が `in_progress` で、assignee が Agent 名。
4. Agent の完了報告を受けたら、`報告:` の comment を書く。status は `in_progress` のままにし、残課題は 1・2 で `--deps discovered-from:<ID>` を付けて新しいタスクにする。
   完了条件: `bd show <ID> --json --include-comments` に `報告:` の comment がある。
5. レビューを頼んだら、誰に何のレビューを頼んだかを `レビュー依頼:` の comment に書く。結果を受けたら、結果の要旨を `変更依頼:` か `承認:` の comment に書く。`karrybit:readiness-review` の判定は、`判定:` の comment に判定と要旨を書く（要旨の項目と判定ごとの扱いは `karo:review` skill の「3」）。レビューの全文はファイルに残さず、要るときは cass で引く（`karo:recall` skill）。
   完了条件: `レビュー依頼:` の comment があり、結果を受けたあとは `変更依頼:`・`承認:`・`判定:` のどれかの comment に結果の要旨がある。
6. 取り込んだら（karo の land、dotfiles の push と apply、PR の merge）、`bd close <ID> --reason '取り込み: <commit か PR>' --force --suggest-next --json` を単独で実行して閉じる（hook がこの出力の JSON を読むので、パイプでつながない）。閉じたことで ready になったタスクは、karo の hook が tool の結果の横に案内し、label `auto-start` のタスクは `karo:delegate` skill で委任に進め、ほかのタスクはオーナーに伝える。取り下げるときは、`--reason 'dropped: <理由>'` で閉じて `bd label add <ID> dropped --json` を付ける。
   完了条件: `bd show <ID> --json` の status が `closed` で、reason に取り込みか取り下げの印がある。hook の案内が出たときは、案内のタスクごとに委任に進んだかオーナーに伝えている。

### 閉じる時機

- Agent がコードを変えて完了を報告しても、タスクは閉じずに `報告:` の comment だけを書く（Agent の完了と、karo の取り込みは別の事実）。
- 検証やレビューが要る作業は、オーナーの承認（PR の merge、`karo:review` の承認）の記録があるときだけ閉じる。
- claim の持ち主が Agent の名前のタスクは、`--force` を付けて閉じる（書くのが karo だけなので、持ち主の検査に守るものはない）。

### comment の語

- comment の先頭の語で種類を書く: `報告:`（要旨・commit・テスト結果・残課題・Agent の worktree と branch）、`レビュー依頼:`（誰に何のレビューを頼んだか）、`変更依頼:`・`承認:`（レビューの結果の要旨）、`判定:`（`karrybit:readiness-review` の READY・REVISE・BLOCKED と要旨。オーナーの承認ではない）、`決定:`（そのタスクの中だけの決定と出典）、`メモ:`。
- 委任は claim の event が Agent 名と時刻を持ち、作業場所は Herdr の `cwd`（`karo:delegate` skill の冒頭）が持つので、委任の comment は書かない。
- 長い調査は `investigation/` に置き、comment にはそのパスを書く。レビューは要旨だけを comment に書く（上の「タスクを進める」の 5）。
- 会話を出典に書くときは、オーナーの発言なら `会話 YYYY-MM-DD HH:MM`（その発言に hook が付けた `発言の時刻:` の値）、cass で引いた過去の会話なら `karo:recall` skill の「出典」の形で書く。

### 判断待ちと決定

- 複数のタスクかプロジェクトに効く決定は decision の bead にし、そのタスクの中だけの決定は `決定:` の comment にする。karo 自身の長い目の運用・設計の決定は、bead にも comment にも全文を書かず、`karo:record` skill の「Decision Record を書く」で記録にする。タスクを止める判断待ちは、決まる先がどちらでも、下の 1 の decision の bead で持つ。
- 判断待ちの問いから決定までを、1 つの decision の bead で持つ。判断待ちは label `human` があり開いている bead、決定は閉じて close_reason に決定の文か Decision Record のパスがある bead で、開いている decision を決まったこととして扱わない。
- 規則・`state.md`・ノートから Beads の決定を指すときは `決定 <ID>` と、Decision Record を指すときはそのパス（`decisions/YYYY-MM-DD-<話題>.md`）を書く。今の判断待ちと効く決定の引き方は、`$KARO_HOME/rule/information-design.md` の「探す」の表にある。

1. 判断が必要になったら、`bd create '<問い 1 文>' -t decision -l human -l project:<名前> --body-file <本文> --json` で作る。本文は「問い」「選択肢と推奨」「出典」（上の「comment の語」の会話の出典の形）の節にする。全プロジェクトに効く問いは label `project:all` にする。タスクを止めるなら、`bd dep add <タスク> <決定> --json` で blocker にする（`--parent` の子は blocker にならない）。
   完了条件: `bd human list --status open --json` に出る。
2. オーナーが決めたら、karo 自身の長い目の方針は `karo:record` skill の「Decision Record を書く」で記録にして bead を閉じ、この 2 の残りは行わない。それ以外は、`bd update <決定> --title '<決めたこと 1 文>' --body-file <全文> --json` で、本文を「決定」「理由」「検討した選択肢」「影響」「出典」の節にする。続けて `bd close <決定> --reason '決定: <1 文>' --json` で閉じる（`bd human respond` は close_reason を `Responded` にし、決定の文を残さない）。
   完了条件: `bd show <決定> --json` の close_reason に決定の文か Decision Record のパスがあり、止めていたタスクが `bd ready` に戻っている。
3. 判断待ちを経ずにオーナーが決めたことは、karo 自身の長い目の方針なら bead を作らずに `karo:record` skill の「Decision Record を書く」で記録にし、それ以外は 1 を label `human` なしの `bd create -t decision` にして、2 を続ける。
   完了条件: Decision Record の commit が `OK` の行を出したか、2 と同じ。
4. 決定に従うほかのタスクは、`bd dep add <タスク> <決定> --type related --json` でつなぐ。
   完了条件: `bd dep list <タスク> --json` に決定がある。
5. Beads の決定を置き換えるときは、新しい決定を 1〜3 で作り、`bd supersede <旧> --with <新> --json` でつなぐ。閉じた決定の本文は直さず、一部だけが変わるときも新しい決定を作る。
   完了条件: `bd show <旧>` が SUPERSEDED BY に新しい決定を出す。

### 今の状況を読む

- 作業・タスク・順序・並列・次にやることを答える返事は、その返事の中で引いた `bd` か bv（下の「分析する（bv）」）の出力から書く（SessionStart の hook の出力はセッションを始めたときの写しで、そのあとの変化を含まない）。
- 状況は下の表のコマンドで引く。karo:checkin・karo:checkout・`$KARO_HOME/AGENTS.md`・`$KARO_HOME/rule/information-design.md` はこの節を指し、コマンドを写さない。プロジェクトに絞るときは `--label project:<名前>` を足す。

| 問い | コマンド |
| --- | --- |
| 開いているタスク | `bd list --status open,in_progress,blocked,deferred --limit 0 --json`（type が `decision` のものは判断待ち） |
| 判断待ち | `bd human list --status open --json` |
| 着手できる仕事 | `bd ready --exclude-type decision --json` |
| 止まっているタスク | `bd blocked --json` |
| ある日から動いたタスク | `bd list --all --updated-after <日付> --limit 0 --json` の ID を、`bd show <ID>... --json --include-comments` に渡して、状態の変化と comment を読む（動いたタスクがなければ `bd show` は要らない） |
| ある日から閉じたタスク | `bd list --all --closed-after <日付> --limit 0 --json` |
| ある日から作ったタスク | `bd list --all --created-after <日付> --limit 0 --json` |
| 7 日以上動いていないタスク | `bd stale --days 7 --limit 0 --json` |
| 健全性 | `bd doctor --check artifacts --json`（`conventions`・`pollution` も同じ形）と、`bd list`・`bd create` が通ること |

- Agent とタスクを突き合わせるときは、`herdr agent list` の各 Agent の `name` と `agent_status` を、開いているタスクのうち `in_progress` の assignee と、Agent 名（`karo:herdr-agent` skill の「起動する」の `<名前>` と Agent 名の対応）で突き合わせる。Herdr にいない assignee の状態は「不明」とし、下の「回復」で直す。突き合わせの完了条件は、`in_progress` の assignee と `herdr agent list` の名前のある Agent のすべてについて、Herdr の状態か「不明」が手元にあること。

### 分析する（bv）

- bv を使うのは、次に着手する仕事を選ぶとき、ボトルネックや止まっている理由を調べるとき、Agent に並べて渡す計画を作るとき、依存の循環やつながりの問題を調べるときにする。タスクを作る・直す・探す・閉じるときは `bd` だけで済ませる。
- bv は `$KARO_HOME` で、下の表の `bv --robot-*` の形で実行する（付けない `bv` は TUI を開く）。プロジェクトに絞るときは `--label project:<名前>` を足す。

| 問い | コマンド | 読むところ |
| --- | --- | --- |
| 次に着手する仕事 | `bv --robot-triage --brief --robot-max-results 10 --robot-not-ready-labels human --format json` | `.quick_ref.top_picks[]`、`.recommendations[]`、`.blockers_to_clear[]` |
| ボトルネックと要のタスク、循環 | `bv --robot-insights --format json` | `.Bottlenecks`、`.Keystones`、`.Cycles`、`.status` |
| 並べて進める計画 | `bv --robot-plan --format json` | `.plan.tracks[]` |
| 1 つのタスクを止めている鎖 | `bv --robot-blocker-chain <ID> --format json` | `.result.root_blockers[]`、`.result.chain[]` |

- 出力を使うのは、`.source_authority.state` が `complete` で `.source_authority.claim_safe` が true のときだけにする。bv は、Beads の一部の行を読めなくても終了コード 0 で返し（state が `partial`）、Beads を見つけられないときも JSON を出す（state が `unknown`）。どちらも claim_safe は false になる。
- 使う指標の `.status.<指標>.state` が `computed` でなければ（`skipped` など）、その指標は計算されていないと書く。
- 出力が上の条件を満たさないとき、bv が失敗したとき、bv がないときは、「bv の分析は取れなかった」と理由（state か、エラーの 1 行）を書き、`bd ready`・`bd blocked` で答えられる範囲だけを答える。順位とボトルネックは、bd の一覧から推して埋めない。
- 分析を報告するときは、bv の推薦であることと、`generated_at` と、絞った範囲（`--label`）を添える。
- bv の推薦はタスクを選ぶ材料にとどめる。出力にある claim のコマンドは実行せず、状態を変える前に `bd show <ID> --json` で今の status と assignee を確かめ、上の「タスクを進める」の手順で変える（bv が読むのは `.beads/issues.jsonl` の書き出しで、bd の DB そのものではない）。
- bv が上位に出した decision の bead は、karo が着手する仕事ではなく、オーナーに頼む判断待ちとして報告する。

### `bd prime` と違うところ

- `bd prime` の memory の勧め（`bd remember`）の代わりに、返事の要らない会話のメモは、関わるタスクの `メモ:` の comment にする。当たるタスクがなければ、上の「タスクを進める」の 1・2 でタスクを作ってから書く。
- `bd prime` の「SESSION CLOSE PROTOCOL」の「完了した issue を閉じる」は、上の「閉じる時機」のとおり、取り込みのあとに閉じる。

### 回復

- 上の「今の状況を読む」の突き合わせで、`in_progress` の assignee が `herdr agent list` にいなければ、`herdr agent get <名前>` で確かめてから `bd unclaim <ID> --if-assignee <名前> --json` を実行し、オーナーに報告する。
- Agent を取り込まずに止めたときは、`bd unclaim <ID> --if-assignee <Agent 名> --json` で claim を外す。
- 外の回答待ちなどで止まったタスクは、`bd update <ID> --status blocked --json` と `メモ:` の comment にする。オーナーの判断が要るなら、上の「判断待ちと決定」の 1 で decision の bead を作る。
- 長く動いていないタスクは、checkin で上の「今の状況を読む」の表の「7 日以上動いていないタスク」を 1 回だけ見る。
- `bd list` が DB を開けないときは、`bd backup restore --force`（`ask`）でバックアップから戻す前に、オーナーに報告する。
