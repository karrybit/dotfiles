---
max_turns: 30
timeout_seconds: 1200
allowed_tools: [Read, Glob, Grep, Skill, Agent, Bash, Write, Edit]
tags: [delivery]
---

slug.py の slugify が数字を消してしまう（`slugify("Release 2")` が `release` になり、`release-2` にならない）。このバグの直しをどう進めるかの計画を立ててほしい。

この仕事は karrybit:delivery-strategist の Agent に頼み、返ってきた報告を手を加えずにそのまま最後の返事にして。その Agent を使えなければ、自分で行って同じように報告して。
