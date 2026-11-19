# 検証の報告: drop-branch-column

- 書いた人: 検証の担当
- 対象: `main..drop-branch-column` の実装の commit（`docs/plan.md` の G1）
- 判定: PASS

## 条件ごとの状態

| 条件 | 状態 | 証拠 |
| --- | --- | --- |
| `tests/run` が `0 failure(s)` | 確かめた | `tests/run` を実行し、7 件すべて `ok`、`0 failure(s)`、exit 0 |
| branch を変えたあと、今の branch を出す（R2、#3） | 確かめた | 「wt-list shows the branch after a switch」が `ok` |
| 人が作った worktree を残す（R1） | 確かめた | 「wt-close leaves a worktree a person created」が `ok`。`bin/wt-close` は変わっていない（`git diff main..drop-branch-column -- bin/wt-close` が空） |
| 3 列の行をそのまま読む（R3） | 確かめた | 「wt-list reads a three-column row」と「wt-close removes a three-column row's worktree」が `ok` |

## 残る問題

なし
