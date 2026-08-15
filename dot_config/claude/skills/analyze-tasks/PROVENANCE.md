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

    出力は `<repo>/analyze-tasks/backlog.md` に固定した。固定名でないと、既存ファイルを
    見つけられず再実行が更新でなく新規作成になり、`parallel-work` もパスを教えられないと
    タスク一覧に到達できない。無視は global の `~/.config/git/ignore`（`core.excludesFile`
    未設定でも git が XDG 既定で読む）で行うので、リポジトリごとの `.gitignore` 編集も、
    編集し忘れて commit する事故も起きない。パターンは先頭スラッシュ必須で、`analyze-tasks/`
    と書くと任意の深さに一致してこの skill 自身のソースまで無視した（新規ファイルが staging
    されず、ripgrep もディレクトリを飛ばす）。書き込み前の `git check-ignore -v` は、この
    安全境界を仮定せず毎回検証するための手順。

    並行数の上限の既定値 3 は根拠のない仮値。
