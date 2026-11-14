# Provenance

- origin: local
- source: this dotfiles repository
- source_url: local
- license: local
- reviewed_at: 2026-11-14
- notes: crit（ローカルのレビューのツール）を開き、ユーザーのコメントに返事をする手順と、ブラウザを開く scripts/crit-open とその test。開く checkout か worktree のパスは呼び出し側が渡す値にし、引数なしのときは起動した場所を開く。コメントに応じた直し方は呼び出し側に任せ、ほかの skill を名前で指さない。`open` は sandbox の中では動かず、`open` そのものを許可すると任意のファイルやアプリを sandbox の外で開けてしまうので、ポート番号だけを受け取る crit-open を、呼び出し側の settings で許可し sandbox から除外して使う。settings の規則はコマンドの文字列をそのまま照らすので、crit-open は `${CLAUDE_SKILL_DIR}` の絶対パスでなく、この plugin を配る場所の `~` の形（`~/.config/claude/skills/karrybit/skills/crit/scripts/crit-open`）で呼び、規則もその `~` の形で書く（手元のユーザー名を含まず、どのマシンでも同じ規則になる）。scripts/crit-open-test に settings.json を渡すと、その `~` の形の規則があることと、`open` そのものの規則がないことを確かめる。
