---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
---

# Rust の開発の方針

Rust のコードか `Cargo.toml` を読み書きするときに、この決まりに従う。

- Rust のコードか `Cargo.toml` を変える前に、`karrybit/plugin-marketplace` の main の `doc/policy/rust-development-policy.md` を読み、それに従う。
- 方針の文書は、`gh api repos/karrybit/plugin-marketplace/contents/doc/policy/rust-development-policy.md -H 'Accept: application/vnd.github.raw'` で読む。
- 方針の文書を読めなかったときは、読めなかったことを報告に書いて作業を続ける。
