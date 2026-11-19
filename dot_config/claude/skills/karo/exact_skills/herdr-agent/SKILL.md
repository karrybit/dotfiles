---
name: herdr-agent
description: Herdr で別のセッションの Claude Code の Agent を起動し、指示を送り、終わるのを待ち、報告を取り出し、閉じる手順と scripts。Herdr の Agent に作業を任せるとき、動いている Agent に指示を足すとき、止まった Agent のダイアログに答えるとき、終わった Agent を片付けるときに使う。
---

# Herdr の Agent を動かす

## 範囲

- この skill は、Herdr の Agent の 5 つの操作（起動、指示の送信、終わるのを待つ、報告を取り出す、閉じる）と、止まった Agent に答える手順を受け持つ。
- 呼び出し側は、Agent の名前、ブリーフのファイル、作業する場所、goal の条件、permission mode、答えてよいダイアログの一覧を決めて渡す。ブリーフの中身、報告の読み方、作業の取り込みは呼び出し側が持つ。
- 下の `<scripts>` は `~/.config/claude/skills/karo/skills/herdr-agent/scripts` で、呼ぶときはこの `~/` の形のまま書く。settings の規則はコマンドの文字列をそのまま照らすので、絶対パスや `$HOME` で書くと規則に合わず、確認が出るか sandbox に残る（karo の `call-check` の hook が止める）。

## 呼び出し側が先に整える settings

呼び出し側の `.claude/settings.json` に次の値を置く。

| 場所 | 値 |
| --- | --- |
| `permissions.allow` | `Bash(<scripts>/agent-ctl *)`、`Bash(<scripts>/agent-report *)`、`Bash(<scripts>/safe-key *)` |
| `sandbox.excludedCommands` | `<scripts>/agent-ctl *`、`<scripts>/agent-report *`、`<scripts>/safe-key *` |
| `env` の `HERDR_AGENT_NAME_PATTERN`（必須） | 名前が合うべき ERE（`^` と `$` で囲み、herdr が断る大文字を通さない）。`agent-ctl` のすべてと `safe-key enter` が使い、未設定なら `safe-key enter` は何も送らない |
| `env` の `HERDR_AGENT_BRANCH_PATTERN`（任意） | `worktree` と `herdr-worktree` で作るブランチが合うべき ERE |
| `env` の `HERDR_AGENT_BRANCH_DENY`（任意） | そのブランチが合ってはいけない ERE |

- 表の `<scripts>` は、上の `~/` の形の文字列に置き換えて書く。
- hook は settings に書かない。karo の plugin の `hooks/hooks.json` が PreToolUse に `call-check` を登録し、`<scripts>` を `~/` 以外の形で書いた呼び出しと、herdr をつないだ呼び出しを止める。
- `env` は、sandbox の中の Agent が書き換えられない settings に置く。呼び出しの先頭に `VAR=x` を付けると `allow` の規則に合わなくなるので、env の値は呼び出しのたびに変えられない。
- herdr 自体の `workspace close`・`tab close`・`worktree remove`・`agent prompt`・`agent send-keys`・`pane send-keys`・`pane send-text` は `allow` に入れない。scripts は確かめてから herdr を呼ぶので許可でき、herdr 自体は確認を出したままにする。
- settings を確かめるときは、`~/.config/claude/skills/karo/scripts/settings-test <settings.json>` を走らせる。表の値の有無と、herdr 自体の上の操作が `allow` に当たらないことを確かめ、足りない行は 1 行ずつ `FAIL` で出る。

## Herdr を呼ぶときの決まり

- 操作の前に、`test "${HERDR_ENV:-}" = 1` で Herdr の中にいることを確かめる。外にいたら、そう伝えて止まる。
- Herdr の考え方は `herdr --skill`、書式は `herdr <グループ>`（`herdr agent` など、サブコマンドを付けない形）の出力で確かめる。
- scripts と herdr のコマンドは単独の Bash で呼び、出力の加工は次の呼び出しで行う。パイプやリダイレクトをつなぐと sandbox に残り、`Operation not permitted` で失敗する（socket が塞がれたのではない）。
- scripts と、`sandbox.excludedCommands` にある herdr のコマンドは、`dangerouslyDisableSandbox` を付けずに呼ぶ。

## 5 つの操作

| 操作 | 呼び出し |
| --- | --- |
| 起動する | `<scripts>/agent-ctl start …` |
| 指示を送る | `<scripts>/agent-ctl send …` |
| 終わるのを待つ | `<scripts>/agent-report --wait <名前>`（background で走らせる） |
| 報告を取り出す | `<scripts>/agent-report <名前>` |
| 閉じる | `<scripts>/agent-ctl close <名前>` |

- `agent-ctl` は、どの呼び出しも 1 行の JSON を出す。引数の誤りは終了コード 2 で、何も作らない。そのほかの失敗は `agent-ctl <操作> <名前>: <理由>` の 1 行で終了コード 1 になり、途中で止まったときは末尾の `(already done: …)` に済んだことが書かれる。止まった行は、呼び出し側の人に伝える。

### 起動する

```text
agent-ctl start [--goal <条件>] [--permission-mode <mode>] <名前> <ブリーフのファイル> <場所>
```

| `<場所>` | 用意すること | `close` が取り込み済みとみなす条件 | `close` が片付けるもの |
| --- | --- | --- | --- |
| `dir <パス> [<ブランチ>]` | 既存の main checkout をそのまま使う。`<ブランチ>` を渡すと、その上にいることを確かめる | `<ブランチ>`（渡さなければ HEAD）の commit が、どれも origin のどれかのブランチに入っている | workspace（checkout は残る） |
| `worktree <repo> <base> <ブランチ> <パス>` | `<repo>` の `<base>` から `git worktree add -b <ブランチ> <パス>` で作る | worktree の HEAD が `<base>` に入っている | worktree（ブランチは残る）と workspace |
| `herdr-worktree <repo> <ブランチ>` | `herdr worktree create` で作る | HEAD が origin のどれかのブランチに入っている | worktree、workspace、`start` が開いた親の workspace |
| `tab <Agent の名前>` | その Agent の workspace に tab を足し、その Agent と同じ cwd で起動する | なし | tab |

- パスと `<repo>` は絶対パスで渡す。
- `<名前>` は `HERDR_AGENT_NAME_PATTERN` に合う形のまま渡す。Herdr の Agent 名は、`<名前>` の中の herdr が受けない文字（`[a-z0-9_-]` のほか）を `-` に置き換えた形になり（`a1b2.1` は `a1b2-1`、`a1b2.1-rv` は `a1b2-1-rv`）、JSON の `name` に出る。scripts には `start` に渡した `<名前>` を渡し、herdr のコマンド（`herdr agent read` など）には Agent 名を渡す。
- `start` は、label が Agent 名の workspace（`tab` では tab）を作り、`claude -n <Agent 名>` をその Agent 名で起動し、ブリーフを送る。
- `--goal` の条件と `send` の文には `<(` を書かず、別の言い方で書く。`<(` があると、Claude Code が呼び出しを `sandbox.excludedCommands` に当てず、sandbox に残った herdr が `Operation not permitted` で落ちる。
- `--goal <条件>` を付けると、ブリーフのあとに `/goal <条件>` を送る。Agent が `working`・`idle`・`done` のときだけ送り、送れなければ JSON の `goal` が `not_sent` になる。条件は 1 行で、制御文字と見えない書式文字を含まず、clear 系の語（`clear`・`stop` など）でなく、4000 字以内にする。
- `--permission-mode` は `default`・`plan`・`dontAsk` のどれか。読むだけの Agent（レビューなど）は `plan` で起動する。
- JSON は `{name, kind, workspace, pane, place, branch, status}` で、`tab`、`goal`、`error` が付くことがある。`kind` は場所の種類の語。
- `status` が `working` なら「終わるのを待つ」に進む。`not_ready`（信頼のダイアログなど）か `blocked` なら「止まった Agent に答える」に進む。`goal` が `not_sent` なら、答えたあとに `agent-ctl send --goal <条件> <名前>` で送る。

### 指示を送る

```text
agent-ctl send [--interrupt] <名前> <文>
agent-ctl send --goal <条件> <名前>
```

- `send` は、`start` が起動して控えにある Agent の、呼び出し側の pane でないものに、`idle` か `done` のときだけ送る。`working` の Agent には、割り込んでよいと人が決めたときだけ `--interrupt` を付けて送る。
- `/` と `!` で始まる文は Claude Code がコマンドとして読むので、`send` は断る。goal は `--goal` の形で送る（`start` の `--goal` と同じ確かめをし、`working`・`idle`・`done` のときに送る）。
- JSON は `{name, status}`（`--goal` では `goal: "sent"` が付く）。`status` が `working` なら「終わるのを待つ」に進み、`blocked` なら「止まった Agent に答える」に進む。

### 終わるのを待つ

- 指示を送って `working` を確かめたあとに、`<scripts>/agent-report --wait <名前>` を単独で、Bash の background 実行で、`timeout` を `86400000`（24 時間）にして走らせる。`timeout` を付けないと、Claude Code は background のコマンドを 30 分で止める。`working` を確かめる前に走らせると、まだ指示を受けていない `idle` の Agent ですぐ返る。
- `--wait` は、Agent が `idle` か `done` で止まると返る。最後の発言に `## 変更の要約` の行（`karrybit:completion-report` の最初の見出し）があればすぐに返り、なければターンの合間かもしれないので 1 分待ち、Agent が作業に戻らなければ `no-report` で返る。ブリーフと送る指示には、`karo:delegate` skill の「依頼に毎回書く決まり」の完了の報告の行を書く。
- `--wait` は、transcript の最後の発言のあとに結果のない tool 呼び出し（AskUserQuestion や承認のダイアログ）があれば、Herdr が `idle` か `done` と出していても、すぐに `awaiting-answer` で返る。
- `--wait` は、一度返した停止をもう一度は返さない。同じ停止のまま走らせ直すと、Agent が次に止まるまで待つ（走らせ直す前に終わっていた停止は、すぐに返す）。
- 待つ間は、終了の通知を待ち、foreground では呼び出し側の次の作業を進める。
- 終了の通知が来たら、出力の 1 行目の `status:` で分ける。
  - `idle` か `done`: 2 行目からが Agent の完了の報告なので、呼び出し側に渡す。
  - `no-report`: Agent が見出しのない発言のまま 1 分止まった。2 行目からが最後の発言なので読む。自分の裏の作業（テストや評価の実行、サブエージェント）を待っているだけなら、`agent-report --wait` を走らせ直す。質問か途中の報告なら、呼び出し側が答えか次の指示を決めて `agent-ctl send` で送る。完了の報告の書き忘れなら、`karrybit:completion-report` の見出しで報告を書くよう `agent-ctl send` で送る。送ったときは、`working` を確かめてから待ち直す。どれか決められないときは、最後の発言を人に伝える。
  - `awaiting-answer`: Agent が tool 呼び出しへの答えを待っている。2 行目からが待っている呼び出し（AskUserQuestion は `AskUserQuestion` の行のあとに、問いごとに `[<header>] <問い> (multiSelect: …)` と `- <label>: <description>`、ほかの tool は `<名前>: <入力>`）なので読み、「止まった Agent に答える」に進み、`working` を確かめてから待ち直す。
  - `blocked`: 「止まった Agent に答える」に進み、`working` を確かめてから待ち直す。
  - `working`（待つのに失敗して早く返った）: `agent-report --wait` を走らせ直す。2 回続いたら、`herdr agent get <Agent 名>` の結果を人に伝える。
  - `unknown` か `error`（pane が閉じた、Herdr が答えない）: `herdr agent get <Agent 名>` の結果を人に伝える。
  - `status:` の行がない（時間の上限で止められた）: `agent-report --wait` を走らせ直す。

### 報告を取り出す

- 通知を受け取れなかったとき（会話を再開したあとなど）は、`<scripts>/agent-report <名前>` を単独で走らせる。待たずに、その Agent の transcript の最後の発言を出す。

### 閉じる

- 片付けるときは、`<scripts>/agent-ctl close <名前>` を単独で走らせる。`close` は `start` が控え（`~/.local/state/herdr-agent/ledger`）に書いた Agent だけを片付け、控えにない名前は 1 行で断る。断られた Agent は、人が手で片付ける。
- `close` は、控えにある workspace（`tab` では tab）の label が名前であること、呼び出し側の workspace（`tab` では tab）でないこと、`working`・`blocked` の Agent がいないことを確かめる。`tab` のほかは、さらに submodule がないこと、未 commit の変更がないこと、場所の種類ごとの取り込み済みの条件（「起動する」の表）を確かめる。
- worktree を消す場所では、すべての確かめを通ったあとに、`close` が `git clean -fdX` で ignored なファイル（`.venv`、`node_modules`、cache、`.claude/` の下の Claude Code の記録）を消してから worktree を消す。確かめのどれかで止まったときは、何も消さない。
- JSON は `{name, kind, workspace, place, parent}` で、`tab` と `parent_kept`（閉じなかった親の workspace と理由）が付くことがある。`parent_kept` があれば、それも人に伝える。
- origin のブランチは、`close` が `git ls-remote` で origin にいまの先頭を尋ねて確かめる。手元の `origin/<ブランチ>` は使わないので、push のあとに fetch は要らない。origin に届かなければ、`close` はその理由の 1 行で止まる。
- origin の先頭の commit が手元にないブランチ（ほかから push された）とは比べないので、そのブランチにだけ入っている commit で止まったら、fetch してから呼び直す。
- 取り込まれていない commit で止まったら、取り込んでから呼び直す。

## 止まった Agent に答える

1. `herdr agent read <Agent 名>` で画面を読む。承認のダイアログは、コマンドの全文を読み、スクリプトを動かすものはそのスクリプトの中身も読む。AskUserQuestion は、問いのタブの行、選択肢の並びとカーソルの位置、画面の下のキーの案内を読み、`awaiting-answer` の出力の問いと選択肢の説明と合わせる。
   完了条件: ダイアログの種類と、承認するコマンドの全文か、すべての問いと選択肢が手元にある。
2. 答えを決める。承認のダイアログは、呼び出し側が渡した「答えてよいダイアログの一覧」に合えば Yes と決め、一覧にないもの、どれにあたるか迷うものは人に尋ねる。AskUserQuestion は、依頼とブリーフから答えが決まる問いには呼び出し側が答えを決め、決まらない問いは人に尋ねる。
   完了条件: 送る答えが決まったか、人に尋ねている。
3. 答えを送る。
   - 承認のダイアログの Yes: `blocked` の Agent には `<scripts>/safe-key enter <名前>` で送る（`safe-key` は `blocked` の Agent にだけ Enter を送り、答えのない AskUserQuestion が transcript にある Agent には送らない）。`awaiting-answer` で返った `idle` か `done` の Agent には、`herdr agent send-keys <Agent 名> Enter` で送る。
   - 起動時の信頼のダイアログ（既定の選択が「No, exit」）: 人が信頼すると答えたら、`herdr agent send-keys <Agent 名> Down Enter` で「Yes, I trust this folder」を選ぶ。Enter だけを送ると「No, exit」が選ばれて Claude が終わる。`start` が `not_ready` で終わったときはブリーフが届いていないので、Agent が `idle` になってから、ブリーフの文を `agent-ctl send` で送る。
   - AskUserQuestion の選択肢: `herdr agent send-keys <Agent 名>` で `Down` か `Up` をカーソルが答えに来る回数だけ送ってから `Enter` を送る。multiSelect の問いでは、画面の下のキーの案内に従って、答えの選択肢をすべて選ぶ。
   - AskUserQuestion の自由記述: カーソルを `Other` の行（`Type something` と出る）に合わせ、`herdr pane send-text <pane> <答えの文>` で文を打ってから `Enter` を送る。`<pane>` は `herdr agent get <Agent 名>` の `pane_id`。
   - AskUserQuestion の複数の問い: 上のタブの行を `Tab`（次）か `Shift+Tab`（前）で動き、問いごとに答える。最後の「Review your answers」の画面で「Submit answers」を選ぶと、答えが Agent に届く。

   キーを送るたびに `herdr agent read` で画面を確かめる。
   完了条件: 答えを送ったか、答えが要らなかった。
4. `herdr agent read <Agent 名>` で画面が次に進んだことを確かめ、「終わるのを待つ」に戻る。
   完了条件: background の `agent-report --wait` が走っている。

- foreground がページャ（`less`・`glow`）の pane には、`<scripts>/safe-key quit <pane>` で q を送る。
- `safe-key` は呼び出し側の pane には送らない。ほかのキーと文字（`herdr agent send-keys`、`herdr pane send-keys`、`herdr pane send-text`）には、毎回確認が出る。

## Herdr を触る Agent のブリーフに足す決まり

起動する Agent の作業が Herdr を触るときは、ブリーフの制約に次を書く。

- 試しに作る Herdr の workspace は、label を `-test` で終わる名前にし、自分で作ったものだけをまとめて閉じる。
- 試しのリポジトリ（scratchpad の使い捨ての git リポジトリなど）で Claude を起動して確かめるときは、Herdr の対話の Agent ではなく `claude -p` を使う。`-p` は信頼のダイアログを出さず、独立したリポジトリは親のフォルダの信頼を受け継がないので、対話で起動すると毎回信頼のダイアログで止まる。Herdr での起動そのものを確かめるときだけ、対話の Agent を使う。
- Herdr の考え方は `herdr --skill`、書式は `herdr <グループ>` の出力で確かめる。
- herdr のコマンドは単独で呼び、出力の加工は次の呼び出しで行う。
- `dangerouslyDisableSandbox` を付けるのは、`sandbox.excludedCommands` にないコマンド（`herdr --session` など）と、検証の script の実行だけにする。git の push・fetch と `gh` は sandbox の中で通るので付けずに呼び、失敗したらエラー文を報告する。
- `ps`・PTY・herdr の server が要る検証（使い捨ての Herdr など）は、起動から片付けまでを 1 つの script にまとめ、`dangerouslyDisableSandbox` は実行の呼び出しだけに付ける。
