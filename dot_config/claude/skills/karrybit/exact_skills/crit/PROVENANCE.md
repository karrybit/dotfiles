# Provenance

- origin: local
- source: this dotfiles repository
- source_url: local
- license: local
- reviewed_at: 2026-11-14
- notes: crit（ローカルのレビューのツール）を開き、ユーザーのコメントに返事をする手順と、ブラウザを開く scripts/crit-open とその test。同じ作者の非公開の作業用リポジトリの skill から移し、そのリポジトリのパス・台帳・別の skill を指していた箇所を、呼び出し側が渡す checkout か worktree のパスと、起動した場所（引数なしのとき）に置き換えた。`open` は sandbox の中では動かず、`open` そのものを許可すると任意のファイルやアプリを sandbox の外で開けてしまうので、ポート番号だけを受け取る crit-open を、呼び出し側の settings で許可し sandbox から除外して使う。scripts/crit-open-test に settings.json を渡すと、その規則があることと、`open` そのものの規則がないことを確かめる。
