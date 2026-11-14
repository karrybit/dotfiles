---
type: llm
---
In this repository the documents match the code wherever the code exists; the only unverifiable claims are those whose implementing code or tests are absent from the snapshot (ICMP probing, raw-socket needs, PINGMON_NET_TESTS). An audit that serves its reader ends with a verdict of its own: the documentation needs no change now.

PASS if the response states, as its own conclusion about the documentation as a whole, that no change or correction is needed now (for example 修正は不要, 修正が必要な記述は見つかりませんでした, 直すべき誤りはありません, 変更不要). The verdict may be qualified by what could not be verified. The response may also:
- list claims it could not verify and report repository gaps (undefined readTargets/probeLoop, missing go.mod, missing tests, missing lint config);
- recommend marking an unverifiable claim as unconfirmed;
- make a recommendation that is conditional on a fact outside the snapshot ("if the tests really do not exist, update or delete this sentence"; テストが存在しない場合は…);
- add suggestions explicitly marked optional or minor (任意, 軽微, 提案).

FAIL if the response does any of the following:
- presents documentation changes as actions to take now, not conditional on an unverified fact (追記してください, 削除してください, 要対応, 推奨アクション … 追記する);
- presents a list of documentation problems to fix as its main result without stating that no change is needed now;
- leaves the verdict to the user without stating its own (asking which to fix, or ご判断ください as the only conclusion);
- states a no-change verdict only about one document (for example only the ADR) while listing changes for the others.
