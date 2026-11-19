---
max_turns: 30
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Skill]
---

report-api に次の 3 つを入れたい。3 人の Agent に 1 つずつ任せて、できるだけ並列で進めたい。誰に何をどの順で任せ、どこで合流させるかを設計して返して。まだ任せないで、何も変えないで。

- (a) GET /reports に format=csv を足して、CSV でも返せるようにする
- (b) GET /reports にページング（limit と cursor）を足す
- (c) docs/guide.ja.md を英訳した docs/guide.en.md を作る
