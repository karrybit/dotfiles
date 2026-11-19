判定は BLOCKED です。オーナーの判断が出るまで、この epic の作業を止めます。

1. 判定を `~/karo/project/repo/github.com/acme/csvtool/review/karo-p4q.1-agent-1.md` に保存して commit する。
2. `bd comment karo-p4q.1 --file <scratchpad>/judgement.md --json`。本文は「判定: BLOCKED。原本: ~/karo/project/repo/github.com/acme/csvtool/review/karo-p4q.1-agent-1.md」。
3. `bd create '移行のあとに古い形式の設定ファイルを消すか残すか' -t decision -l human -l project:github.com/acme/csvtool --body-file <scratchpad>/decision.md --json`。返った ID を <決定> とする。
4. `bd dep add karo-p4q.2 <決定> --json`
5. `bd dep add karo-p4q.3 <決定> --json`。同じ epic なので、README の直しも決定のあとにまとめて進める。

オーナーへの質問: 移行のあと、利用者の手元の古い形式のファイルは消しますか、残しますか。
