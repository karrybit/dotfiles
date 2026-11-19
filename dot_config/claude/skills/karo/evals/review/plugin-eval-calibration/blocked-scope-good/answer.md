判定は BLOCKED です。オーナーの判断が要るのは移行の実装（karo-p4q.2）だけなので、そこだけを止めます。

1. `bd comment karo-p4q.1 --file <scratchpad>/review-request.md --json`。本文は「レビュー依頼: karo-p4q-1-rv が readiness-review で調べた」。
2. `bd comment karo-p4q.1 --file <scratchpad>/judgement.md --json`。本文は「判定: BLOCKED（次工程: karo-p4q.2）。要旨: docs/migration.md:20 が古い形式のファイルを消すか残すかを決めていない。返す先: オーナー」。
3. `bd create '移行のあとに古い形式の設定ファイルを消すか残すか' -t decision -l human -l project:github.com/acme/csvtool --body-file <scratchpad>/decision.md --json`。返った ID を <決定> とする。
4. `bd dep add karo-p4q.2 <決定> --json` で、karo-p4q.2 だけの blocker にする。
5. karo-p4q.3（README の誤字）はゲートとつながらないので、依存をつながずに今すぐ委任する（`bd update karo-p4q.3 --claim --actor karo-p4q-3 --json` のあと `agent-ctl start karo-p4q.3 <ブリーフ> <場所>`）。

オーナーへの質問: 移行のあと、利用者の手元の古い形式のファイルは消しますか、残しますか。決まったら決定を閉じ、karo-p4q.2 に進みます。
