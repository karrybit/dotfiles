---
name: delegate
description: Herdr 上の Agent に仕事を委任する手順。オーナーが実装・修正・調査を頼んだとき、既存 Agent に追加指示を出すとき、Agent を終了するときに使う。
---

# 委任

- Agent の起動・指示の送信・待つ・報告の取り出し・閉じるは、`karrybit:herdr-agent` skill を読み込み、その手順と scripts で行う。下の `<scripts>` は `~/.config/claude/skills/karrybit/skills/herdr-agent/scripts` で、この `~/` の形のまま書く。この skill が決めるのは、渡す値（名前はタスク ID、ブリーフ、場所）と、返った JSON から書く記録。
- タスクは Beads（`bd`）にあり、`bd` を書くのは CoS だけにする。`bd` の呼び方は `~/cos/rules/beads.md` の「呼び方」、comment の先頭の語は同じファイルの「comment の語」に従う。

## 作業場所と取り込み

- 作業場所、Agent がしてよいこと、取り込みは、リポジトリで分かれる。cos は下の表の cos の行に従う。ほかのリポジトリは、`~/cos/projects/<name>.md` に `## Agent の作業場所と取り込み` の節があればその節に従い、節かファイルがなければ表の既定の行に従う。

| リポジトリ | `agent-ctl start` の `<場所>` | Agent がしてよいこと | 取り込み |
| --- | --- | --- | --- |
| cos | `worktree ~/cos main <ブランチ> ~/.local/state/cos/worktrees/<title>` | ローカルの commit と、終える前の main への rebase まで | オーナーの承認を待たずに CoS が `karo:land` skill で取り込み、取り込んだことを報告する（先にオーナーが差分を読む作業は `karo:review` skill の「1」の 3） |
| 既定（PR を作るリポジトリ） | `herdr-worktree <リポジトリのパス> <ブランチ>` | 実装、テスト、ローカルの commit、push、Draft PR の作成まで | merge と Ready for review への変更は、オーナーが明示的に承認してから |

- プロジェクトのファイルの節は、次の項目を書く。節にない項目は、既定の行の値にする。
  - 場所: `agent-ctl start` の `<場所>`。
  - してよいこと: ブリーフの許可範囲。
  - 取り込み: 完了報告を受けたあとに CoS がすること。PR を作らないリポジトリでは、PR を作らないことをここに書く。
  - 作業する場所の文: ブリーフの「作業する場所」に書く文。
  - ブリーフの制約: ブリーフの制約に足す行。
  - レビューの差分の base: PR を作らないリポジトリで、`karo:review` skill の「3」の 1 が差分を取る base。
  - 委任の前の決まり: 同時に動かせる Agent の数と、委任してはいけないとき。委任する前に読んで従い、委任できないときはオーナーに伝える。
- `~` で始まるパスは引用符で囲まずに書く（shell が絶対パスに展開する）。
- `<リポジトリのパス>` には、手元の checkout（`ghq root` の結果の下の `github.com/<owner>/<repo>`）を渡す。手元に clone がなければ、先に `ghq get <owner>/<repo>` を実行する。
- ブランチ名は `<semantics>/agent/<title>` にする。semantics はリポジトリの commit の型（`feat`、`fix`、`docs` など）、title は変更の中身を表す kebab-case の英語にする（例: `feat/agent/retry-failed-upload`）。タスク ID と `cos` は入れない（settings の `env` の形を `agent-ctl` が確かめる）。
- cos の worktree のディレクトリ名も、ブランチと同じ title にする。

## 新しいタスクを委任する

1. ブリーフを作る。項目は次の 8 つ。`bd show <タスクID> --json` の title・description・acceptance_criteria を元にし、オーナーの発言、`~/cos/investigations`、`~/cos/journal` の MTG の記録、決定（decision の bead と `~/cos/decisions`）、外の情報源から足し、出典を添える。タスクがまだ Beads になければ、`~/cos/rules/beads.md` の「タスクを進める」の 1・2 で `bd create` してから作る。ブリーフの先頭の文字は `/` と `!` にしない（`agent-ctl` が断る）。
   - 目的: 何のための変更か
   - 背景: 関連する決定と出典へのリンク
   - 作業する場所: 作業場所とブランチ（「作業場所と取り込み」）。cos では「この worktree のブランチに commit し、`~/cos` の本体には書かない。終える前に main の最新に rebase する」と書く（止められたときは下の制約の行）。プロジェクトの節に「作業する場所の文」があれば、その文を書く
   - 制約: 触ってよい範囲、守るべき既存設計。毎回、次も書く
     - `bd` を実行しない。タスクの状態を変えない
     - ファイルを消すときは、変数を使った `rm -rf` を使わず、リテラルのパスにする
     - stash を作らない
     - Herdr か Claude の起動を触る作業では、`karrybit:herdr-agent` skill の「Herdr を触る Agent のブリーフに足す決まり」に従う
     - cos では、`git rebase main` が `unable to unlink old` で落ちたら（sandbox がどの設定でも書かせない `.claude/settings.json` や `.claude/skills` を書き換える rebase）、sandbox の外でやり直さずに `git rebase --abort` で戻して作業を止め、CoS に `land --rebase` を頼むと報告する
     - 手段を徹底して simple & easy にし、既存のツールやライブラリで済むなら作らない
     - プロジェクトの節の「ブリーフの制約」の行
   - 受け入れ条件: 完了を判定できる条件。テストで確かめられる形にする
   - 許可範囲: 表かプロジェクトの節の「してよいこと」。merge と Ready for review への変更はしない
   - 完了時の報告: 「完了の報告は karrybit:completion-report に従う」と書く。そのタスクに固有の項目（受け入れ条件ごとの確かめなど）があれば、続けて、足す見出しとして並べる
   - 外に出す内容: ブランチ名、commit メッセージ、PR のタイトルと本文、コメントには、リポジトリから辿れる事実だけを書く。タスク ID、CoS や Herdr の名前、ブリーフ、手元のパスやマシンの事情は書かない。GitHub の「Update branch」のような merge commit も作らず、main に追従するときは rebase する。PR を作らないリポジトリでは、commit メッセージに同じ規則を当てる

   受け入れ条件が決まらないときは、`~/cos/rules/beads.md` の「判断待ちと決定」の 1 で判断待ちの decision の bead を作ってタスクの blocker にし、オーナーに尋ねて、委任はそこで止める。

   sandbox の外で動く道具やコマンド（`claude plugin eval` など）を Agent に使わせる作業では、ブリーフに書く前にオーナーに確かめ、オーナーが認めたものだけを名前でブリーフに書く（Agent が承認のダイアログで止まるため）。
   完了条件: 8 項目がすべて埋まり、受け入れ条件が完了か未完了かを判定できる。
2. ブリーフを、このセッションの scratchpad（環境の説明にあるフォルダ）の `briefs/<タスクID>-brief.md` に書く。
   完了条件: ブリーフのファイルがある。
3. `bd update <タスクID> --claim --actor <タスクID> --json` を単独で実行し、Agent 名（タスク ID と同じ）でタスクを claim する。claim が断られたら（ほかの名前が持っている）、委任せずにオーナーに伝える。
   完了条件: JSON の `status` が `in_progress`、`assignee` がタスク ID。
4. `<scripts>/agent-ctl start <タスクID> <ブリーフ> <場所>` を単独で実行する（`<場所>` は「作業場所と取り込み」）。goal を渡すとき（`karo:goal` skill）は、`start` のすぐあとに `--goal "<完了の条件>"` を付ける。`status` が `working` でなければ、`karrybit:herdr-agent` の「止まった Agent に答える」に進み、答えてよいかは AGENTS.md の「Herdr の操作」で決める。Agent を起動できなかったときは、`bd unclaim <タスクID> --if-assignee <タスクID> --json` で claim を戻す。
   完了条件: JSON の `status` が `working`。goal を渡したときは、`goal` も `sent`。
5. `assignments.md` の稼働中に `行を足す` で行（Agent 名、タスク、役割、Herdr workspace、pane、worktree は JSON の `place`、branch、開始日）を足す指示を、`commit 本文:` に workspace と、ブランチか、ブランチを作らないときは作業するチェックアウトとそのブランチを書いて、record で書く。
   完了条件: record が `queued` を出した。
6. 下の「終わるのを待つ」に従って待ち、その場でオーナーに返す。
   完了条件: background の agent-report が走っている。

## 既存の Agent に追加指示を出す

1. `<scripts>/agent-ctl send <名前> "<指示>"` を単独で実行する。Agent が `working` で断られたら、終わるのを待つか、オーナーに割り込んでよいか尋ね、許されたら `--interrupt` を付けて送り直す。`status` が `blocked` なら、`karrybit:herdr-agent` の「止まった Agent に答える」に進む。
   完了条件: JSON の `status` が `working` か、画面の内容を AskUserQuestion でオーナーに尋ねている。
2. 送った指示の要旨を、`bd comment <タスクID> --file <要旨のファイル> --json` で `メモ:` で始めて書く（修正の依頼は `karo:review` skill の「3」の 3 で `変更依頼:` として書く）。指示が新しい仕事を足したときは、その仕事を `~/cos/rules/beads.md` の「タスクを進める」の 1・2 で `bd create --deps discovered-from:<タスクID>` で作る。
   完了条件: `bd comment` の JSON が出ている。
3. 下の「終わるのを待つ」に従って待つ。
   完了条件: background の agent-report が走っている。

## 終わるのを待つ

- `karrybit:herdr-agent` の「終わるのを待つ」の手順で、`<scripts>/agent-report --wait <名前>` を background で走らせ、foreground ではオーナーの次の依頼を受ける。
- 通知の 1 行目が `idle` か `done` なら、2 行目からの完了報告を持って `karo:review` skill に進む。`blocked` なら、答えてよいかを AGENTS.md の「Herdr の操作」で決める。そのほかの状態は herdr-agent の手順で扱い、そこで人に伝えるとある結果はオーナーに報告する。

完了条件: 指示を送ったすべての Agent について、background の agent-report が走っているか、終わったことを確かめている。

## Agent を終了する

- 役目を終えた Agent は、AGENTS.md の「委任・レビュー・Checkin・Checkout」の恒常的な許可に従い、オーナーの承認を待たずに終了し、結果だけを報告する。
- 取り込まれていない commit や未 commit の変更が残っているときは、終了せずにオーナーに報告する。

1. `<scripts>/agent-ctl close <タスクID>` を単独で実行する（`karrybit:herdr-agent` の「閉じる」）。止まったら、その行と `parent_kept` をオーナーに報告する。ignored なファイルで止まったら、CoS は一覧をオーナーに示して消してよいかを尋ね、worktree のファイルは調べも消しもしない。消してよいと答えたら、一覧のパスをリテラルで並べた `rm -rf <place>/<パス> …` の 1 行を示してオーナーのターミナルで実行してもらい、終わったら `close` を走らせ直す。残すと答えたら、閉じずに残したことを報告する。
   完了条件: JSON が出ているか、止まった理由をオーナーに報告している。
2. JSON をもとに、`assignments.md` の行を終了に移し（移し方は `~/cos/rules/record.md` の「書き込みの指示の形」と `~/cos/rules/record-examples.md` の終了の例）、journal に運用の行を 1 つ（`[close]`、対象はタスク ID、本文は閉じた workspace と外した worktree の `place`）書く指示を 1 つにまとめ、record で書く。
   完了条件: record が `queued` を出した。
3. タスクを閉じずに Agent を終えたとき（取り込まずに止めたとき）は、`bd unclaim <タスクID> --if-assignee <タスクID> --json` を単独で実行する。
   完了条件: JSON の `status` が `open`。取り込んで閉じるタスクでは、この手順はない。
