# Provenance

- origin: local
- source: this dotfiles repository
- source_url: local
- license: local
- reviewed_at: 2026-08-16
- notes: |
    業務リポジトリで未整理のタスク一覧を毎回手で書き直していた依頼を手順化したもの。
    `disable-model-invocation: true` で明示呼び出しのみ。実行手順は `parallel-work`
    に分離しており、そちらはこの skill を前提としない。

    活性成分は3つ。ファイル衝突を独立性の反証として扱う点（依存を書き足して済ませ
    ない）。3つの尺度に行動を紐付けた点（影響度 L → `gh search code` で外部呼び出し
    確認、作業量 L → ローカル分割必須）。そして**導出できる情報を保存しない**点。
    尺度を増やすと引き金のないラベルが増えて判断が薄まるので、軸は3つに固定する。

    進行状態・ブランチ名・PR 番号・並行可能集合はすべて git と GitHub から引けるため
    持たせていない。持つと変更ごとに書き換えが必要になり、二重の真実の源になってずれる。
    チェックボックスだけは例外で、1タスクにつき1回しか変わらず一覧性の価値が上回る。
    タスク ID に Issue 番号を使うのがこの導出を成立させている——ブランチ名と worktree 名
    が ID を含むので、`git worktree list` だけで「どの Issue の作業か」が読める。

    層の設計は `~/.local/share/agents/docs/medallion-information-design.md` の Design
    Checklist を当てて点検した。Bronze は GitHub の Issue と元の未構造メモ、Silver が
    タスク表、Gold は「今どれに着手すべきか」で、Gold は保存せず都度導出する。
    チェックリストで出た穴は3つあり、いずれも成果物のフィールドを増やさず手順側で埋めた。
    (1) 未構造メモを出力先と同じパスにすると Bronze が消え、`tasks/` は gitignore で
    履歴もないため復元できない → 出力を別パスに強制。(2) 鮮度は `更新日` ではなく
    `gh issue list` との突き合わせで導出する（知りたいのは経過時間ではなく導出元が
    変わったか）。(3)「1つも捨てない」の例外として認証情報・秘密値を除外し、`tasks/`
    の gitignore 確認が安全境界であることを明文化。ディレクトリを層で3分割する案は
    規範の "Do not overbuild" に従って採らなかった。

    出力は `<repo>/.analyze-tasks/backlog.md` に固定した。固定名でないと、既存ファイルを
    見つけられず再実行が更新でなく新規作成になり、`parallel-work` もパスを教えられないと
    タスク一覧に到達できない。UUID 等の衝突しない名前は、この決定性を失う代わりに固定名の
    ポインタファイルを要求し、同じ衝突リスクが1階層移動するだけなので採らなかった。

    ドット接頭辞は必須。非ドットのルートディレクトリは chezmoi のソースツリーでソース
    エントリとして扱われ、`chezmoi status` が ` A analyze-tasks` を出して apply で `$HOME`
    に配備される（実測）。chezmoi が `.chezmoiignore` にルート直下の非ドット項目だけを
    列挙している理由もこれ。ドット接頭辞はツール所有状態の慣習（`.git` / `.claude` /
    `.venv`）でもあるので、名前衝突の回避も同時に得られる。`.claude/analyze-tasks/` は
    ネームスペースとしてより強いが、ハーネスが能動的に掃除するディレクトリなので、
    セッションをまたいで残す成果物の置き場としては避けた。

    無視は global の `~/.config/git/ignore`（`core.excludesFile` 未設定でも git が XDG 既定で
    読む）で行うので、リポジトリごとの `.gitignore` 編集も、編集し忘れて commit する事故も
    起きない。先頭スラッシュでルート直下に限定する。書き込み前の `git check-ignore -v` は、
    この安全境界を仮定せず毎回検証するための手順。

    並行数の上限の既定値は 5（レビュー可能な件数としてユーザーが合意した値）。
    テンプレート例であり、`parallel-work` 実行時は都度ユーザーと合意して決める
    設計自体は変えていない。
