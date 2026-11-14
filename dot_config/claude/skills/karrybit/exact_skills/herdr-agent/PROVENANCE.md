# Provenance

- origin: local
- source: this dotfiles repository
- source_url: local
- license: local
- reviewed_at: 2026-11-15
- notes: Herdr で Claude Code の Agent を起動し、指示を送り、終わるのを待ち、報告を取り出し、閉じる手順と、scripts/ の 4 本（`agent-ctl`・`agent-report`・`safe-key`・`herdr-call-check`）と各 test。名前、ブリーフ、場所は呼び出しの引数、名前とブランチの形は呼び出し側の settings の `env` で受け取り、ほかの skill を名前で指さない。scripts は呼び出し側の settings で許可し sandbox から除外して使うので、この plugin を配る場所の `~` の形（`~/.config/claude/skills/karrybit/skills/herdr-agent/scripts/<名前>`）で呼び、規則もその形で書く（手元のユーザー名を含まず、どのマシンでも同じ規則になる）。`agent-ctl close` は `agent-ctl start` が `~/.local/state/herdr-agent/ledger` に書いた Agent だけを片付ける。scripts/agent-ctl-test に settings.json を渡すと、その規則と値がそろっているかを確かめる。
