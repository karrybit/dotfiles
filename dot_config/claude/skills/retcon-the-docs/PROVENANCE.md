# Provenance

- origin: local
- source: this dotfiles repository
- source_url: local
- license: local
- reviewed_at: 2026-08-31
- notes: コード・ドキュメントに残る経緯的記述(過去の実装・会話由来の物語・意思決定の変遷)を検出し、現状設計として書き直す。検出は `review-doc-fresh-eyes` と同じ考え方で、会話の文脈を持たないサブエージェントに委ねる。理由は、経緯を知っている本体セッションでは「知っているから説明を残したくなる」バイアスがかかり判定者として機能しないこと、および同じ盲目性のおかげで自分が書いたものだけでなく他者が書いたコード・ドキュメントにも同一手順が使えること。検出された経緯残留は書き直し文かコミットメッセージ材料のいずれかに必ず反映し、無言で消さない。`git commit` は実行しない。日本語の文体規範(`japanese-tech-writing`)や読み物としての緩急(`cognitive-rhythm-writing`)とは意図的に分離しており、経緯 vs 設計の分類のみを行う。`disable-model-invocation: true` で明示呼び出しのみ。
