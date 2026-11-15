# Provenance

- origin: local
- source: this dotfiles repository
- source_url: local
- license: local
- reviewed_at: 2026-11-15
- notes: `~/cos` の記録のリポジトリ（`tasks/`・`threads/`・journal・record）の構造を知る plugin。manifest の `defaultEnabled: false` により、使うプロジェクトの settings の `enabledPlugins` で `"karo@skills-dir": true` にしたときだけ読み込まれる。複数の skill と settings の hook が使う script（`thread-show`・`right-pane`・`call-check`・`settings-test`）は plugin 直下の `scripts/` に、1 つの skill だけが使う script はその skill の `scripts/`（`land`・`insights`）に置き、test は script の隣に置く。オーナーごとの値は karo に書かず、引数、`<cos>/rules/karo.yaml`（`panes:` を `right-pane` が、`uncounted:` を `insights` が `yq` で読む）、script がすでに受ける `COS_*` の env で受け取る。`land` は env と `rules/karo.yaml` のどちらでもフォルダを動かさない（理由は `land` の冒頭）。scripts は呼び出し側の settings で許可し sandbox から除外して使うので、この plugin を配る場所の `~` の形（`~/.config/claude/skills/karo/scripts/<名前>`）で呼び、規則もその形で書く。`scripts/settings-test` に settings.json を渡すと、その規則と hook がそろっているかを確かめる。
