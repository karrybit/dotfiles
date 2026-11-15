---
name: review
description: Agent の成果物をレビューに回す手順。実装 Agent の完了を確認したとき、オーナーがレビューを始める・Review Agent に調べさせると言ったとき、レビュー結果を元の Agent に戻すときに使う。
---

# レビュー

- 取り込む前にオーナーが差分を読む作業は、「1」の 3 の既定と、`~/cos/rules/review.md` の「オーナーが差分を読む作業」の節で決まる。
- 作業場所と取り込みの方法は、`karo:delegate` skill の「作業場所と取り込み」で決まる。

## 1. 完了報告を受け取る

1. 完了報告を読む。完了報告は、`karo:delegate` skill の「終わるのを待つ」の agent-report の通知の出力の 2 行目からにある。通知がないとき（会話を再開したあとなど）は、`<scripts>/agent-report <タスクID>` を単独で実行して読む（`<scripts>` は `karo:delegate` skill の冒頭）。完了報告に、`karrybit:completion-report` のひな形の見出しと、ブリーフの「完了時の報告」で足した見出しがそろっているかを確かめる。見出しが欠けていたら、`karo:delegate` skill の追加指示で埋めさせる。3 で「2」か「3」に進む作業では、タスクのファイルの `state` を `in-review` にし、journal に 1 行書く指示を 1 つにまとめて record で書く（AGENTS.md の「記録の更新」の「Agent の完了を確認した」）。そのまま取り込む作業では、この記録を節「4. 取り込んだあと」の指示に入れる。
   完了条件: 完了報告の項目がそろい、記録を書いたか、節「4」に回した。
2. PR があれば、`karrybit:publish-check` に PR の番号と worktree を渡して、ブランチ名、commit メッセージ、差分、PR の本文を調べさせる。`~/cos/rules/publish-terms.md` があれば、追加で探す語と形のファイルとして一緒に渡す。見つかったものは、レビューに回す前に `karo:delegate` skill の追加指示で元の Agent に直させる（commit メッセージは rebase で直させる）。そのリポジトリにもとからある語で直さないものは、3 の差分と一緒にオーナーに伝える。
   完了条件: `karrybit:publish-check` の報告が `見つかったもの: 0` か、残ったものすべてに直さない理由がある。
3. 次に進む先を決める。オーナーが Review Agent を求めたときと、変更が複数のモジュールにまたがるときは、まだ済ませていなければ、先に「2. Review Agent に調べさせる」を行い、終わったらここに戻る。次の作業は「3. オーナーが差分を読んでレビューする」に進む。
   - PR を作るリポジトリの作業
   - `~/cos/rules/review.md` の「オーナーが差分を読む作業」の節に当たる作業（ファイルか節がなければ、この行はない）
   - オーナーがレビューすると言った作業
   - Review Agent の報告に指摘がある作業

   PR を作らないリポジトリ（cos と、プロジェクトの節で PR を作らないとしたリポジトリ）のほかの作業は、オーナーの承認を待たずに `karo:delegate` skill の「作業場所と取り込み」の取り込みに従って取り込み（cos では `karo:land` skill にブランチ名を渡す）、節「4. 取り込んだあと」に進む。
   完了条件: 「2」を済ませたか要らず、「3」か「4」に進んだ。

## 2. Review Agent に調べさせる（オーナーが求めたとき、または変更が複数のモジュールにまたがるとき）

1. 次の依頼を、このセッションの scratchpad の `briefs/<タスクID>-rv-brief.md` に書く。差分だけでなくリポジトリ全体を調べさせる。
   - 調べる観点: 既存アーキテクチャとの整合、呼び出し元と依存先への影響、既存実装との重複、関連ドキュメントとの不整合、テストや変更すべき箇所の漏れ
   - 指摘ごとに根拠のファイルパスと行番号を書く
   - 調べた範囲と調べていない範囲を分けて書き、調べていない範囲については問題の有無を書かない
   - 結果は最後のメッセージに Markdown で書く

   完了条件: 依頼のファイルがある。
2. `<scripts>/agent-ctl start --permission-mode plan <タスクID>-rv <依頼のファイル> tab <タスクID>` を単独で実行し、実装 Agent の workspace の別 tab で、読み取り専用の Agent を起動する（`<scripts>` と JSON の扱いは `karo:delegate` skill の冒頭と「新しいタスクを委任する」の 3）。`working` になったら、`karo:delegate` skill の「終わるのを待つ」に従って `<タスクID>-rv` を待つ。
   完了条件: background の agent-report が走っている。
3. 終わったら、agent-report の通知の出力の 2 行目からの結果を、`~/cos/projects/<project>/reviews/<タスクID>-agent-<n>.md` に record の `新規:` で保存し（フロントマターは `rules/frontmatter.md` に従う）、journal の行を同じ指示に入れる（AGENTS.md の「記録の更新」の「レビュー結果を受け取った・中継した」）。
   完了条件: record が `queued` を出した。
4. `<scripts>/agent-ctl close <タスクID>-rv` を単独で実行して Review Agent の tab を閉じ、record で `assignments.md` を直す。終わったら「1」の 3 に戻る。
   完了条件: `close` の JSON が出て、record が `queued` を出した。

## 3. オーナーが差分を読んでレビューする（「1」の 3 で決めた作業）

1. レビューする差分を取り、会話に貼る。

   ```sh
   git -C <worktree> diff <base>...HEAD
   ```

   `<base>` は、PR を作るリポジトリでは PR の base ブランチ、cos では `main`、PR を作らないほかのリポジトリではプロジェクトの節の「レビューの差分の base」。差分の前に、対象の worktree、範囲、`HEAD` の commit を書く。オーナーが差分の外のファイルを見たいと言ったら、その箇所も貼る。
   完了条件: 範囲のすべてのファイルの差分が会話にある。
2. オーナーのコメントと結論（承認か修正の依頼）を、`~/cos/projects/<project>/reviews/<タスクID>-<n>.md` に record で保存する。`<n>` はそのタスクのレビュー回数。フロントマターは `rules/frontmatter.md` に従い、本文に対象（worktree、範囲、`HEAD` の commit）、コメント（ファイルと行、オーナーの言葉）、結論を書く。結論が言われていなければ、オーナーに尋ねてから record を走らせる。
   完了条件: record に渡した指示の結論が、オーナーの言った承認か修正の依頼のどちらかになっている。
3. 結論に従って進める。
   - 修正の依頼: コメントを `karo:delegate` skill の「既存の Agent に追加指示を出す」で元の Agent に渡し、タスクのファイルの `state` を `changes-requested` にする。修正の完了報告を受けたら、この skill の「1. 完了報告を受け取る」に戻る。
   - 承認: `karo:delegate` skill の「作業場所と取り込み」の取り込みに従って取り込む（cos では `karo:land` skill にブランチ名を渡す）。PR のあるリポジトリでは、タスクのファイルの `state` を `approved` にし、Draft の解除（Ready for review）と merge をするかをオーナーに尋ね、merge のあとに節「4. 取り込んだあと」に進む。PR を作らないリポジトリでは、取り込んだら節「4. 取り込んだあと」に進む。

   完了条件: 修正の依頼なら Agent が `working`、承認なら節「4. 取り込んだあと」に進んだか、オーナーに尋ねている。
4. 修正の依頼（`changes-requested`）と、PR のあるリポジトリの承認（`approved`）では、タスクのファイルの変更と journal の行を 1 つの指示にまとめて record で書く。PR を作らないリポジトリの承認は、節「4. 取り込んだあと」の指示だけで書く。
   完了条件: record が `queued` を出した。

## 4. 取り込んだあと

1. `karo:delegate` skill の「Agent を終了する」の 1 で、Agent を片付ける（タスクは次の 2 で `done` にする）。
   完了条件: `close` の JSON が出ているか、止まった理由をオーナーに報告している。
2. 次をすべて 1 つの指示にまとめて record で書く: AGENTS.md の「記録の更新」の表の「作業を取り込んだ」の行、1 で片付けたときは同じ表の「Agent を終了した」の行（中身は `karo:delegate` skill の「Agent を終了する」の 2）、「1」の 1 で回した完了の確認の journal の行。
   完了条件: record が `queued` を出した。
