# Provenance

- origin: local
- source: this dotfiles repository
- source_url: local
- license: local
- reviewed_at: 2026-08-26
- notes: |
    `analyze-tasks`（分解）→ `parallel-work`（実行）の後に残っていた「GitHub Issue と
    backlog.md をマージ結果に同期し、実行結果を Issue に返す」作業を手順化したもの。
    `disable-model-invocation: true` で明示呼び出しのみ。

    `analyze-tasks` はローカル分割（`#44` → `#44-1` / `#44-2`）を前提にしているため、
    子タスクの一部だけがマージされた時点で親 Issue を close またはコメントすると、
    残りの子タスクの結果と矛盾する記録が残る。判定は「親は全子タスクがマージされた
    ときだけ close する」を明文化して固定した（一部完了時にコメントだけ残す案、
    分割を考慮せず単純に「対応 PR が merged なら close」する案は、いずれも中間状態の
    矛盾を残すため採らなかった）。

    Issue の comment/close は外部への公開行為で、`analyze-tasks`/`parallel-work` の
    draft PR 作成より可逆性が低い。4節で実行前の合意を必須にしているのはそのため。

    進行状態を保存しない設計は `analyze-tasks`/`parallel-work` から引き継いだ。
    書き換えるのは backlog.md のチェックボックスだけで、他の節は3節で引き継ぎが
    必要と判断した場合のみ触る。

    見積り（影響度・作業量・重要度）の当たり外れの検証は明示的に対象外とした。
    実行結果の反映（このスキルの関心事）と見積り精度へのフィードバック（別の関心事）
    を1つの手順に混ぜると、どちらの入出力も曖昧になるため分離した。
