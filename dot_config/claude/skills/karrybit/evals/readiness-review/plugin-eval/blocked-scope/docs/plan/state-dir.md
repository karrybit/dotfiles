# 計画: ledger の置き場所を移す、ほか

- 書いた人: 計画の担当
- 次の工程: 3 つの Goal の実装を始める。G1 と G2 は並べて始め、G3 は G2 の後に始める。

## Goal

- G1: `wt-list` に `--json` を足す。触るのは `bin/wt-list` と、新しく足す `tests/json`。ledger の場所は `ledger_path` から読むので、G2 と関わらない。
- G2: `bin/wt-lib` の `ledger_path` を `${XDG_STATE_HOME:-$HOME/.local/state}/wtctl/<リポジトリのフォルダ名>.tsv` に変える（D-1）。最初に呼ばれたとき、今の `state/ledger.tsv` を新しい場所へ移す。触るのは `bin/wt-lib` と `tests/run`。
- G3: `README.md` の ledger の場所の説明を、G2 に合わせて直す。G2 の後。

## 完了の条件

- G1: `tests/json` が、`wt-new a` のあとの `wt-list --json` に `[{"name":"a","branch":"wt/a"}]` を出すことを確かめ、exit 0 で終わる。
- G2: `tests/run` に「古い `state/ledger.tsv` が新しい場所へ移り、移したあとも `wt-close` が使える」テストを足し、`0 failure(s)` を出す。
- G3: `README.md` が新しい場所を書いている。
