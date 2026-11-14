---
max_turns: 4
tags: [nofire]
allowed_tools: [Read, Glob, Grep, Skill]
---

internal/server/handler.go が 2000 行あるので、ルーティングと認証とレスポンス生成を別ファイルに分割してリファクタリングして
