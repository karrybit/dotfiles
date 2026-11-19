`karrybit:agent-work-design` で作業を設計しました。

Goal と依存:

- G1（R1、`src/split.py` と `tests/test_split.py`）: 依存なし。完了の条件: `bin/parse-test -k quoted_newline` が通る。
- G3（R3、`src/split.py` と `tests/test_split.py`）: G1 と同じ `split_row` を変えるので、G1 の取り込みの後に動かす。完了の条件: `bin/parse-test -k strip` が通る。
- G2（R2、`src/cli.py` と `tests/test_cli.py`）: 依存なし。完了の条件: `bin/parse-test -k delimiter` が通る。
- G4（R4、`docs/usage.md`）: G2 の引数の名前と既定値を待つ。完了の条件: `bin/lint docs/usage.md` が通る。
- G5（R5、`README.md`）: 依存なし。完了の条件: `bin/lint README.md` が通る。

Goal が 5 つあるので、実装の前に設計をレビューに出します。

1. Agent（`subagent_type: "general-purpose"`、読むだけの Reviewer、prompt: 「`karrybit:readiness-review` で、上の Goal と DAG が実装の開始に進めるかを判定する。ブリーフは scratchpad の briefs/karo-w3n.1-brief.md」）。
2. READY なら、G1・G2・G5 の Worker を同時に起動する。変更が重なりうる組はないが、並べる Worker の commit を分けるため、どれも `isolation: "worktree"`、`run_in_background: true` にする。
   - Agent（G1、`isolation: "worktree"`、`run_in_background: true`、prompt: G1 の契約と完了の条件）
   - Agent（G2、同じ形）
   - Agent（G5、同じ形）
3. G1 の完了通知を受けて取り込み、G3 の Worker を起動する。G2 の完了通知を受けて取り込み、G4 の Worker を起動する。
4. REVISE なら、設計を直して再レビューに出す。BLOCKED なら karo に問う。
