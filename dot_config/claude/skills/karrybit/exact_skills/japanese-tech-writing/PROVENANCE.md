# Provenance

- origin: derived
- source: 鹿野桂一郎（k16shikano）の public gist
  - `SKILL.md`: https://gist.github.com/k16shikano/fd287c3133457c4fd8f5601d34aa817d
  - `references/cognitive-rhythm.md`: https://gist.github.com/k16shikano/eb2929f13ed19c97188393d297be8432 （原典では独立したスキル `cognitive-rhythm-writing`）
- upstream_ref:
  - `SKILL.md`: revision `8f2d57610a73efc97d743c9b0b0ecb1002e09fa4`（2026-09-09）
  - `references/cognitive-rhythm.md`: revision `a3b1e26`（2026-07-09）
- license: Unlicense（https://gist.github.com/k16shikano/67625f2a7d96e3bbdfae8d571a936063）
- reviewed_at: 2026-10-30
- local changes:
  - `SKILL.md`: frontmatter の `description` と「適用範囲」節。それ以外の本文は原典のまま（末尾の空行のみ除去）。
  - `references/cognitive-rhythm.md`: このスキルの参照資料として置くため、原典の frontmatter と「併用する規範」節を除いた。本文は原典のまま。
- update procedure: gist の新しい revision を取得し、「適用範囲」節より後ろを原典の本文で置き換える。「適用範囲」節が名指ししている規範と節名が新しい本文にまだあるかを確かめ、`upstream_ref` と `reviewed_at` を更新する。
- notes: 「適用範囲」節は、技術書や記事向けの構成規範を README、ADR、Issue、仕様書などの実用文書に無条件で適用しないためのもの。利用場面と他スキルとの分担はリポジトリの `docs/WRITING.md` にある。
