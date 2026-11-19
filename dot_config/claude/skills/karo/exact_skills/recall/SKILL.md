---
name: recall
description: '過去の会話（Claude Code の transcript）から、今の作業に要る経緯・候補案と採否の理由・決定の根拠・前の Agent の似た作業・引き継ぎの文脈を、cass の robot mode で範囲を絞って探し、原文と出典つきで取り戻す手順。今のセッションの文脈と Beads・記録のファイル（Decision Record を含む）で答えが出ず、過去の発言や議論、決定に至った理由、前のセッションや Agent のやり方を確かめるときと、cass の出力（当たりや 0 件）を読んで答えるときに使う。'
---

# 過去の会話から根拠を取り戻す（cass）

- 目的は、検索することではなく、今の作業に要る根拠を、要る範囲だけ原文と出典つきで取り戻すこと。
- cass の当たりは過去の会話と Agent の活動の証拠で、今の状態と決定の正本ではない。情報ごとの正本は `$KARO_HOME/AGENTS.md` の「書き込み先」と「情報源」の表にある。
- この skill で実行する cass のコマンドは、`cass search`・`cass view`・`cass index --json` の 3 つだけにする。会話の保持と削除は `karo:checkout` skill の 6 にあり、index の作り直しや設定の変更が要りそうなときはオーナーに伝える。
- 見つけた会話は、要旨と下の「出典」を返事か Beads の comment に書くだけにする。会話は Claude Code が残し cass がいつでも引けるので、本文を別のファイルに写さない。
- cass は `--robot` か `--json` を付けて単独の呼び出しで実行する（付けない `cass` は TUI を開く）。

## 探すかどうか

- 今のセッションの文脈で答えが出るときは、cass を呼ばずにその文脈から答える。
- タスクとその決定の今の状態は、先に `bd show <ID> --json` と `karo:tasks` skill の「今の状況を読む」で、karo 自身の長い目の決定は `$KARO_HOME/decisions/` の Decision Record で引く。cass は、その理由・経緯・候補案の原文が Beads と記録にないときに引く。
- 記録のファイルと `git log` の探し方は、`$KARO_HOME/rule/information-design.md` の「探す」の表にある。

## 手順

1. 探す範囲を決める。語は話題に固有の語（タスク ID、ファイル名、コマンド名）にし、期間は `--days <日数>` か `--since YYYY-MM-DD --until YYYY-MM-DD` で、わかっている時期に絞る。workspace は下の表で決める。

   | 探す会話 | `--workspace` |
   | --- | --- |
   | karo の会話 | SessionStart の hook が出す `KARO_HOME` の値と、`$KARO_HOME/rule/recall.md` の「追加の workspace」の節に並ぶパス（ファイルか節がなければ `KARO_HOME` の値だけ）。workspace ごとに 1 回ずつ探す |
   | Agent の会話 | タスクの `報告:` の comment にある Agent の worktree。わからなければ `--workspace` を外し、語をタスク ID にして `.` の形のまま二重引用符で囲む（`'"karo-a1b2.1"'`） |

   完了条件: 語・workspace・期間が決まっている。
2. `cass search '<語>' --workspace '<workspace>' --days <日数> --mode lexical --robot --robot-meta --fields source_path,line_number,created_at,agent,snippet --max-content-length 160 --limit 5 --max-tokens 2000 --timeout 2000` を単独で実行する。
   - `budget.timed_out` が true なら、その検索は「探しきれなかった」と扱う。
   - `_meta.index_freshness.stale` が true で、探す出来事が直近 30 分にあるときは、`cass index --json` を 1 回実行してから同じ検索をやり直す。古い index でも、検索が裏で次の検索のための更新を始める。
   - 出力の `error` が index の作り直しや保守を求めたら、そこで止めてオーナーに伝える。
   - 当たりがないか足りないときは、語の言い換え、期間を広げる、`--workspace` を外す、のどれか 1 つずつで広げ、広げるのは合わせて 3 回までにする。

   完了条件: 当たりの一覧か 0 件の結果と、探した語・workspace・期間と、`stale`・`timed_out` の値が手元にある。
3. snippet で問いに関わる当たりを 3 件まで選び、`cass view <source_path> --message-index <line_number> -C 3 --json` を単独で実行して前後の原文を読む（元のファイルが消えたあとも、cass の archive から読める）。決定・合意・理由を答えるときは、snippet だけで答えずに原文を読む。`cass view` が `error` を返したら、その `kind` を書き、その当たりは原文を確かめていないと書く。
   完了条件: 答えに使う当たりのすべてに、`cass view` の原文か、読めなかった `kind` がある。
4. 原文の発言を、発言・提案・合意・決定・未確定のどれかに分ける。決定と書くのは、同じ決定が `$KARO_HOME/decisions/` の置き換えられていない Decision Record か Beads（閉じた decision の bead か `決定:` の comment）にあるものだけにする。原文にオーナーが決めたとあっても記録にないものは「過去の会話の発言（記録なし）」と書き、今も効くかをオーナーに確かめる。効くと答えたら、karo 自身の長い目の方針は `karo:record` skill の「Decision Record を書く」で、それ以外は `karo:tasks` skill の「判断待ちと決定」の 3 で記録にする。
   完了条件: 答えに使う発言のすべてに分類があり、決定と書いたものには Decision Record のパスか Beads の ID がある。
5. 要旨・分類・出典を返す。当たりがなかったときは「この範囲では見つからなかった」と書き、探した語・workspace・期間・`stale`・`timed_out` と、cass に残るのは `karo:checkout` skill の 6 の保持期間の中の会話だけであることを添える。
   完了条件: 返事のすべての主張に出典があるか、見つからなかった範囲が書いてある。

## 出典

- cass の当たりの出典は `cass <source_path>#<line_number>` の形にする（`line_number` は `cass view --message-index` にそのまま渡す値）。発言の日がわかるときは、続けて `YYYY-MM-DD` を書く。
- Beads の comment に出典を書くときも、同じ形にする（`karo:tasks` skill の「comment の語」）。
