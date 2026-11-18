---
name: delegate
description: 'Herdr 上の Agent に仕事を委任する手順。オーナーが実装・修正・調査を頼んだとき、「goal: 〇〇」の形の依頼など完了まで続けてほしい作業を goal ごとに別の Agent の /goal で進めるとき、既存 Agent に追加指示を出すとき、Agent を終了するときに使う。goal の依頼では karrybit:goal の代わりに使う（この skill が karrybit:goal に完了の条件を書かせる）。'
---

# 委任

- Agent の起動・指示の送信・待つ・報告の取り出し・閉じるは、`karrybit:herdr-agent` skill を読み込み、その手順と scripts で行う。下の `<scripts>` は `~/.config/claude/skills/karrybit/skills/herdr-agent/scripts` で、この `~/` の形のまま書く。この skill が決めるのは、渡す値（名前はタスク ID、ブリーフ、場所）と、返った JSON から書く記録。
- Agent 名は、タスク ID の `.` を `-` に置き換えた形にする（`karo-a1b2.1` は `karo-a1b2-1`、その Review Agent は `karo-a1b2-1-rv`）。scripts にはタスク ID を渡し、Agent 名は claim の actor、記録、herdr のコマンドに使う。
- 動いている Agent は、ファイルに書かずに名前で引く。状態・workspace・pane・worktree（`cwd`）は `herdr agent list`、branch と `place` は agent-ctl の控え（`~/.local/state/herdr-agent/ledger` の 1 行 1 JSON）、タスクと開始の時刻は Beads の `in_progress` の assignee と claim の event にある。
- タスクは Beads（`bd`）にあり、書く人・呼び方・comment の先頭の語は `karo:tasks` skill の「karo での使い方」に従う。

## 作業場所と取り込み

- 作業場所、Agent がしてよいこと、取り込みは、リポジトリで分かれる。`$KARO_HOME` は下の表の `$KARO_HOME` の行に従う。ほかのリポジトリは、`$KARO_HOME/project/repo/<name>.md` に `## Agent の作業場所と取り込み` の節があればその節に従い、節かファイルがなければ表の既定の行に従う。

| リポジトリ | `agent-ctl start` の `<場所>` | Agent がしてよいこと | 取り込み |
| --- | --- | --- | --- |
| `$KARO_HOME` | `worktree $KARO_HOME main <ブランチ> $KARO_STATE_HOME/worktrees/<title>` | ローカルの commit と、終える前の main への rebase まで | オーナーの承認を待たずに karo が `karo:land` skill で取り込み、取り込んだことを報告する（先にオーナーが差分を読む作業は `karo:review` skill の「1」の 3） |
| 既定（PR を作るリポジトリ） | `herdr-worktree <リポジトリのパス> <ブランチ>` | 実装、テスト、ローカルの commit、push、Draft PR の作成まで | merge と Ready for review への変更は、オーナーが明示的に承認してから |

- プロジェクトのファイルの節は、次の項目を書く。節にない項目は、既定の行の値にする。
  - 場所: `agent-ctl start` の `<場所>`。
  - してよいこと: ブリーフの許可範囲。
  - 取り込み: 完了報告を受けたあとに karo がすること。PR を作らないリポジトリでは、PR を作らないことをここに書く。
  - 作業する場所の文: ブリーフの「作業する場所」に書く文。
  - ブリーフの制約: ブリーフの制約に足す行。
  - レビューの差分の base: PR を作らないリポジトリで、`karo:review` skill の「3」の 1 が差分を取る base。
  - 委任の前の決まり: 同時に動かせる Agent の数と、委任してはいけないとき。委任する前に読んで従い、委任できないときはオーナーに伝える。
- `~` で始まるパスは引用符で囲まずに書く（shell が絶対パスに展開する）。
- `<リポジトリのパス>` には、手元の checkout（`ghq root` の結果の下の `github.com/<owner>/<repo>`）を渡す。手元に clone がなければ、先に `ghq get <owner>/<repo>` を実行する。
- ブランチ名は `<semantics>/agent/<title>` にする。semantics はリポジトリの commit の型（`feat`、`fix`、`docs` など）、title は変更の中身を表す kebab-case の英語にする（例: `feat/agent/retry-failed-upload`）。タスク ID と `cos` は入れない（settings の `env` の形を `agent-ctl` が確かめる）。
- `$KARO_HOME` の worktree のディレクトリ名も、ブランチと同じ title にする。

## 新しいタスクを委任する

1. ブリーフを作る。項目は次の 8 つ。`bd show <タスクID> --json` の title・description・acceptance_criteria を元にし、オーナーの発言、`$KARO_HOME/investigation`、`$KARO_HOME/source/meeting` の MTG の記録、決定（decision の bead）、外の情報源から足し、出典を添える。タスクがまだ Beads になければ、`karo:tasks` skill の「タスクを進める」の 1・2 で `bd create` してから作る。ブリーフの 1 行目には、タスク ID だけを Beads の形のまま（`.` を `-` にせずに）書く（cass と bv がその ID で Agent のセッションを探す）。ブリーフの先頭の文字は `/` と `!` にしない（`agent-ctl` が断る）。
   - 目的: 何のための変更か
   - 背景: 関連する決定と出典へのリンク
   - 作業する場所: 作業場所とブランチ（「作業場所と取り込み」）。`$KARO_HOME` では「この worktree のブランチに commit し、`$KARO_HOME` の本体には書かない。終える前に main の最新に rebase する」と書く（止められたときは下の制約の行）。プロジェクトの節に「作業する場所の文」があれば、その文を書く
   - 制約: 触ってよい範囲、守るべき既存設計。毎回、次も書く
     - `bd` を実行しない。タスクの状態を変えない
     - ファイルを消すときは、変数を使った `rm -rf` を使わず、リテラルのパスにする
     - stash を作らない
     - Herdr か Claude の起動を触る作業では、`karrybit:herdr-agent` skill の「Herdr を触る Agent のブリーフに足す決まり」に従う
     - `$KARO_HOME` では、`git rebase main` が `unable to unlink old` で落ちたら（sandbox がどの設定でも書かせない `.claude/settings.json` や `.claude/skills` を書き換える rebase）、sandbox の外でやり直さずに `git rebase --abort` で戻して作業を止め、karo に `land --rebase` を頼むと報告する
     - 手段を徹底して simple & easy にし、既存のツールやライブラリで済むなら作らない
     - 承認済みの手順の停止条件に当たったら、自分の判断で緩めずに止めて、当たった箇所（コマンド、パス、回数）を報告する
     - プロジェクトの節の「ブリーフの制約」の行
   - 受け入れ条件: 完了を判定できる条件。テストで確かめられる形にする
   - 許可範囲: 表かプロジェクトの節の「してよいこと」。merge と Ready for review への変更はしない
   - 完了時の報告: 「完了の報告は karrybit:completion-report に従う」と書く。そのタスクに固有の項目（受け入れ条件ごとの確かめなど）があれば、続けて、足す見出しとして並べる
   - 外に出す内容: ブランチ名、commit メッセージ、PR のタイトルと本文、コメントには、リポジトリから辿れる事実だけを書く。タスク ID、karo や Herdr の名前、ブリーフ、手元のパスやマシンの事情は書かない。GitHub の「Update branch」のような merge commit も作らず、main に追従するときは rebase する。PR を作らないリポジトリでは、commit メッセージに同じ規則を当てる

   受け入れ条件が決まらないときは、`karo:tasks` skill の「判断待ちと決定」の 1 で判断待ちの decision の bead を作ってタスクの blocker にし、オーナーに尋ねて、委任はそこで止める。

   sandbox の外で動く道具やコマンド（`claude plugin eval` など）を Agent に使わせる作業では、ブリーフに書く前にオーナーに確かめ、オーナーが認めたものだけを名前でブリーフに書く（Agent が承認のダイアログで止まるため）。
   完了条件: 8 項目がすべて埋まり、受け入れ条件が完了か未完了かを判定できる。
2. ブリーフを、このセッションの scratchpad（環境の説明にあるフォルダ）の `briefs/<タスクID>-brief.md` に書く。
   完了条件: ブリーフのファイルがある。
3. `bd update <タスクID> --claim --actor <Agent 名> --json` を単独で実行し、Agent 名でタスクを claim する。status が `deferred` のときと claim が断られたときは、`karo:tasks` skill の「タスクを進める」の 3 に従う。
   完了条件: JSON の `status` が `in_progress`、`assignee` が Agent 名。
4. `<scripts>/agent-ctl start <タスクID> <ブリーフ> <場所>` を単独で実行する（`<場所>` は「作業場所と取り込み」）。`status` が `working` でなければ、`karrybit:herdr-agent` の「止まった Agent に答える」に進み、答えてよいかは AGENTS.md の「Herdr の操作」で決める。Agent を起動できなかったときは、`bd unclaim <タスクID> --if-assignee <Agent 名> --json` で claim を戻す。
   完了条件: JSON の `status` が `working`。
5. 下の「終わるのを待つ」に従って待ち、その場でオーナーに返す。
   完了条件: background の agent-report が走っている。

## goal を渡す

- goal は、完了の条件を満たすまで Agent が自律でターンを続ける作業。
- Claude Code の `/goal` は、条件を満たすまでそのセッションをふさぎ、1 セッションに 1 つしか持てない（https://code.claude.com/docs/en/goal.md）。そのため、1 つの goal を 1 つの Agent に渡し、その Agent のセッションで `/goal` を動かす。

1. `karrybit:goal` skill を Skill tool で呼び、オーナーの依頼の原文を渡して、その手順を最後まで進める。返った goal ごとに、完了の条件は 2 の `--goal` とブリーフの受け入れ条件に、行き詰まりの扱いはブリーフの制約に使う。止めた goal は、その goal の委任を止めて、確かめることを AskUserQuestion でオーナーに尋ねる（ほかの goal は進めてよい）。
   完了条件: 委任する goal のすべてに、`karrybit:goal` が返した完了の条件と行き詰まりの扱いがあり、止めた goal のすべてをオーナーに尋ねている。
2. goal ごとに、「新しいタスクを委任する」の手順で委任する。手順との違いは次の 4 つ。
   - タスク ID は goal ごとに 1 つ作る。
   - ブリーフの受け入れ条件は、この節の 1 の完了の条件にする。
   - 4 の `agent-ctl start` のすぐあとに `--goal "<完了の条件>"` を付ける（`<scripts>/agent-ctl start --goal "<完了の条件>" <タスクID> <ブリーフ> <場所>`。受け付ける条件の形は `karrybit:herdr-agent` の「起動する」にある）。
   - 4 で JSON の `goal` が `not_sent` なら（ブリーフで承認のダイアログが出たときなど）、4 のとおりに答えたあと、Agent が `blocked` でなくなったら `<scripts>/agent-ctl send --goal "<完了の条件>" <タスクID>` を単独で送る。

   完了条件: どの goal も「新しいタスクを委任する」の 5 まで進み、`start` か `send` の JSON の `goal` が `sent` か、画面の内容を AskUserQuestion でオーナーに尋ねている。

## 既存の Agent に追加指示を出す

1. `<scripts>/agent-ctl send <名前> "<指示>"` を単独で実行する。Agent が `working` で断られたら、終わるのを待つか、オーナーに割り込んでよいか尋ね、許されたら `--interrupt` を付けて送り直す。`status` が `blocked` なら、`karrybit:herdr-agent` の「止まった Agent に答える」に進む。
   完了条件: JSON の `status` が `working` か、画面の内容を AskUserQuestion でオーナーに尋ねている。
2. 送った指示の要旨を、`bd comment <タスクID> --file <要旨のファイル> --json` で `メモ:` で始めて書く（修正の依頼は `karo:review` skill の「3」の 3 で `変更依頼:` として書く）。指示が新しい仕事を足したときは、その仕事を `karo:tasks` skill の「タスクを進める」の 1・2 で `bd create --deps discovered-from:<タスクID>` で作る。
   完了条件: `bd comment` の JSON が出ている。
3. 下の「終わるのを待つ」に従って待つ。
   完了条件: background の agent-report が走っている。

## 終わるのを待つ

- `karrybit:herdr-agent` の「終わるのを待つ」の手順で、`<scripts>/agent-report --wait <名前>` を background で走らせ、foreground ではオーナーの次の依頼を受ける。
- 通知の 1 行目が `idle` か `done` なら、2 行目からの完了報告を持って `karo:review` skill に進む。`blocked` なら、答えてよいかを AGENTS.md の「Herdr の操作」で決める。`awaiting-answer` なら、2 行目からの待っている呼び出しを読む。承認のダイアログは `blocked` と同じく AGENTS.md の「Herdr の操作」で答えてよいかを決め、AskUserQuestion の問いのうち答えが依頼とブリーフから決まらないものはオーナーに尋ねてから、herdr-agent の「止まった Agent に答える」で答えを送る。`no-report` なら、2 行目からの Agent の最後の発言を読み、Agent の質問のうち、答えが依頼とブリーフから決まらないものはオーナーに尋ねてから送る。そのほかの状態と `no-report` の送り方は herdr-agent の手順で扱い、そこで人に伝えるとある結果はオーナーに報告する。
- Agent が停止条件に当たって止まったと報告したら、再開を自分で決めずに、理由と変更案を手順の承認者に出し、承認を得てから Agent に再開を頼む。

完了条件: 指示を送ったすべての Agent について、background の agent-report が走っているか、終わったことを確かめている。

## Agent を終了する

- 役目を終えた Agent は、AGENTS.md の「委任・レビュー・Checkin・Checkout」の恒常的な許可に従い、オーナーの承認を待たずに終了し、結果だけを報告する。
- 取り込まれていない commit や未 commit の変更が残っているときは、終了せずにオーナーに報告する。

1. `<scripts>/agent-ctl close <タスクID>` を単独で実行する（`karrybit:herdr-agent` の「閉じる」）。止まったら、その行と `parent_kept` をオーナーに報告する。ignored なファイルで止まったら、karo は一覧をオーナーに示して消してよいかを尋ね、worktree のファイルは調べも消しもしない。消してよいと答えたら、一覧のパスをリテラルで並べた `rm -rf <place>/<パス> …` の 1 行を示してオーナーのターミナルで実行してもらい、終わったら `close` を走らせ直す。残すと答えたら、閉じずに残したことを報告する。
   完了条件: JSON が出ているか、止まった理由をオーナーに報告している。
2. タスクを閉じずに Agent を終えたとき（取り込まずに止めたとき）は、`bd unclaim <タスクID> --if-assignee <Agent 名> --json` を単独で実行する。
   完了条件: JSON の `status` が `open`。取り込んで閉じるタスクでは、この手順はない。
