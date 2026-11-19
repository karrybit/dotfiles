---
name: crit
description: crit でレビューを起動して review の URL を返し、ユーザーが付けたコメントに返事をする手順。引数なしなら起動した場所のファイルを、GitHub の PR の URL を渡すとその PR を、PR になっていないブランチか commit を渡すとその差分を開く。ユーザーが /karrybit:crit を打ったとき、crit でコメントしたいと言ったときに使う。
allowed-tools: Bash(crit .), Bash(crit --session *), Bash(crit comments *), Bash(crit comment *), Bash(crit stop), Bash(crit stop .), Bash(crit), Bash(crit --pr *), Bash(crit --range *), Read
argument-hint: "[GitHub の PR の URL | PR になっていないブランチ | commit]"
---

# crit でコメントを受け取る

## 開くもの

| `$ARGUMENTS` | 開くもの | 動かすコマンド |
| --- | --- | --- |
| なし | 起動した場所のファイルすべて | 起動した場所で `crit .` |
| GitHub の PR の URL | その PR の差分 | `cd <checkout> && crit --pr <URL>` |
| PR になっていないブランチ | そのブランチの差分 | `cd <worktree> && crit` |
| 1 つの commit | その commit の差分 | `cd <checkout> && crit --range <commit>^..<commit>` |

- ポートは、crit が daemon を起動するたびに空いているものから選ぶ。review の URL は crit の出力から取る。
- 引数なしの `crit .` は、同じ場所で起動し直した `crit .` と同じセッションにつながるので、コメントは変わらない。
- PR は、PR のリポジトリの checkout から `--remote` を付けずに開く。GitHub の PR では、crit がファイルの一覧と差分を起動した場所の git で作る（`--remote` で API から読むのはファイルの中身だけ）ので、ほかのリポジトリから開くとそのリポジトリの作業ツリーが出る。
- `<checkout>` は、呼び出し側がその PR か commit のブランチの worktree か checkout のパスを渡せばそれを使う。渡されなければ、その PR のリポジトリを checkout している場所をユーザーに尋ねる。PR のブランチを checkout しておく必要はない。
- `<worktree>` は、呼び出し側が渡したそのブランチの worktree にする。渡されなければ、そのブランチを checkout している場所をユーザーに尋ねる。
- PR になっていないブランチは、範囲を付けずにブランチを checkout した worktree で開く。crit は、`origin/HEAD` が指す既定のブランチとの merge-base からの差分を出し、session を worktree のパスとブランチで決めるので、commit を足しても rebase しても同じ session と URL のままコメントと返事が残り、手順 5 で次の回に進む。`--range` で開くと session が SHA で決まり、次の回に進めない。
- crit は、`crit .` のファイルの一覧と、PR の head と `--range` の先を daemon の起動時にしか読まず、reload でも `crit --session` でも、足したファイルや新しい commit は出ない。そこで引数なし・PR・1 つの commit を開く前に毎回、起動した場所で `crit stop .`（PR と 1 つの commit は `cd <checkout> && crit stop`）を動かす。daemon が動いていなければ `no running daemon found` で終わるので、そのまま表のコマンドに進む。同じ checkout から同じ対象を開けば、session の ID とコメントは変わらない。
- PR になっていないブランチの daemon は、レビューを終えるまで止めずに残す。止めて起動し直すと、同じ session で新しい commit までの差分は出るが、回は進まない。
- daemon は `cd <checkout> && crit stop`（ブランチは `cd <worktree> && crit stop`）で checkout ごとに止める。`crit stop --all` はほかの checkout の `crit .` も止める。
- PR の番号だけを渡されたら、リポジトリが決まらないので、ユーザーに PR の URL を尋ねる。
- 表の対象はそれぞれ別のセッション（ポートもコメントの保存先も別）になる。2 つ以上が動いていると、`--session` のない `crit comments` と `crit comment` はどちらのセッションか決められずに止まるので、この手順の crit のコマンドにはすべて `--session <id>` を付ける。

## 手順

1. 上の表のコマンドを、Bash の `run_in_background: true` と `timeout: 86400000` で動かす（引数なし・PR・1 つの commit なら、先に「開くもの」の `crit stop` を動かす）。timeout を付けないと、Claude Code が 30 分で crit を止める。
   完了条件: crit の出力にある review の URL が手元にある。
2. crit の出力の review の URL（`http://localhost:<ポート>`）を返す。呼び出し側の規則（`CLAUDE.md`・`AGENTS.md`）に review の URL の開き方があれば、その規則のとおりに開く。なければ URL をユーザーに示し、ユーザーにブラウザで開いてもらう。そのうえで「コメントを付けて Finish Review を押してください」と返して、background の crit が終わるのを待つ。レビューのファイルは、crit が終わってから読む。
   完了条件: background の crit が終わった。
3. crit の stdout を読み、その指示と、次に動かすコマンド（`crit --session <id>`）を控える。stderr の `approved: true` か `approved: false` を見る。stdout にコメントがなければ `crit comments --session <id> --json` で読む。
   完了条件: session の ID と、未解決のコメントの一覧（0 件でもよい）が手元にある。
4. 未解決のコメントごとに、求めていることに対応し、返事を書く。
   - `quote` があれば、その範囲に絞って読む。行番号は古いことがあるので、場所は `anchor` で探す。`drifted: true` なら、行番号はおおよそとして扱う。
   - 返事は `crit comment --session <id> --reply-to <コメントの ID> --author 'Claude Code' '<したこと>'` で書く。返事が複数なら、`[{"reply_to": "<ID>", "body": "<したこと>"}]` の JSON を scratchpad に書き、`crit comment --session <id> --json --file <その path> --author 'Claude Code'` で 1 回で書く。
   - コメントの解決はユーザーが決めるので、`--resolve` はユーザーが頼んだときだけ付ける。

   完了条件: 未解決のコメントすべてに返事がある。
5. 引数なしと PR になっていないブランチなら、3 で控えた `crit --session <id>` を 1 と同じ形で動かす（ブランチは、足された commit が差分に出て、回が 1 つ進む）。PR と 1 つの commit なら、push された commit を差分に出すために 1 から開き直す。crit の出力の URL のポートが 2 で返したものと違えば、2 と同じく新しい URL を返す。そのうえでユーザーに「crit に返事を書きました。表示された画面で確かめて Finish Review を押してください」とだけ返す。crit が終わったら 3 に戻る。
   完了条件: 3 で未解決のコメントが 0 件だった（ユーザーがコメントなしで Finish Review を押した）。

## 困ったとき

- crit が `operation not permitted` で落ちたら、sandbox が `~/.crit` への書き込みか待ち受けを止めている。settings の `sandbox` に `filesystem.allowWrite` の `~/.crit` と `network.allowLocalBinding: true` があるかを確かめ、なければユーザーに足してもらう。
- PR の差分ではなく checkout の作業ツリーが出て、crit の出力に `failed to apply focus` があれば、PR の SHA が手元になく、sandbox が crit の `git fetch` を止めている。`git -C <checkout> fetch origin` を sandbox の外で動かす承認をユーザーに求め、1 から開き直す。
- Claude Code が background の時間の上限（既定で 2 時間）で crit を止めたら、コメントは開いている crit の画面に残っているとユーザーに伝え、待ち続けるときは同じコマンドを 1 と同じ形で動かし直す。
