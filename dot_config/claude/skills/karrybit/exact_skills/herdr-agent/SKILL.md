---
name: herdr-agent
description: Herdr で別のセッションの Claude Code の Agent を起動し、指示を送り、終わるのを待ち、報告を取り出し、閉じる手順と scripts。Herdr の Agent に作業を任せるとき、動いている Agent に指示を足すとき、止まった Agent のダイアログに答えるとき、終わった Agent を片付けるときに使う。
---

# Herdr の Agent を動かす

## 範囲

- この skill は、Herdr の Agent の 5 つの操作（起動、指示の送信、終わるのを待つ、報告を取り出す、閉じる）と、止まった Agent に答える手順を受け持つ。
- 呼び出し側は、Agent の名前、ブリーフのファイル、作業する場所、goal の条件、permission mode、答えてよいダイアログの一覧を決めて渡す。ブリーフの中身、報告の読み方、作業の取り込みは呼び出し側が持つ。
- 下の `<scripts>` は `~/.config/claude/skills/karrybit/skills/herdr-agent/scripts` で、呼ぶときはこの `~/` の形のまま書く。settings の規則はコマンドの文字列をそのまま照らすので、絶対パスや `$HOME` で書くと規則に合わず、確認が出るか sandbox に残る（`herdr-call-check` が止める）。

## 呼び出し側が先に整える settings

呼び出し側の `.claude/settings.json` に次の値を置く。

| 場所 | 値 |
| --- | --- |
| `permissions.allow` | `Bash(<scripts>/agent-ctl *)`、`Bash(<scripts>/agent-report *)`、`Bash(<scripts>/safe-key *)` |
| `sandbox.excludedCommands` | `<scripts>/agent-ctl *`、`<scripts>/agent-report *`、`<scripts>/safe-key *` |
| `hooks.PreToolUse`（`matcher: Bash`） | `command` が `<scripts>/herdr-call-check` の hook |
| `env` の `HERDR_AGENT_NAME_PATTERN`（必須） | 名前が合うべき ERE（`^` と `$` で囲む）。`agent-ctl` のすべてと `safe-key enter` が使い、未設定なら `safe-key enter` は何も送らない |
| `env` の `HERDR_AGENT_BRANCH_PATTERN`（任意） | `worktree` と `herdr-worktree` で作るブランチが合うべき ERE |
| `env` の `HERDR_AGENT_BRANCH_DENY`（任意） | そのブランチが合ってはいけない ERE |

- 表の `<scripts>` は、上の `~/` の形の文字列に置き換えて書く。
- `env` は、sandbox の中の Agent が書き換えられない settings に置く。呼び出しの先頭に `VAR=x` を付けると `allow` の規則に合わなくなるので、env の値は呼び出しのたびに変えられない。
- herdr 自体の `workspace close`・`tab close`・`worktree remove`・`agent prompt`・`agent send-keys`・`pane send-keys`・`pane send-text` は `allow` に入れない。scripts は確かめてから herdr を呼ぶので許可でき、herdr 自体は確認を出したままにする。
- settings を確かめるときは、`<scripts>/agent-ctl-test <settings.json>` を Herdr の中で sandbox の外で走らせる。表の値の有無と、herdr 自体の上の操作が `allow` に当たらないことを確かめ、足りない行は 1 行ずつ `FAIL` で出る。

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
| `dir <パス> [<ブランチ>]` | 既存の main checkout をそのまま使う。`<ブランチ>` を渡すと、その上にいることを確かめる | `<ブランチ>`（渡さなければ HEAD）に remote にない commit がない | workspace（checkout は残る） |
| `worktree <repo> <base> <ブランチ> <パス>` | `<repo>` の `<base>` から `git worktree add -b <ブランチ> <パス>` で作る | worktree の HEAD が `<base>` に入っている | worktree（ブランチは残る）と workspace |
| `herdr-worktree <repo> <ブランチ>` | `herdr worktree create` で作る | HEAD が remote にある | worktree、workspace、`start` が開いた親の workspace |
| `tab <Agent の名前>` | その Agent の workspace に tab を足し、その Agent と同じ cwd で起動する | なし | tab |

- パスと `<repo>` は絶対パスで渡す。
- `start` は、label が `<名前>` の workspace（`tab` では tab）を作り、`claude -n <名前>` を Agent `<名前>` として起動し、ブリーフを送る。
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
- 待つ間は、終了の通知を待ち、foreground では呼び出し側の次の作業を進める。
- 終了の通知が来たら、出力の 1 行目の `status:` で分ける。
  - `idle` か `done`: 2 行目からが Agent の最後の発言（完了の報告）なので、呼び出し側に渡す。
  - `blocked`: 「止まった Agent に答える」に進み、`working` を確かめてから待ち直す。
  - `working`（待つのに失敗して早く返った）: `agent-report --wait` を走らせ直す。2 回続いたら、`herdr agent get <名前>` の結果を人に伝える。
  - `unknown` か `error`（pane が閉じた、Herdr が答えない）: `herdr agent get <名前>` の結果を人に伝える。
  - `status:` の行がない（時間の上限で止められた）: `agent-report --wait` を走らせ直す。

### 報告を取り出す

- 通知を受け取れなかったとき（会話を再開したあとなど）は、`<scripts>/agent-report <名前>` を単独で走らせる。待たずに、その Agent の transcript の最後の発言を出す。

### 閉じる

- 片付けるときは、`<scripts>/agent-ctl close <名前>` を単独で走らせる。`close` は `start` が控え（`~/.local/state/herdr-agent/ledger`）に書いた Agent だけを片付け、控えにない名前は 1 行で断る。断られた Agent は、人が手で片付ける。
- `close` は、控えにある workspace（`tab` では tab）の label が名前であること、呼び出し側の workspace（`tab` では tab）でないこと、`working`・`blocked` の Agent がいないことを確かめる。`tab` のほかは、さらに submodule がないこと、未 commit の変更がないこと、場所の種類ごとの取り込み済みの条件（「起動する」の表）を確かめ、worktree を消す場所では ignored なファイルがないことも確かめる。
- JSON は `{name, kind, workspace, place, parent}` で、`tab` と `parent_kept`（閉じなかった親の workspace と理由）が付くことがある。`parent_kept` があれば、それも人に伝える。
- 取り込まれていない commit で止まったら、取り込んでから呼び直す。
- ignored なファイルで止まったら、行に消す候補のパスがすべて並ぶ（ignored なフォルダは 1 つにまとまる）。この一覧を人に示して、消すかを決めてもらう。消したら `close` を呼び直す。

## 止まった Agent に答える

1. `herdr agent read <名前>` で画面を読む。承認のダイアログは、コマンドの全文を読み、スクリプトを動かすものはそのスクリプトの中身も読む。
   完了条件: ダイアログの種類と、承認するコマンドの全文が手元にある。
2. 答えを決める。呼び出し側が渡した「答えてよいダイアログの一覧」に合う承認のダイアログには、`<scripts>/safe-key enter <名前>` で Yes を送る（`blocked` の Agent にだけ Enter を送る）。一覧にないもの、どれにあたるか迷うものは、人に尋ねる。
   完了条件: `safe-key` を送ったか、人に尋ねている。
3. 人の答えを送る。起動時の信頼のダイアログ（既定の選択が「No, exit」）で人が信頼すると答えたら、`herdr agent send-keys <名前> Down Enter` で「Yes, I trust this folder」を選ぶ。Enter だけを送ると「No, exit」が選ばれて Claude が終わる。`start` が `not_ready` で終わったときはブリーフが届いていないので、Agent が `idle` になってから、ブリーフの文を `agent-ctl send` で送る。AskUserQuestion の選択肢には、`herdr agent read` で並びとカーソルの位置を読み、`herdr agent send-keys <名前>` で `Down` か `Up` をカーソルが答えに来る回数だけ送ってから `Enter` を送る。
   完了条件: 人の答えを送ったか、答えが要らなかった。
4. `herdr agent read <名前>` で画面が次に進んだことを確かめ、「終わるのを待つ」に戻る。
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
