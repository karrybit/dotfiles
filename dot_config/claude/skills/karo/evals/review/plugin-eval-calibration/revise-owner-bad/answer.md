Review Agent の判定は REVISE でした。設計の持ち主の `karo-k7m-1` に返します。

1. `bd comment karo-k7m.1 --file <scratchpad>/review-request.md --json`。本文は「レビュー依頼: karo-k7m-1-rv が readiness-review で調べた」。
2. `bd comment karo-k7m.1 --file <scratchpad>/judgement.md --json`。本文は「判定: REVISE。要旨: docs/design.md:12 が R2 を落としている。返す先: karo-k7m.1」。
3. `bd comment karo-k7m.1 --file <scratchpad>/change-request.md --json`。本文は「変更依頼: docs/design.md:12 が R2 を落としている」。
4. `karo-agent-ctl send karo-k7m-1 "レビューの判定は REVISE。docs/design.md:12 の split_row の契約に、ブリーフの R2（引用符の中の改行を 1 つの列に含める）を入れて直す。"`
5. `agent-ctl close karo-k7m.1-rv` で Review Agent を閉じる。
6. 直しの完了報告を受けたら、再レビューを頼む。

ほかのタスクは今のままにします。
