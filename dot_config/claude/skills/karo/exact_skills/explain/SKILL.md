---
name: explain
description: '~/cos/docs/ に控える HTML の解説の手順。版を探して決め、作る部分は karrybit:explain に cos の書き先と控えの規則を渡して任せ、commit して控える。オーナーが資料・リポジトリ・仕組みの解説を HTML で頼んだとき、前の解説を開きたいとき、作り直しを頼んだときに、karrybit:explain の代わりに使う（この skill が karrybit:explain を呼ぶ）。'
---

# HTML の解説を ~/cos/docs に控える

- HTML の解説は、1 ファイルの HTML で資料や仕組みを解説するもの。置き場所は `~/cos/docs/<id>/<version>/` で、`index.html` と `index.md` を置く。
- この skill は、cos の運用（版の探し方、置き場所、`index.md`、commit）だけを持つ。作り方、評価のしかた、依頼の型を直すときは `karrybit:explain` skill にある。
- 下の `<karo-check>` は `~/.config/claude/skills/karo/scripts/karo-check` で、この `~/` の形のまま書く。

## 控えの `index.md`

- 元の資料の版ごとに `~/cos/docs/<id>/<version>/` のフォルダを足し、同じ版の作り直しはそのフォルダに作り直す。
- `index.md` のフロントマターは `karo:frontmatter` skill の種類の表の `Explain` の行に従う（tasks は解説を頼まれたタスク ID、derived_from は頼まれた threads の発言）。
- `index.md` の本文には、元の資料の URL と版（git は commit の完全な hash）、頼まれた内容と生成時の文脈、要点、確かめられなかったこと、資料と実物の食い違いを書く。

## 手順

1. 同じ元の資料の解説を探す。`rg -l -x -g 'index.md' 'resource: <元の資料の URL かパス>' ~/cos/docs` で `index.md` を探し、`description` と頼まれた内容から、同じ話題の id を選ぶ。
   完了条件: 同じ話題の id か、それがないことが手元にある。
2. id と版のフォルダを決める。
   - 同じ話題がなければ、`shortid` で新しい id（意味を持たない 8 文字の小文字と数字）を出す。話題は id にせず、`index.md` の `description` に書く。
   - 版は元の資料の版にする。git は読んだ commit の `git rev-parse --short <commit>` の出力、版の番号を持つページ（wiki など）はその番号、版のない資料は `1` から始める連番。
   - 同じ id に今の版のフォルダがあれば、作らずにその `index.html` を渡す（オーナーが作り直しを頼んだときは同じフォルダに作り直す）。版のない資料は、最大の番号の版を渡し、作り直しを頼まれたときだけ次の番号の版を作る。

   完了条件: 渡す既存の `index.html` のパスか、作る `<id>/<version>` が決まっている。
3. 2 で作る `<id>/<version>` を決めたときは、`karrybit:explain` skill を Skill tool で呼び、その手順を最後まで進める。渡す値は次のとおり。
   - HTML の書き先: `~/cos/docs/<id>/<version>/index.html`。
   - 説明の文書の書き先: オーナーが説明の文書も残すよう頼んだときだけ渡す。書き先は `~/cos/docs/<話題>.md`、フロントマターは `karo:frontmatter` skill の種類の表の `Document` の行（derived_from は頼まれた threads の発言、sources は元の資料と版）、検査は `<karo-check> --only docs/<話題>.md`。
   - 控えのファイル: `~/cos/docs/<id>/<version>/index.md`。書き方の規則は上の「控えの `index.md`」、検査は `<karo-check> --only docs/<id>/<version>/index.md`。
   - 頼まれた内容の原文: 頼まれた threads の発言。
   - 呼び出し側が元の資料の場所・版・読み方を渡したときは、それもそのまま渡す。

   完了条件: `karrybit:explain` の返事に、`~/cos/docs/<id>/<version>/index.html` と `index.md` の絶対パスがある。
4. 返事の `index.md` が上の「控えの `index.md`」のフロントマターと本文の項目を満たすかを確かめ、2 つのファイル（説明の文書を `~/cos/docs/<話題>.md` に置いたときはそれも）のパスを渡して commit する（`karo:record` skill）。
   完了条件: commit が `OK` の行を出した。
