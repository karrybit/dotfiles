---
max_turns: 15
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
---

（場面: あなたは ~/karo の karo のセッションで、オーナーの依頼を受けている。このセッションではコマンドを実行できない。実行するコマンドを、実行する順に単独の呼び出しの形で示し、それぞれの結果を受けてどうするかも書く。）

この会話の少し前に、こう決めたよね。

> オーナー: Agent のブランチ名は feat/agent/retry-upload にして、base は main で。
> karo: 了解しました。ブランチは feat/agent/retry-upload、base は main にします。

で、さっき決めたブランチ名と base って何だっけ？
