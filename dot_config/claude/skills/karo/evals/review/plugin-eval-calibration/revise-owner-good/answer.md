Review Agent の判定は REVISE でした。設計の持ち主の `karo-k7m-1` に返します。

1. 判定を `~/karo/project/repo/github.com/acme/csvtool/review/karo-k7m.1-agent-1.md` に Write で保存し、`~/.config/claude/skills/karo/scripts/commit` で commit する（本文: 指摘 1 件）。OK の行を確かめる。
2. `bd comment karo-k7m.1 --file <scratchpad>/judgement.md --json`。本文は「判定: REVISE（次工程: karo-k7m.2 の実装）。原本: ~/karo/project/repo/github.com/acme/csvtool/review/karo-k7m.1-agent-1.md」。
3. `bd comment karo-k7m.1 --file <scratchpad>/change-request.md --json`。本文は「変更依頼: docs/design.md:12 が R2 を落としている。原本: ~/karo/project/repo/github.com/acme/csvtool/review/karo-k7m.1-agent-1.md」。
4. `~/.config/claude/skills/karo/skills/herdr-agent/scripts/agent-ctl send karo-k7m-1 "レビューの判定は REVISE。docs/design.md:12 の split_row の契約に、ブリーフの R2（引用符の中の改行を 1 つの列に含める）を入れて直す。あわせて、下流の karo-k7m.2 の完了条件に R2 のテストを足す案を設計に書く。原本: ~/karo/project/repo/github.com/acme/csvtool/review/karo-k7m.1-agent-1.md"`。JSON の status が working になるのを確かめる。
5. `~/.config/claude/skills/karo/skills/herdr-agent/scripts/agent-ctl close karo-k7m.1-rv` で Review Agent の tab を閉じる。
6. karo-k7m.2 の受け入れ条件に「bin/parse-test に R2 のテストがあり通る」を足す（`bd update karo-k7m.2 --acceptance '...' --json`）。
7. `agent-report --wait karo-k7m-1` を background で走らせて直しを待つ。直しの完了報告を受けたら、前の判定の原本と直した差分を渡して、直した箇所と波及する範囲の再レビューを頼む。

karo-k7m.2 は再レビューで READY になるまで始めません。karo-k7m.3 はゲートとつながらないので、別に進められます。
