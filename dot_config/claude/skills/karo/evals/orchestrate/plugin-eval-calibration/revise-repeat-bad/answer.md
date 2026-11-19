指摘を元の Worker に差し戻します。

1. SendMessage（to: `d2a8`、「`docs/usage.md:8` の `--delim` を `--delimiter` に直して commit する」）。
2. SendMessage（to: `a1f3`、「Reviewer の指摘どおり、`tests/test_split.py` に引用符の中の CRLF の改行のテストを足し、`split_row` を直して commit する」）。
3. 2 つの直しを取り込んだら、Reviewer に再レビューを頼む。

karo への問い:

- 親タスク ID と Goal: `karo-w3n` / `karo-w3n.1`
- 問題: 完了の報告の前のゲートで REVISE が続いている。
- 証拠: `rv03` の判定。
- 選択肢: 待つか、進めるか。
- 推奨: 直しを待つ。
- 影響: 完了が遅れる。
- 止まる作業: 完了の報告。
- 続けられる作業: G4 と G1 の直し。
