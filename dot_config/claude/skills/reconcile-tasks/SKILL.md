---
name: reconcile-tasks
description: parallel-work で実行したタスク群について、GitHub Issue と .analyze-tasks/backlog.md を実際にマージされた PR に同期し、完了した Issue へ実行結果を要約してコメント・close する。分割された親 Issue は全子タスクのマージ完了時のみ close する。見積り精度の検証は対象外。
disable-model-invocation: true
argument-hint: [issue-number...]
---

# 実行結果の反映と Issue の後始末

対象: `$ARGUMENTS`（未指定なら `.analyze-tasks/backlog.md` にある全タスクを対象にする）

`analyze-tasks` が分解し `parallel-work` が実行した後、**GitHub 側の状態とローカルの
backlog.md を、実際にマージされた PR に同期する**手順。見積り（影響度・作業量・重要度
の当たり外れ）の検証は対象外。実行結果の反映とは別の関心事なので混ぜない。

`parallel-work` の後片付け（worktree・ブランチの削除）が先に終わっている前提で動く。
残っていたらそちらを先に終わらせる。

## 1. 導出

進行状態はファイルに保存されていない。`analyze-tasks` と同じ考え方で毎回導出する。

| 知りたいこと | 導出方法 |
| --- | --- |
| マージ済み PR とその本文（対象 Issue・検証結果） | `gh pr list --state merged --json number,headRefName,title,body` |
| Issue の現在の状態 | `gh issue list --state all --json number,state` |
| backlog.md 上のタスクとチェック状態、親/子の対応 | `.analyze-tasks/backlog.md` を読む |

ブランチ名の接頭辞（`<ID>-...`）からタスク ID を、`headRefName` から対応する Issue/子タスク
を特定する。

## 2. 判定

| 対象 | 条件 | 行動 |
| --- | --- | --- |
| 単独タスク（`#46` 型） | 対応 PR が merged | backlog.md のチェックボックスを入れる。Issue へ実行結果を要約してコメントし close する |
| 分割タスクの子（`#44-1` 型） | 対応 PR が merged | チェックボックスを入れる。親 Issue は閉じない |
| 分割タスクの親（`#44` 型・子を持つ） | 子タスク（`#44-1`, `#44-2`, ...）が**すべて** merged | 親 Issue へ実行結果を要約してコメントし close する |
| 分割タスクの親 | 子タスクの一部が未マージ | 何もしない。中間状態を記録・報告しない（次回また導出できる） |
| 親 / トラッキング Issue 表の Issue | 表の「閉じる条件」に列挙された対象がすべて merged | 同上（コメントして close） |

**1件でも子タスクが未マージなら親は触らない。** 早期に一部だけコメントすると、後続の
子タスクの結果と矛盾する記録が残る。

## 3. 実行結果の要約

Issue へのコメントは、対象 PR 本文からそのまま集める。**新たに評価や推測を加えない。**

- 実施した検証と結果
- 実施できなかった検証
- 範囲外で見つけたこと（あれば、backlog.md の「対象外・保留」へ引き継ぐことも明記する）

複数子タスクを持つ親 Issue では、子タスクごとの PR 番号を明記した上でこれらを束ねる。

## 4. 合意してから実行する

**close とコメントは可逆性の低い外部への公開行為。** 実行前に、対象 Issue 番号・
close するか comment のみか・コメント本文の案をユーザーに提示し、合意を取る。
一括承認された場合のみ複数 Issue を続けて処理してよい。

```sh
gh issue comment <n> --body-file <path>
gh issue close <n>
```

## 5. backlog.md への反映

書き換えるのは対象タスクのチェックボックスだけ（`analyze-tasks` の規約を継承する）。
「対象外・保留」「未 Issue 化の検討事項」「このリポジトリ固有の運用ルール」などの
節は、3節で引き継ぎが必要と判断した場合を除き触らない。

書き込み前に `analyze-tasks` と同じ安全確認を行う。

```sh
git check-ignore -v .analyze-tasks/backlog.md
```

無視されていることを確認できなければ書き込まない。

## 6. 陳腐化の検出（報告のみ、修正しない）

次に当たったら、**backlog.md を直さずユーザーに報告する**。修正は `analyze-tasks` の
再実行に委ねる。

- backlog.md に無い open Issue がある
- backlog.md でチェック済みなのに Issue が open のまま
- 子タスクの一部が backlog.md に存在しない（`#44-1` はあるが `#44-2` が無い等）

## 対象外

- 見積り（影響度・作業量・重要度）の当たり外れの検証、`analyze-tasks` の判定基準への
  フィードバック。実行結果の反映とは別の関心事として、別の手順に分ける。
