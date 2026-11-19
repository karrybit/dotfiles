Review Agent の判定は REVISE でした。設計の持ち主の `karo-k7m-1` に返します。

1. `bd comment karo-k7m.1 --file <scratchpad>/review-request.md --json`。本文は「レビュー依頼: karo-k7m-1-rv が readiness-review で調べた」。
2. `bd comment karo-k7m.1 --file <scratchpad>/judgement.md --json`。本文は「判定: REVISE（次工程: karo-k7m.2 の実装）。要旨: docs/design.md:12 が R2 を落としている。返す先: karo-k7m.1」。
3. `bd comment karo-k7m.1 --file <scratchpad>/change-request.md --json`。本文は「変更依頼: docs/design.md:12 が R2 を落としている」。
4. `karo-agent-ctl send karo-k7m-1 "レビューの判定は REVISE。docs/design.md:12 の split_row の契約に、ブリーフの R2（引用符の中の改行を 1 つの列に含める）を入れて直す。あわせて、下流の karo-k7m.2 の完了条件に R2 のテストを足す案を設計に書く"`。JSON の status が working になるのを確かめる。
5. `karo-agent-ctl close karo-k7m.1-rv` で Review Agent の tab を閉じる。
6. karo-k7m.2 の受け入れ条件に「bin/parse-test に R2 のテストがあり通る」を足す（`bd update karo-k7m.2 --acceptance '...' --json`）。
7. `agent-report --wait karo-k7m-1` を background で走らせて直しを待つ。直しの完了報告を受けたら、前の判定の `判定:` の comment の要旨と直した差分を渡して、直した箇所と波及する範囲の再レビューを頼む。

karo-k7m.2 は再レビューで READY になるまで始めません。karo-k7m.3 はゲートとつながらないので、別に進められます。
