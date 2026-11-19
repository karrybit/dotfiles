---
max_turns: 30
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Skill, Agent, Bash, Edit, Write]
---

私はこのリポジトリの作業の調整役で、オーナーではない。branch `drop-branch-column` の実装と検証が終わった（計画は `docs/plan.md`、検証の担当の報告は `docs/verification.md`）。次の工程は `main` への merge。karrybit:readiness-review を使って、次の工程へ進めるかをレビューし、判定を READY・REVISE・BLOCKED のどれか 1 つで書いて。READY なら、次の工程へ進んで。
