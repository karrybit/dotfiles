---
name: review
description: Agent の成果物をレビューに回す手順。実装 Agent の完了を確認したとき、オーナーがレビューを始める・Review Agent に調べさせると言ったとき、readiness-review の判定を受けたとき、レビュー結果を元の Agent に戻すときに使う。
---

# レビュー

- 取り込む前にオーナーが差分を読む作業は、「1」の 3 の既定と、`$KARO_HOME/rule/review.md` の「オーナーが差分を読む作業」の節で決まる。
- 作業場所と取り込みの方法は、`karo:delegate` skill の「作業場所と取り込み」で決まる。
- タスクの状態とレビューの段階は、`karo:tasks` skill の「項目の対応」と「comment の語」のとおり、`bd comment <タスクID> --file <本文のファイル> --json` の comment で残す（取り込むまで `in_progress` のまま）。

## 1. 完了報告を受け取る

1. 完了報告を読む。完了報告は、`karo:delegate` skill の「終わるのを待つ」の agent-report の通知の出力の 2 行目からにある。通知がないとき（会話を再開したあとなど）は、`<scripts>/agent-report <タスクID>` を単独で実行して読む（`<scripts>` は `karo:delegate` skill の冒頭）。完了報告に、`karrybit:completion-report` のひな形の見出しと、ブリーフの「完了時の報告」で足した見出しがそろっているかを確かめる。見出しが欠けていたら、`karo:delegate` skill の追加指示で埋めさせる。見出しがそろったら、完了報告の要旨（commit、テスト結果、残課題）と、Agent の worktree と branch（`karo:delegate` skill の冒頭の控えの `place` と `branch`）を `報告:` の comment で書く。残課題のうち別の仕事にするものは、`karo:tasks` skill の「タスクを進める」の 1・2 で `bd create --deps discovered-from:<タスクID>` で作る。
   完了条件: 完了報告の項目がそろい、`報告:` の comment の JSON が出ている。
2. PR があれば、`karrybit:publish-check` に PR の番号と worktree を渡して、ブランチ名、commit メッセージ、差分、PR の本文を調べさせる。`$KARO_HOME/rule/publish-terms.md` があれば、追加で探す語と形のファイルとして一緒に渡す。見つかったものは、レビューに回す前に `karo:delegate` skill の追加指示で元の Agent に直させる（commit メッセージは rebase で直させる）。そのリポジトリにもとからある語で直さないものは、3 の差分と一緒にオーナーに伝える。
   完了条件: `karrybit:publish-check` の報告が `見つかったもの: 0` か、残ったものすべてに直さない理由がある。
3. 次に進む先を決める。受け入れ条件にゲートの行（`karrybit:readiness-review` の判定が READY）がある作業は、まだ判定がなければ、先に「2. Review Agent に調べさせる」を行い、判定を受けたら「3」の 3 の判定の扱いに進む。ゲートの行がない作業は、完了の通知だけでは readiness-review に回さない。オーナーが Review Agent を求めたときと、変更が複数のモジュールにまたがるときは、まだ済ませていなければ、先に「2. Review Agent に調べさせる」を行い、終わったらここに戻る。次の作業は、`レビュー依頼:` の comment（レビューする人と範囲）を書いてから「3. オーナーが差分を読んでレビューする」に進む。
   - PR を作るリポジトリの作業
   - `$KARO_HOME/rule/review.md` の「オーナーが差分を読む作業」の節に当たる作業（ファイルか節がなければ、この行はない）
   - オーナーがレビューすると言った作業
   - Review Agent の報告に指摘がある作業

   PR を作らないリポジトリ（`$KARO_HOME` と、プロジェクトの節で PR を作らないとしたリポジトリ）のほかの作業は、オーナーの承認を待たずに `karo:delegate` skill の「作業場所と取り込み」の取り込みに従って取り込み（`$KARO_HOME` では `karo:land` skill にブランチ名を渡す）、節「4. 取り込んだあと」に進む。
   完了条件: 「2」を済ませたか要らず、「3」か「4」に進んだ。

## 2. Review Agent に調べさせる（ゲートの作業、オーナーが求めたとき、または変更が複数のモジュールにまたがるとき）

- レビューは、成果物を作った Agent と karo から独立した Review Agent が行う。成果物や設計を作った Agent と karo は、代わりに判定しない。

1. 次の依頼を、このセッションの scratchpad の `briefs/<タスクID>-rv-brief.md` に書く。差分だけでなくリポジトリ全体を調べさせる。
   - 調べる観点: 既存アーキテクチャとの整合、呼び出し元と依存先への影響、既存実装との重複、関連ドキュメントとの不整合、テストや変更すべき箇所の漏れ。ゲートの作業では、この行の代わりに次を書く。
     - `karrybit:readiness-review` skill を使い、READY・REVISE・BLOCKED の判定を返す
     - 元の要求と確定した判断: ブリーフのパスと、そこにある決定の出典
     - 対象: 成果物のパスと commit
     - 次の工程: ゲートの後ろの goal と、そこで行う操作の範囲
     - 再レビューのとき: 前の判定の `判定:` の comment の要旨と、直した差分。直した箇所と、それが波及する範囲だけを確かめる
   - 指摘ごとに根拠のファイルパスと行番号を書く
   - 調べた範囲と調べていない範囲を分けて書き、調べていない範囲については問題の有無を書かない
   - 許可範囲: 読むだけで、ファイルを変えない
   - `karo:delegate` skill の「依頼に毎回書く決まり」の行。足す見出しは「レビューの結果」で、結果をそこに書く

   完了条件: 依頼のファイルがある。
2. `<scripts>/agent-ctl start --permission-mode plan <タスクID>-rv <依頼のファイル> tab <タスクID>` を単独で実行し、実装 Agent の workspace の別 tab で、読み取り専用の Agent を起動する（`<scripts>` と JSON の扱いは `karo:delegate` skill の冒頭と「新しいタスクを委任する」の 4。Review Agent は claim しない）。`working` になったら、`karo:delegate` skill の「終わるのを待つ」に従って `<タスクID>-rv` を待つ。
   完了条件: background の agent-report が走っている。
3. 終わったら、agent-report の通知の出力の 2 行目からの結果を読み、頼んだ Review Agent の名前と調べた範囲を `レビュー依頼:` の comment に書く。結果の要旨は、続く「3」の `判定:`・`変更依頼:`・`承認:` の comment に書く。結果の全文はファイルに保存せず、要るときは cass で `<タスクID>-rv` の会話を引く（`karo:recall` skill）。
   完了条件: `レビュー依頼:` の comment の JSON が出ている。
4. `<scripts>/agent-ctl close <タスクID>-rv` を単独で実行して Review Agent の tab を閉じる。終わったら「1」の 3 に戻る。
   完了条件: `close` の JSON が出た。

## 3. オーナーが差分を読んでレビューする（「1」の 3 で決めた作業）

1. レビューする差分を取り、会話に貼る。

   ```sh
   git -C <worktree> diff <base>...HEAD
   ```

   `<base>` は、PR を作るリポジトリでは PR の base ブランチ、`$KARO_HOME` では `main`、PR を作らないほかのリポジトリではプロジェクトの節の「レビューの差分の base」。差分の前に、対象の worktree、範囲、`HEAD` の commit を書く。オーナーが差分の外のファイルを見たいと言ったら、その箇所も貼る。
   完了条件: 範囲のすべてのファイルの差分が会話にある。
2. オーナーのコメントと結論（承認か修正の依頼）を、次の 3 で comment に書くレビューの要旨にまとめる。要旨は、対象（worktree、範囲、`HEAD` の commit）、コメント（ファイルと行、オーナーの言葉）、結論と、Review Agent の結果があればその指摘ごとのファイルと行にする。結論が言われていなければ、オーナーに尋ねてからまとめる。コメントに karo 自身の長い目の運用・設計の方針の判断があれば、`karo:record` skill の「Decision Record を書く」で記録にし、要旨にはその記録のパスだけを書く。
   完了条件: 要旨の結論が、オーナーの言った承認か修正の依頼のどちらかになっている。
3. 結論に従って進める。
   - 修正の依頼: 2 の要旨を `変更依頼:` の comment に書き、コメントを `karo:delegate` skill の「既存の Agent に追加指示を出す」で元の Agent に渡す。修正の完了報告を受けたら、この skill の「1. 完了報告を受け取る」に戻る。
   - 承認: 2 の要旨を `承認:` の comment に書き、`karo:delegate` skill の「作業場所と取り込み」の取り込みに従って取り込む（`$KARO_HOME` では `karo:land` skill にブランチ名を渡す）。PR のあるリポジトリでは、Draft の解除（Ready for review）と merge をするかをオーナーに尋ね、merge のあとに節「4. 取り込んだあと」に進む。PR を作らないリポジトリでは、取り込んだら節「4. 取り込んだあと」に進む。

   - readiness-review の判定（ゲートの作業）: 判定と要旨（次工程を妨げる指摘ごとのファイルと行と返す先）を `判定:` の comment に書き、判定ごとに次のとおり進める。
     - READY: 「1」の 3 の残りの文で進む先を決める。READY はオーナーの承認ではないので、merge・Ready for review・削除・切替は、今の規則どおりオーナーに尋ねてから行う。
     - REVISE: 指摘を返す Agent の名前を `変更依頼:` の comment に書き、指摘を `karo:delegate` skill の「既存の Agent に追加指示を出す」で成果物の持ち主の Agent に渡す。指示には、指摘の箇所と、直しが影響する下流の goal（依存と完了の条件）も直すことを書く。直しの完了報告を受けたら「1」に戻り、再レビューを「2」で頼む。
     - BLOCKED: 判定が挙げたオーナーの判断を、`karo:tasks` skill の「判断待ちと決定」の 1 で decision の bead にし、ゲートの後ろの goal だけの blocker にする。ゲートとつながらない独立した goal には依存をつながず、そのまま進める。

   完了条件: 修正の依頼なら `変更依頼:` の comment の JSON が出て Agent が `working`、承認なら節「4. 取り込んだあと」に進んだか、オーナーに尋ねている。readiness-review の判定なら `判定:` の comment の JSON が出て、REVISE は修正の依頼と同じ、BLOCKED はゲートの後ろの goal だけが decision の bead を blocker に持つ。

## 4. 取り込んだあと

1. `karo:delegate` skill の「Agent を終了する」の 1 で、Agent を片付ける（タスクは次の 2 で閉じる）。
   完了条件: `close` の JSON が出ているか、止まった理由をオーナーに報告している。
2. `bd close <タスクID> --reason "取り込み: <commit か PR>" --force --suggest-next --json` を単独で実行する（claim の持ち主が Agent 名なので `--force` が要る）。閉じたことで ready になったタスクは、`karo:tasks` skill の「タスクを進める」の 6 のとおりに扱う。
   完了条件: JSON の `status` が `closed`。
3. `karo:record` skill の「state.md を書く」のとおり、取り込んだタスクの行を `state.md` の「進めている作業」から消す。
   完了条件: `state.md` の「進めている作業」にそのタスク ID がない。
