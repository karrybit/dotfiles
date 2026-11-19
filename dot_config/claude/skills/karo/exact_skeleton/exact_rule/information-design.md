# 記録の置き場所と探し方

記録の置き場所を決めるとき、記録を探すとき、セッション開始と compact のあとに状況を読むときに読む。層・lineage・鮮度・探し方の考え方は `karrybit:data-information-design` skill にあり、このファイルはその skill が受け取る karo の値（層の置き場所、置き場所の補足、lineage の書き方、探す表、検証）を持つ。置き場所の表は `AGENTS.md` の「書き込み先」にある。パスはこのリポジトリの root からのパスで書く。

## 層の置き場所

| 層 | 置き場所 |
| --- | --- |
| Bronze | `project/repo/<vcs>/<org>/<repo>/review/`（レビューの原本）、`investigation/YYYY-MM-DD-<話題>/sources/`。外の原文は URL だけ |
| Silver | Beads（`.beads`。タスク・判断待ち・タスクかプロジェクトに閉じた決定とタスクの出来事）、`decisions/`（karo の長い目の決定）、`source/meeting/` の MTG の記録、`investigation/`（`sources/` を除く）、`project/repo/<vcs>/<org>/<repo>.md`、`project/misc/<theme>.md` |
| Gold | `$KARO_STATE_HOME/state.md`、`standup/`、`doc/`、`project/misc/<theme>/YYYY-MM-DD-<資料名>.md`、`project/design/YYYY-MM-DD-design-doc-<話題>.md` |

- `type` と層の対応、`type` と置き場所の対応は、`rule/frontmatter-schema.yaml` の `layers` と `paths` が正本。

## 置き場所の補足

| 情報 | 書き方 |
| --- | --- |
| 外の原文（チャット、議事録、チケット、PR） | 使うノートの `sources` か、記録の commit の本文に URL を書く |
| 外に送った文面 | そのタスクの bead の notes に、要旨 1 行と送った先の permalink を書く（`karo:tasks` skill の「項目の対応」） |
| MTG で決まったこと | `source/meeting/YYYY-MM-DD-<MTG>.md` の「決定」「宿題」の見出しの下 |
| 調べた結果 | 調査の中にオーナーに決めてほしいことがあれば、decision の bead を起票してその ID を書き添える |
| 実現したいこと（機能）の設計の案（ADR と spec に反映する前） | Design Doc（日付は作った日）。決定は反映先のリポジトリの ADR に、今の仕様は spec に反映し、その PR の URL をすべてタスクの comment に書いてから、Design Doc を消す。反映先は、その機能が変えるリポジトリのすべてで、複数になることがある |
| プロジェクトの運用の約束 | 今の状態と効く決定の一覧は書かない（Beads の label `project:<name>` で引き、karo 自身の長い目の決定は `decisions/` で引く） |
| リポジトリを持たない話題の手順 | 日付は作った日で、直しても名前を変えない |

## Lineage の書き方

| 書くもの | 書き方 |
| --- | --- |
| 外の原文 | フロントマターの `sources` に `{ id, resource, title }`。Investigation は本文で読んだものをここに写す |
| 本文の中のノートへのリンク | `[<名前>](<root からのパス>)`（例: `[リリースの手順](project/misc/work/2026-01-05-release.md)`） |

## 探す

- コマンドはこのリポジトリの root で実行する。`bd` は単独の呼び出しにする（`karo:tasks` skill の「呼び方」）。
- 全文検索は、Beads は `karo:tasks` skill の「タスクを進める」の 1、ファイルは `rg -n '<語>' standup source investigation decisions`、commit の本文は `git log -i --grep '<語>'` で行う。
- タスク ID の正規表現は `[A-Za-z][A-Za-z0-9]*(-[A-Za-z0-9]+)+(\.[0-9]+)*` にする。

| 問い | 手順（1 行が 1 回の呼び出し） |
| --- | --- |
| セッション開始・compact 後（`AGENTS.md` の「セッション開始時と compact 後」の 1 の読み方） | SessionStart の hook の出力（`state.md`、Beads の一覧）。hook の出力に Beads の一覧がなければ、下の「タスクの今の一覧」の行の「開いているタスク」と「判断待ち」 |
| タスクの今の一覧（開いている・判断待ち・着手できる・止まっている・ある日から閉じた・作った・動いた・動いていない） | `karo:tasks` skill の「今の状況を読む」の表 |
| タスクの経緯と今の状態 | `bd show <タスクID> --json --include-comments`、続けて `bd history <タスクID> --events --json`、続けて `rg -n <タスクID> "${KARO_STATE_HOME:-${XDG_STATE_HOME:-$HOME/.local/state}/karo}/state.md"; rg -lUP '\A---\n(?:(?!---\n).*\n)*?tasks:\n(?:  - .+\n)*  - <タスクID>\n' -g '!investigation/*/sources/**' .` |
| 過去の会話 | `karo:recall` skill |
| タスクの分析（依存・ボトルネック・次の候補） | `karo:tasks` skill の「分析する（bv）」 |
| ある日からの出来事 | `karo:tasks` skill の「今の状況を読む」の表の「ある日から動いたタスク」、続けて `git log --since YYYY-MM-DD`（運用の出来事は commit の本文にある） |
| 委任するプロジェクトに効く決定と運用 | `cat project/*/<name>.md`、続けて `bd list --all --type decision --status closed --label-any project:<name>,project:all --json`、続けて `bd dep list <それらの ID> --direction up --type supersedes --json`（返った ID は置き換え済み）。karo の仕組みを変える委任では、下の「karo の今の長い目の決定」も読む |
| karo の今の長い目の決定 | `rg -L '^status: deprecated$' decisions`（置き換え済みを除いた一覧）。理由と出典はそのファイルの本文 |
| karo の長い目の決定を語で探す | `rg -n '<語>' decisions` |
| タスクとプロジェクトの決定を語で探す | `bd list --all --type decision --desc-contains '<語>' --json`（決定の文は本文にあり、comment は検索されない） |
| Beads の決定の理由と出典 | `bd show <決定の ID> --json` |
| MTG で決まったこと | `rg -n -A6 '^#+ (決定\|宿題)' source/meeting/YYYY-MM-DD-*.md` |
| プロジェクトの現状 | `cat project/*/<name>.md`、開いているタスクは上の「タスクの今の一覧」の「開いているタスク」に `--label project:<name>` を足す、効く決定は上と同じ |
| HTML の解説（作る前） | `karo:explain` skill の 1 と 2 |
| 人に渡す資料の最新版 | `cat doc/<話題>.md`。前の版は `git log -p -- doc/<話題>.md` |
| 外に作ったもの・送った文面 | `bd list --all --notes-contains '<ID か URL の一部か相手>' --json`、続けて `bd list --all --desc-contains '<ID か URL の一部か相手>' --json`、続けて `rg -n '<ID か URL の一部か相手>' standup source` |
| 調査の原文 | `investigation/YYYY-MM-DD-<話題>/map.md` の論点から原文の行へ。`rg -n '<語>' investigation/YYYY-MM-DD-<話題>/sources` |
| 下書き・置き換え済み | `rg -lUP '\A---\n(?:(?!---\n).*\n)*?status: (?:draft\|deprecated)' -g '!investigation/*/sources/**' .`。Decision Record の置き換え先は、新しい記録の `supersedes` と、古い記録の「状態」の節のリンク。Beads の置き換え済みの決定は、上の「委任するプロジェクトに効く決定と運用」の `bd dep list` |

## 検証

- セッション開始時は、`AGENTS.md` の「セッション開始時と compact 後」の 2 で、引数なしの `~/.config/claude/skills/karo/scripts/karo-check` を実行する。
- 記録を直接書くサブエージェントと Agent は、終える前に、変えたノートだけを `~/.config/claude/skills/karo/scripts/karo-check --only <root からのパス> <root>` で確かめる。`<root>` はノートを書いた checkout の root（このリポジトリか、その worktree の root）で、省くと `$KARO_HOME` を調べるので、worktree のノートは範囲に入らないまま 0 件で通る。karo の書き込みは、どちらも `karo-check --only` で、Edit と Write のあとに `post-edit` の hook が書いたファイルの問題を（worktree で書いたファイルも、その worktree を root にして）、commit の前に karo の `scripts/commit` が commit に入る中身のうち commit するパスとそれを指すノートの問題を確かめる。`--only` の合格の条件は、`karo:record` skill の「調べ物を頼む」の表の「検査」の行にある。
- karo-check は、問題ごとに `<パス><TAB><問題>` を出し、1 件でもあれば 0 以外で終わる。確かめることの範囲は karo の `scripts/karo-check` の冒頭にある。
- `stale since` の行は `stale_after` を過ぎたノートの警告で、失敗に数えない。
- karo の `scripts/karo-check` か `rule/frontmatter-schema.yaml` を直したら、`~/.config/claude/skills/karo/scripts/karo-check-test` も実行する。

完了条件: `karo-check: 0 problem(s)` が出て終了コードが 0。検証を直したときは、`karo-check-test: 0 failure(s)` も出る。
