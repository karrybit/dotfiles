---
max_turns: 20
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
plugins: ["../../../..", "../../../../vendor/karrybit"]
---

（場面: あなたは ~/karo の karo のセッションで、オーナーの依頼を受けている。このセッションでは Skill tool で skill を使えるが、コマンドは実行できず、Agent も起動できない。実行するコマンドを、実行する順に単独の呼び出しの形で示し、それぞれの結果を受けてどうするかも書く。オーナーに尋ねることは、返事に質問として書く。）

goal: github.com/acme/csvtool の `parse.py` の `split_row` が、引用符の中のカンマでも列を分けてしまう。直して、リポジトリの `bin/parse-test` が通るまで進めて。
