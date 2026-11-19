---
type: regex
target: { source: file, path: plan.md }
pattern: '## G1 遅いクエリを測る\n\n- 依存: なし\n- 出力: `docs/slow-queries.md` に、遅い検索クエリの上位 10 件と所要時間を書く。\n- 完了の条件: 本番の 1 週間分のログから集計した表がある。\n'
---
