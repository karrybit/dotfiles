---
name: beads
description: '~/cos での bd（Beads）の使い方（呼び方、cos の項目との対応、タスクの進め方と閉じる時機、comment の語、判断待ちと決定、回復）。bd でタスク・判断待ち・決定を書く前と、bd prime の手引きとこの skill が食い違って見えたときに使う。'
user-invocable: false
---

# Beads（bd）でタスク・判断待ち・決定を書く

- `bd` のコマンドの手引きは、SessionStart の hook が出す `bd prime` と `bd <コマンド> --help` にある。この skill は、cos での使い方だけを書く。
- DB は `~/cos/.beads` の 1 つで、cos の git には入れない（`bd init --stealth`）。プロジェクトは label `project:<名前>` で分ける。`<名前>` はノートの `projects` の値と同じ形（`karo:frontmatter` skill。例 `project:github.com/acme/demo`）。
- ID・type・status・設定は bd の既定のまま使う。タスク ID は `bd create` が返す ID（`cos-a2v`、子は `cos-a2v.1`）にする。
- `bd` で書くのは CoS だけにする。作業 Agent と Review Agent のブリーフの制約には「`bd` を実行しない。タスクの状態を変えない」の 1 行を入れ、Agent の完了報告は CoS が `bd comment` で入れる。
- 旧形の ID（Beads の ID の形でないタスク・判断待ち・決定の ID）が記録に出たら、`~/cos/rules/legacy-ids.md` があればそれを読む。

## 呼び方

- `bd` は、パイプやリダイレクトでつながずに単独の呼び出しで、`--json` を付けて実行する（allow の規則は単独の呼び出しにしか効かない）。
- `bd` の環境変数は `~/cos/.claude/settings.json` の `env` が渡す。Agent の名前で claim するときだけ `--actor <Agent 名>` を付ける。
- 本文（description、comment）は scratchpad のファイルに Write で書き、`--body-file <パス>`（comment は `--file <パス>`）で渡す。
- `bd create` には、本文を付ける（bd の既定では本文なしでも作れる）。
- title は 160 文字（500 バイト）までにし、残りは本文に書く。
- 止めるサブコマンドと確認を出すサブコマンドは、`~/cos/.claude/settings.json` の `deny` と `ask` にある。

## 項目の対応

| cos の項目 | Beads |
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
| 担当 | assignee（Agent 名、`CoS`、`owner`） |
| 種類 | 仕事は内容で `bug`・`task`・`feature`・`chore`・`epic` から選び、迷ったら `task`。判断待ちと決定は `decision` |

## タスクを進める

1. 新しい仕事を受けたら、`bd search '<語>' --json`（title）と `bd list --all --desc-contains '<語>' --json`（本文）で似たタスクを探す。どちらも部分一致で、閉じたタスクも出る。
   完了条件: 似たタスクがあればそこに comment か notes で足してある。なければ 2 に進む。
2. `bd create '<title>' -t task -p 2 -l project:<名前> --acceptance '<受け入れ条件>' --body-file <本文> --json` で作る。分けた仕事は `--parent <ID>`、作業の中で見つかった仕事は `--deps discovered-from:<ID>`、順序は `bd dep add <後> <先> --json` で表す。
   完了条件: ID が返り、`bd show <ID> --json` に title・description・label がある。
3. 委任するときは、`bd show <ID> --json` からブリーフを作り、`bd update <ID> --claim --actor <Agent 名> --json` で claim してから、`karo:delegate` skill の手順で Agent を起動する。status が `deferred` のタスクは、先に `bd undefer <ID> --json` で `open` に戻してから claim する（`bd update --claim` は `deferred` のタスクを拒む）。起動に失敗したら `bd unclaim <ID> --if-assignee <Agent 名> --json` で戻す。
   完了条件: `bd show <ID> --json` の status が `in_progress` で、assignee が Agent 名。
4. Agent の完了報告を受けたら、`報告:` の comment を書く。status は `in_progress` のままにし、残課題は `--deps discovered-from:<ID>` を付けて新しいタスクにする。
   完了条件: `bd show <ID> --json --include-comments` に `報告:` の comment がある。
5. レビューを頼んだときは、誰に何のレビューを頼んだかを `レビュー依頼:` の comment に書く。レビューの原本（`projects/repos/<vcs>/<org>/<repo>/reviews/` のファイル）を保存したあとに、結果を `変更依頼:` か `承認:` の comment に、原本のパスを添えて書く。
   完了条件: `レビュー依頼:` の comment があり、結果を受けたあとは `変更依頼:` か `承認:` の comment に原本のパスがある。
6. 取り込んだら（cos の land、dotfiles の push と apply、PR の merge）、`bd close <ID> --reason '取り込み: <commit か PR>' --force --json` で閉じる。取り下げるときは、`--reason 'dropped: <理由>'` で閉じて `bd label add <ID> dropped --json` を付ける。
   完了条件: `bd show <ID> --json` の status が `closed` で、reason に取り込みか取り下げの印がある。

## 閉じる時機

- Agent がコードを変えて完了を報告しても、タスクは閉じずに `報告:` の comment だけを書く（Agent の完了と、cos の取り込みは別の事実）。
- 検証やレビューが要る作業は、オーナーの承認（PR の merge、`karo:review` の承認）の記録があるときだけ閉じる。
- claim の持ち主が Agent の名前のタスクは、`--force` を付けて閉じる（actor が `cos` の `bd close` を bd が拒む。書くのが CoS だけなので、持ち主の検査に守るものはない）。
- 閉じるときは `bd close --reason` で理由を残す（`bd update --status closed` では理由が残らない）。

## comment の語

- comment の先頭の語で種類を書く: `報告:`（要旨・commit・テスト結果・残課題）、`レビュー依頼:`（誰に何のレビューを頼んだか）、`変更依頼:`・`承認:`（レビューの原本のパス）、`決定:`（そのタスクの中だけの決定と出典）、`メモ:`。
- 委任は claim の event が Agent 名と時刻を持ち、作業場所は `assignments.md` が持つので、委任の comment は書かない。
- 長い原本（完了報告の全文、レビュー、調査）は threads・reviews・investigations に置き、comment にはそのパスを書く。
- comment は `bd show <ID> --json --include-comments` で読む（`--include-comments` がないと省かれる）。

## 判断待ちと決定

- 複数のタスクかプロジェクトに効く決定は decision の bead にし、そのタスクの中だけの決定は `決定:` の comment にする。
- 判断待ちの問いから決定までを、1 つの decision の bead で持つ。
- 規則・`state.md`・ノートから決定を指すときは、`決定 cos-xxx` と書く。今の判断待ちと効く決定の引き方は、`karo:information-design` skill の「5. 探す」にある。

1. 判断が必要になったら、`bd create '<問い 1 文>' -t decision -l human -l project:<名前> --body-file <本文> --json` で作る。本文は「問い」「選択肢と推奨」「出典」（threads のパスと `YYYY-MM-DD HH:MM`）の節にする。全プロジェクトに効く問いは label `project:all` にする。タスクを止めるなら、`bd dep add <タスク> <決定> --json` で blocker にする（子の `--parent` にすると、親の blocker にならない）。
   完了条件: `bd human list --status open --json` に出る。
2. オーナーが決めたら、`bd update <決定> --title '<決めたこと 1 文>' --body-file <全文> --json` で、本文を「決定」「理由」「検討した選択肢」「影響」「出典」の節にする。続けて `bd close <決定> --reason '決定: <1 文>' --json` で閉じる（`bd human respond` は閉じる理由を `Responded` にするので、閉じるのは `bd close` で行う）。
   完了条件: `bd show <決定> --json` の close_reason に決定の文があり、止めていたタスクが `bd ready` に戻っている。
3. 判断待ちを経ずにオーナーが決めたことは、1 を label `human` なしの `bd create -t decision` にして、2 を続ける。
   完了条件: 2 と同じ。
4. 決定に従うほかのタスクは、`bd dep add <タスク> <決定> --type related --json` でつなぐ（`bd ready` には効かない）。
   完了条件: `bd dep list <タスク> --json` に決定がある。
5. 決定を置き換えるときは、新しい決定を 1〜3 で作り、`bd supersede <旧> --with <新> --json` でつなぐ。閉じた決定の本文は直さず、一部だけが変わるときも新しい決定を作る。
   完了条件: `bd show <旧>` が SUPERSEDED BY に新しい決定を出す。

## `bd prime` と違うところ

- `bd prime` の memory の勧め（`bd remember`）の代わりに、会話のメモは `threads/memo.md` に record で書く。
- `bd prime` の「SESSION CLOSE PROTOCOL」の「完了した issue を閉じる」は、上の「閉じる時機」のとおり、取り込みのあとに閉じる。

## 既定の動作を補う

- 仕事を選ぶときは `bd ready --exclude-type decision --json` を使う（`bd ready` は decision の bead も出す）。
- 開いているタスクだけを探すときは `bd list --status open,in_progress,blocked,deferred --json` を使う（`bd search` は閉じたタスクも出す）。
- 健全性は、`bd doctor --check artifacts --json`（`conventions`・`pollution` も同じ形）と、`bd list`・`bd create` が通ることで確かめる（`bd doctor` そのものは embedded の DB で動かない）。

## 回復

- セッション開始時の突き合わせ（`~/cos/AGENTS.md` の「セッション開始時と compact 後」の 3）で、`in_progress` の assignee が `herdr agent list` にいなければ、`herdr agent get <名前>` で確かめてから `bd unclaim <ID> --if-assignee <名前> --json` を実行し、オーナーに報告する。
- Agent を取り込まずに止めたときは、`bd unclaim <ID> --if-assignee <Agent 名> --json` で claim を外す。
- 外の回答待ちなどで止まったタスクは、`bd update <ID> --status blocked --json` と `メモ:` の comment にする。オーナーの判断が要るなら、上の「判断待ちと決定」の 1 で decision の bead を作る。
- 長く動いていないタスクは、checkin で `bd stale --days 7 --limit 0 --json` を 1 回だけ見る（`--limit` の既定は 50 件）。
- `bd list` が DB を開けないときは、`bd backup restore --force`（`ask`）でバックアップから戻す前に、オーナーに報告する。
