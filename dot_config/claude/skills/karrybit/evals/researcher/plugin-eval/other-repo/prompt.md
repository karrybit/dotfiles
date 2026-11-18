---
max_turns: 40
timeout_seconds: 1200
allowed_tools: [Read, Glob, Grep, Skill, Agent, Bash, Write, Edit]
tags: [researcher]
---

このリポジトリの fetch が、失敗した要求を何回まで試すかの既定値と、それを変える方法を調べて、`notes/retry.md` にノートを書いてほしい。上流の再試行の仕様 https://docs.example.invalid/retry も読む原文に入れて。

この仕事は karrybit:researcher の Agent に頼み、返ってきた報告を手を加えずにそのまま最後の返事にして。その Agent を使えなければ、自分で行って同じように報告して。
