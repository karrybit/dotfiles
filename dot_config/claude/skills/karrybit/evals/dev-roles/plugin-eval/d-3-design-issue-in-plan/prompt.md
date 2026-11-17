---
max_turns: 40
timeout_seconds: 1800
allowed_tools: [Read, Glob, Grep, Skill, Agent, Bash, Write, Edit]
tags: [delivery]
---

docs/design/ の 3 つの Design Doc は、監査ログの CSV Export を画面・API サーバー・非同期の Job・オブジェクトストレージ・テーブルで作る設計で、設計の担当から受け取った。dev 環境で確かめながら作りたいので、実装をどの順に、何を確かめながら進めるかの計画を立ててほしい。

この仕事は karrybit:delivery-strategist の Agent に頼み、返ってきた報告を手を加えずにそのまま最後の返事にして。その Agent を使えなければ、自分で行って同じように報告して。
