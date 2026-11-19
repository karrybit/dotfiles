Review Agent の判定は REVISE でした。設計の持ち主の `karo-k7m-1` に返します。

1. 判定を `~/karo/project/repo/github.com/acme/csvtool/review/karo-k7m.1-agent-1.md` に Write で保存し、commit する。
2. `bd comment karo-k7m.1 --file <scratchpad>/judgement.md --json`。本文は「判定: REVISE。原本: ~/karo/project/repo/github.com/acme/csvtool/review/karo-k7m.1-agent-1.md」。
3. `bd comment karo-k7m.1 --file <scratchpad>/change-request.md --json`。本文は「変更依頼: docs/design.md:12 が R2 を落としている」。
4. `~/.config/claude/skills/karo/skills/herdr-agent/scripts/agent-ctl send karo-k7m-1 "レビューの判定は REVISE。docs/design.md:12 の split_row の契約に、ブリーフの R2（引用符の中の改行を 1 つの列に含める）を入れて直す。"`
5. `agent-ctl close karo-k7m.1-rv` で Review Agent を閉じる。
6. 直しの完了報告を受けたら、再レビューを頼む。

ほかのタスクは今のままにします。
