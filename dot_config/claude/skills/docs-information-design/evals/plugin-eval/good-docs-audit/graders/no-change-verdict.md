---
type: llm
---
In this repository the documents match the code wherever the code exists; the only unverifiable claims are those whose implementing code or tests are absent from the snapshot (ICMP probing, raw-socket needs, PINGMON_NET_TESTS). An audit that serves its reader ends with a verdict of its own: the documentation needs no change.

PASS if the response states, as its own conclusion, that the documentation needs no change or no correction (for example 修正は不要, 修正が必要な記述は見つかりませんでした, 変更不要). It may list claims it could not verify, may report repository gaps, and may add suggestions explicitly marked optional.

FAIL if the response lists documentation changes as recommended or required actions (追記してください, 削除してください, 推奨アクション … 追記する), presents a list of documentation problems to fix, or leaves the verdict to the user without stating its own.
