---
name: tasks
description: '$KARO_HOME のタスク・判断待ち・決定を Beads（bd）で扱い、bv の robot mode で依存と優先順位を分析する手順と規則（作る前の重複の確かめ、委任・レビュー・取り込みに伴う状態、comment の語、判断待ちと決定、回復）。bd でタスク・判断待ち・決定を作る・変える・閉じる前、今のタスクと判断待ちの状況や、ある問いがもう決まったかを尋ねられたとき、次に何をするか・優先順位・ボトルネック・並べて進める計画を相談されたとき、Agent の状態と Beads が食い違ったとき、bd prime の手引きとこの skill が食い違って見えたときに使う。'
---

# タスク・判断待ち・決定（Beads と bv）

- タスク・判断待ち・決定とその状態の正本は Beads（`bd`）で、状態を変えるのは `bd` だけにする。bv は同じタスクの集合を読んで分析し、その出力は推薦と診断にとどめる（下の「分析する（bv）」）。
- Agent の起動と操作は `karo:delegate`、成果物のレビューは `karo:review`、`$KARO_HOME` への取り込みは `karo:land` の skill の手順にある。この skill は、それらに伴うタスクの状態と記録の書き方を決める。
- bd のコマンドの一覧は SessionStart の hook が出す `bd prime` と `bd <コマンド> --help` に、bv のコマンドは `bv --robot-help` と `bv --robot-capabilities` にある。下の「bd の既定の挙動」が `--help` と食い違って見えたら `--help` を正とし、「karo での使い方」が `bd prime` の勧めと食い違って見えたら「karo での使い方」に従う。

## bd の既定の挙動

`bd prime` に出ず、「karo での使い方」が前提にするものを書く。

### 書く

- `bd create` は、本文（description）なしでも issue を作る。
- `bd update --claim` は、status が `deferred` の issue を拒む。`bd undefer` で `open` に戻すと claim できる。
- `bd close` は、claim の持ち主と違う actor からの close を拒み、`--force` を付けると閉じる。
- `bd close --reason` は close_reason に理由を残し、`bd update --status closed` は理由を残さない。
- `bd human respond` は、comment を足して閉じ、close_reason を `Responded` にする。
- `bd supersede <旧> --with <新>` は旧を閉じ、`bd show <旧>` に SUPERSEDED BY を出す。

### 依存

- `--parent` の子は、親の blocker にならない。
- `--type related` の依存は、`bd ready` に効かない。

### 読む

- `bd show --json` は comment を省き、`--include-comments` を付けると含める。
- `bd ready` は、type が `decision` の issue も出す。
- `bd search` は title と ID を部分一致で探し、閉じた issue も出す。本文は `--desc-contains` で探す。
- `bd list` は既定で閉じた issue を省き、`--all` を付けると含める。
- `bd stale` の `--limit` の既定は 50 件。
- `bd doctor` は、embedded の Dolt では `--check` の `artifacts`・`conventions`・`pollution` だけが動く。

## karo での使い方

### 置き場所と書く人

- DB は `$KARO_HOME/.beads` の 1 つで、`$KARO_HOME` の git には入れない（`bd init --stealth`。karo-check が確かめる）。プロジェクトは label `project:<名前>` で分ける。`<名前>` はノートの `projects` の値と同じ形（`karo:frontmatter` skill。例 `project:github.com/acme/demo`）。
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
2. `bd create '<title>' -t task -p 2 -l project:<名前> --acceptance '<受け入れ条件>' --body-file <本文> --json` で作る。分けた仕事は `--parent <ID>`、作業の中で見つかった仕事は `--deps discovered-from:<ID>`、順序は `bd dep add` で表す。
   完了条件: ID が返り、`bd show <ID> --json` に title・description・label がある。
3. 委任するときは、Agent を起動する前に `bd update <ID> --claim --actor <Agent 名> --json` で claim する。status が `deferred` のタスクは、先に `bd undefer <ID> --json` で `open` に戻す。claim が断られたら（ほかの名前が持っている）委任せずにオーナーに伝え、起動に失敗したら `bd unclaim <ID> --if-assignee <Agent 名> --json` で戻す。
   完了条件: `bd show <ID> --json` の status が `in_progress` で、assignee が Agent 名。
4. Agent の完了報告を受けたら、`報告:` の comment を書く。status は `in_progress` のままにし、残課題は 1・2 で `--deps discovered-from:<ID>` を付けて新しいタスクにする。
   完了条件: `bd show <ID> --json --include-comments` に `報告:` の comment がある。
5. レビューを頼んだら、誰に何のレビューを頼んだかを `レビュー依頼:` の comment に書く。結果を受けたら、レビューの原本（`project/repo/<vcs>/<org>/<repo>/review/` のファイル）を保存したあとに、`変更依頼:` か `承認:` の comment に原本のパスを添えて書く。
   完了条件: `レビュー依頼:` の comment があり、結果を受けたあとは `変更依頼:` か `承認:` の comment に原本のパスがある。
6. 取り込んだら（karo の land、dotfiles の push と apply、PR の merge）、`bd close <ID> --reason '取り込み: <commit か PR>' --force --suggest-next --json` で閉じ、新しく ready になったタスクをオーナーに伝える。取り下げるときは、`--reason 'dropped: <理由>'` で閉じて `bd label add <ID> dropped --json` を付ける。
   完了条件: `bd show <ID> --json` の status が `closed` で、reason に取り込みか取り下げの印がある。

### 閉じる時機

- Agent がコードを変えて完了を報告しても、タスクは閉じずに `報告:` の comment だけを書く（Agent の完了と、karo の取り込みは別の事実）。
- 検証やレビューが要る作業は、オーナーの承認（PR の merge、`karo:review` の承認）の記録があるときだけ閉じる。
- claim の持ち主が Agent の名前のタスクは、`--force` を付けて閉じる（書くのが karo だけなので、持ち主の検査に守るものはない）。

### comment の語

- comment の先頭の語で種類を書く: `報告:`（要旨・commit・テスト結果・残課題・Agent の worktree と branch）、`レビュー依頼:`（誰に何のレビューを頼んだか）、`変更依頼:`・`承認:`（レビューの原本のパス）、`決定:`（そのタスクの中だけの決定と出典）、`メモ:`。
- 委任は claim の event が Agent 名と時刻を持ち、作業場所は Herdr と agent-ctl の控え（`karo:delegate` skill の冒頭）が持つので、委任の comment は書かない。
- 長い原本（レビュー、調査）は `project/repo/<vcs>/<org>/<repo>/review/`・`investigation/` に置き、comment にはそのパスを書く。
- 会話を出典に書くときは、オーナーの発言なら `会話 YYYY-MM-DD HH:MM`（その発言に hook が付けた `発言の時刻:` の値）、cass で引いた過去の会話なら `karo:recall` skill の「出典」の形で書く。

### 判断待ちと決定

- 複数のタスクかプロジェクトに効く決定は decision の bead にし、そのタスクの中だけの決定は `決定:` の comment にする。
- 判断待ちの問いから決定までを、1 つの decision の bead で持つ。判断待ちは label `human` があり開いている bead、決定は閉じて close_reason に決定の文がある bead で、開いている decision を決まったこととして扱わない。
- 規則・`state.md`・ノートから決定を指すときは、`決定 <ID>` と書く。今の判断待ちと効く決定の引き方は、`$KARO_HOME/rule/information-design.md` の「探す」の表にある。

1. 判断が必要になったら、`bd create '<問い 1 文>' -t decision -l human -l project:<名前> --body-file <本文> --json` で作る。本文は「問い」「選択肢と推奨」「出典」（上の「comment の語」の会話の出典の形）の節にする。全プロジェクトに効く問いは label `project:all` にする。タスクを止めるなら、`bd dep add <タスク> <決定> --json` で blocker にする（`--parent` の子は blocker にならない。上の「依存」）。
   完了条件: `bd human list --status open --json` に出る。
2. オーナーが決めたら、`bd update <決定> --title '<決めたこと 1 文>' --body-file <全文> --json` で、本文を「決定」「理由」「検討した選択肢」「影響」「出典」の節にする。続けて `bd close <決定> --reason '決定: <1 文>' --json` で閉じる（`bd human respond` の close_reason は上の「書く」のとおり `Responded` になる）。
   完了条件: `bd show <決定> --json` の close_reason に決定の文があり、止めていたタスクが `bd ready` に戻っている。
3. 判断待ちを経ずにオーナーが決めたことは、1 を label `human` なしの `bd create -t decision` にして、2 を続ける。
   完了条件: 2 と同じ。
4. 決定に従うほかのタスクは、`bd dep add <タスク> <決定> --type related --json` でつなぐ。
   完了条件: `bd dep list <タスク> --json` に決定がある。
5. 決定を置き換えるときは、新しい決定を 1〜3 で作り、`bd supersede <旧> --with <新> --json` でつなぐ。閉じた決定の本文は直さず、一部だけが変わるときも新しい決定を作る。
   完了条件: `bd show <旧>` が SUPERSEDED BY に新しい決定を出す。

### 今の状況を読む

- 今のタスクの状況は、まず SessionStart の hook の出力（`in_progress`・判断待ち・ready・件数）から答え、hook の出力にない項目と、このセッションで書いたあとの状態だけを `bd` で引く。
- 仕事を選ぶときは `bd ready --exclude-type decision --json` を使う。
- 開いているタスクだけを探すときは `bd list --status open,in_progress,blocked,deferred --json` を使い、プロジェクトに絞るときは `--label project:<名前>` を足す。
- 判断待ちは `bd human list --status open --json`、止まっているタスクは `bd blocked --json` で引く。
- 健全性は、`bd doctor --check artifacts --json`（`conventions`・`pollution` も同じ形）と、`bd list`・`bd create` が通ることで確かめる。

### 分析する（bv）

- bv を使うのは、次に着手する仕事を選ぶとき、ボトルネックや止まっている理由を調べるとき、Agent に並べて渡す計画を作るとき、依存の循環やつながりの問題を調べるときにする。タスクを作る・直す・探す・閉じるときは `bd` だけで済ませる。
- bv は `$KARO_HOME` で、下の表の `bv --robot-*` の形で実行する（付けない `bv` は TUI を開く）。プロジェクトに絞るときは `--label project:<名前>` を足す。

| 問い | コマンド | 読むところ |
| --- | --- | --- |
| 次に着手する仕事 | `bv --robot-triage --brief --robot-max-results 10 --robot-not-ready-labels human --format json` | `.quick_ref.top_picks[]`、`.recommendations[]`、`.blockers_to_clear[]` |
| ボトルネックと要のタスク、循環 | `bv --robot-insights --format json` | `.Bottlenecks`、`.Keystones`、`.Cycles`、`.status` |
| 並べて進める計画 | `bv --robot-plan --format json` | `.plan.tracks[]` |
| 1 つのタスクを止めている鎖 | `bv --robot-blocker-chain <ID> --format json` | `.result.root_blockers[]`、`.result.chain[]` |

- 出力を使うのは、`.source_authority.state` が `complete` で `.source_authority.claim_safe` が true のときだけにする。bv は Beads を読めなくても終了コード 0 で返し、そのときはこの 2 つが `unknown` と false になる。
- 使う指標の `.status.<指標>.state` が `computed` でなければ（`skipped` など）、その指標は計算されていないと書く。
- 出力が上の条件を満たさないとき、bv が失敗したとき、bv がないときは、「bv の分析は取れなかった」と理由（state か、エラーの 1 行）を書き、`bd ready`・`bd blocked` で答えられる範囲だけを答える。順位とボトルネックは、bd の一覧から推して埋めない。
- 分析を報告するときは、bv の推薦であることと、`generated_at` と、絞った範囲（`--label`）を添える。
- bv の推薦はタスクを選ぶ材料にとどめる。出力にある claim のコマンドは実行せず、状態を変える前に `bd show <ID> --json` で今の status と assignee を確かめ、上の「タスクを進める」の手順で変える（bv が読むのは `.beads/issues.jsonl` の書き出しで、bd の DB そのものではない）。
- bv が上位に出した decision の bead は、karo が着手する仕事ではなく、オーナーに頼む判断待ちとして報告する。

### `bd prime` と違うところ

- `bd prime` の memory の勧め（`bd remember`）の代わりに、返事の要らない会話のメモは、関わるタスクの `メモ:` の comment にする。当たるタスクがなければ、上の「タスクを進める」の 1・2 でタスクを作ってから書く。
- `bd prime` の「SESSION CLOSE PROTOCOL」の「完了した issue を閉じる」は、上の「閉じる時機」のとおり、取り込みのあとに閉じる。

### 回復

- セッション開始時の突き合わせ（`$KARO_HOME/AGENTS.md` の「セッション開始時と compact 後」の 3）で、`in_progress` の assignee が `herdr agent list` にいなければ、`herdr agent get <名前>` で確かめてから `bd unclaim <ID> --if-assignee <名前> --json` を実行し、オーナーに報告する。
- Agent を取り込まずに止めたときは、`bd unclaim <ID> --if-assignee <Agent 名> --json` で claim を外す。
- 外の回答待ちなどで止まったタスクは、`bd update <ID> --status blocked --json` と `メモ:` の comment にする。オーナーの判断が要るなら、上の「判断待ちと決定」の 1 で decision の bead を作る。
- 長く動いていないタスクは、checkin で `bd stale --days 7 --limit 0 --json` を 1 回だけ見る。
- `bd list` が DB を開けないときは、`bd backup restore --force`（`ask`）でバックアップから戻す前に、オーナーに報告する。
