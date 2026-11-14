---
name: crit
description: crit をブラウザで開き、ユーザーが付けたコメントに返事をする手順。引数なしなら起動した場所のファイルを、GitHub の PR の URL を渡すとその PR を、PR になっていないブランチか commit を渡すとその差分を開く。ユーザーが /karrybit:crit を打ったとき、crit でコメントしたいと言ったときに使う。
allowed-tools: Bash(crit .), Bash(crit --session *), Bash(crit comments *), Bash(crit comment *), Bash(crit stop), Bash(crit -p *), Bash(CRIT_PORT=0 crit *), Bash(echo *), Bash(cksum), Read
argument-hint: "[GitHub の PR の URL | PR になっていないブランチ | commit]"
---

# crit でコメントを受け取る

## 開くもの

| `$ARGUMENTS` | 開くもの | 動かすコマンド | ポート |
| --- | --- | --- | --- |
| なし | 起動した場所のファイルすべて | 起動した場所で `crit .` | 起動した場所の `.crit.config.json` の `port`（固定） |
| GitHub の PR の URL | その PR の差分 | `cd <checkout> && crit -p <ポート> --pr <URL>` | 「ポートを決める」で URL から決める |
| PR になっていないブランチ | そのブランチの差分 | `cd <worktree> && crit -p <ポート>` | 「ポートを決める」で `<worktree> <ブランチ>` から決める |
| 1 つの commit | その commit の差分 | `cd <checkout> && crit -p <ポート> --range <commit>^..<commit>` | 「ポートを決める」で `<commit>^..<commit>` から決める |

- 引数なしの `crit .` は、同じ場所で起動し直した `crit .` と同じセッションにつながるので、URL もコメントも変わらない。
- PR は、PR のリポジトリの checkout から `--remote` を付けずに開く。GitHub の PR では、crit がファイルの一覧と差分を起動した場所の git で作る（`--remote` で API から読むのはファイルの中身だけ）ので、ほかのリポジトリから開くとそのリポジトリの作業ツリーが出る。
- `<checkout>` は、呼び出し側がその PR か commit のブランチの worktree か checkout のパスを渡せばそれを使う。渡されなければ、その PR のリポジトリを checkout している場所をユーザーに尋ねる。PR のブランチを checkout しておく必要はない。
- `<worktree>` は、呼び出し側が渡したそのブランチの worktree にする。渡されなければ、そのブランチを checkout している場所をユーザーに尋ねる。
- PR になっていないブランチは、範囲を付けずにブランチを checkout した worktree で開く。crit は、`origin/HEAD` が指す既定のブランチとの merge-base からの差分を出し、session を worktree のパスとブランチで決めるので、commit を足しても rebase しても同じ session と URL のままコメントと返事が残り、手順 5 で次の回に進む。`--range` で開くと session が SHA で決まり、次の回に進めない。
- crit は PR の head と `--range` の先を daemon の起動時にしか読まず、reload でも `crit --session` でも新しい commit は出ない。そこで PR と 1 つの commit を開く前に毎回、同じ checkout で `cd <checkout> && crit stop` を動かす。daemon が動いていなければ `no running daemon found` で終わるので、そのまま表のコマンドに進む。同じ checkout から同じ対象を開けば、session の ID とコメントとポートは変わらない。
- PR になっていないブランチの daemon は、レビューを終えるまで止めずに残す。止めて起動し直すと、同じ session で新しい commit までの差分は出るが、回は進まない。
- daemon は `cd <checkout> && crit stop`（ブランチは `cd <worktree> && crit stop`）で checkout ごとに止める。`crit stop --all` はほかの checkout の `crit .` も止める。
- PR の番号だけを渡されたら、リポジトリが決まらないので、ユーザーに PR の URL を尋ねる。
- 表の対象はそれぞれ別のセッション（ポートもコメントの保存先も別）になる。2 つ以上が動いていると、`--session` のない `crit comments` と `crit comment` はどちらのセッションか決められずに止まるので、この手順の crit のコマンドにはすべて `--session <id>` を付ける。

## ポートを決める

- PR、PR になっていないブランチ、1 つの commit のポートは、表の「ポート」の列にある対象の文字列から決め、同じ対象なら毎回同じポートで開く。crit は `port` を設定ファイルでしか持たず、対象ごとのポートを覚えない。
- `echo '<対象の文字列>' | cksum` を 1 回の Bash で動かし、出力の最初の数の下 4 桁の前に `4` を付けた数（40000〜49999）をポートにする。例: `1395210200 18` なら `40200`。
- crit が `bind: address already in use` で終わったら、ほかのプロセスがそのポートを使っている。表のコマンドの `-p <ポート>` を `CRIT_PORT=0` に替えてランダムなポートで開き、ポートが変わったことをユーザーに伝える（`-p 0` は設定の `port` に戻ってしまう）。

## 手順

1. 上の表のコマンドを、Bash の `run_in_background: true` と `timeout: 86400000` で動かす（引数なしのほかは、先に「ポートを決める」でポートを決める。PR と 1 つの commit なら、そのあと `crit stop` を動かす）。timeout を付けないと、Claude Code が 30 分で crit を止める。
   完了条件: crit の出力にある review の URL が手元にある。
2. review の URL（`http://localhost:<ポート>`）のポートを crit-open に渡し、ほかのコマンドとつながない 1 回の Bash で動かしてブラウザで開く（どの対象でも）。crit-open は、この plugin を配る場所の `~` の形の `~/.config/claude/skills/karrybit/skills/crit/scripts/crit-open <ポート>` で呼ぶ。crit-open は、settings でこの `~` の形を許可し sandbox の外で動く形として除外したときに `open` を動かせる（`${CLAUDE_SKILL_DIR}/scripts/crit-open-test <settings.json>` で確かめられる）。settings の規則はコマンドの文字列をそのまま照らすので、絶対パスで呼ぶと `~` の形の規則に合わず、つなぐと sandbox の中に残って `open` が止められる。そのうえで URL をユーザーに伝え、「コメントを付けて Finish Review を押してください」と返して、background の crit が終わるのを待つ。レビューのファイルは、crit が終わってから読む。
   完了条件: background の crit が終わった。
3. crit の stdout を読み、その指示と、次に動かすコマンド（`crit --session <id>`）を控える。stderr の `approved: true` か `approved: false` を見る。stdout にコメントがなければ `crit comments --session <id> --json` で読む。
   完了条件: session の ID と、未解決のコメントの一覧（0 件でもよい）が手元にある。
4. 未解決のコメントごとに、求めていることに対応し、返事を書く。
   - `quote` があれば、その範囲に絞って読む。行番号は古いことがあるので、場所は `anchor` で探す。`drifted: true` なら、行番号はおおよそとして扱う。
   - 返事は `crit comment --session <id> --reply-to <コメントの ID> --author 'Claude Code' '<したこと>'` で書く。返事が複数なら、`[{"reply_to": "<ID>", "body": "<したこと>"}]` の JSON を scratchpad に書き、`crit comment --session <id> --json --file <その path> --author 'Claude Code'` で 1 回で書く。
   - コメントの解決はユーザーが決めるので、`--resolve` はユーザーが頼んだときだけ付ける。

   完了条件: 未解決のコメントすべてに返事がある。
5. 引数なしと PR になっていないブランチなら、3 で控えた `crit --session <id>` を 1 と同じ形で動かす（ブランチは、足された commit が差分に出て、回が 1 つ進む）。PR と 1 つの commit なら、push された commit を差分に出すために 1 から同じポートで開き直す。そのうえでユーザーに「crit に返事を書きました。ブラウザで確かめて Finish Review を押してください」とだけ返す。crit が終わったら 3 に戻る。
   完了条件: 3 で未解決のコメントが 0 件だった（ユーザーがコメントなしで Finish Review を押した）。

## 困ったとき

- crit が `operation not permitted` で落ちたら、sandbox が `~/.crit` への書き込みか待ち受けを止めている。settings の `sandbox` に `filesystem.allowWrite` の `~/.crit` と `network.allowLocalBinding: true` があるかを確かめ、なければユーザーに足してもらう。
- PR の差分ではなく checkout の作業ツリーが出て、crit の出力に `failed to apply focus` があれば、PR の SHA が手元になく、sandbox が crit の `git fetch` を止めている。`git -C <checkout> fetch origin` を sandbox の外で動かす承認をユーザーに求め、1 から開き直す。
- Approve のあとタブが閉じず「Approved — you can close this tab」と出たら、ユーザーにタブを閉じてもらう。
- Claude Code が background の時間の上限（既定で 2 時間）で crit を止めたら、コメントはブラウザに残っているとユーザーに伝え、待ち続けるときは同じコマンドを 1 と同じ形で動かし直す。
