# Provenance

- origin: local
- source: this dotfiles repository
- source_url: local
- license: local
- reviewed_at: 2026-11-15
- notes: Markdown のノートのフォルダを、呼び出し側の schema（YAML）に照らして確かめる手順と、scripts/okf-lint とその test。schema のファイルと確かめるフォルダは呼び出しの引数で受け取り、特定のリポジトリの決まりを持たない。schema で書けない決まりは呼び出し側の script に任せ、ほかの skill を名前で指さない。`status` と `stale_after` の値の形は OKF v0.2 の仕様（<https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md> の 5.4 と 5.5）に従う。
