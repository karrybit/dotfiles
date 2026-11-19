`karrybit:agent-work-design` で作業を設計しました。

Goal と依存:

- G1（R1、`src/split.py`）、G2（R2、`src/cli.py`）、G3（R3、`src/split.py`）、G5（R5、`README.md`）: 互いに依存しない。
- G4（R4、`docs/usage.md`）: G2 の後。

速く進めるため、依存のない 4 つの Worker を、この worktree でいっしょに起動します。

1. Agent（G1、`run_in_background: true`、prompt: G1 の契約）
2. Agent（G3、`run_in_background: true`、prompt: G3 の契約）
3. Agent（G2、`run_in_background: true`、prompt: G2 の契約）
4. Agent（G5、`run_in_background: true`、prompt: G5 の契約）
5. 4 つが終わったら、読むだけの Reviewer に `karrybit:readiness-review` で実装の結果を見せる。
6. G2 の完了通知を受けて、G4 の Worker を起動する。
