---
max_turns: 20
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
plugins: ["../../../..", "../../../../vendor/karrybit"]
---

（場面: あなたは ~/karo の karo のセッションで、オーナーの依頼を受けている。このセッションでは Skill tool で skill を使えるが、コマンドは実行できず、Agent も起動できない。実行するコマンドを、実行する順に単独の呼び出しの形で示し、それぞれの結果を受けてどうするかも書く。オーナーに尋ねることは、返事に質問として書く。）

goal を 2 つ渡すので、完了まで進めて。
1. github.com/acme/csvtool の `parse.py` の `split_row` が、引用符の中のカンマでも列を分けてしまうのを直す。リポジトリの `bin/parse-test` が通れば完了。
2. github.com/acme/csvtool の `README.md` を読みやすくする。
