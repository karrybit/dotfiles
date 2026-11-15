---
name: setup
description: 別のマシンで、karo と ~/cos の仕組みが動くかを確かめ、人がする段で止まる手順。オーナーが /karo:setup を打ったとき、別のマシンで cos を使い始めるとき、右の列の pane（files・thread）が戻らないときに使う。
---

# karo の仕組みを確かめる

- この skill は、karo を有効にした `~/cos` の会話で動く（karo は `~/cos/.claude/settings.json` の `enabledPlugins` でだけ読み込まれる）。`~/cos` の記録そのものは karo に入っていないので、`~/cos` の用意はこの skill の前にオーナーが行う。
- 確かめるのは構造（道具、plugin、settings、`~/cos` の git）で、記録の中身は確かめない。足りないものを入れる、settings を直す、ログインするのはオーナーで、CoS は一覧を示して止まる。
- record と thread-show は `~/.local/state/cos/` の下を、Agent の worktree は `git worktree add` が、それぞれ使うときに作るので、この skill はフォルダを作らない。

## 手順

1. karo の scripts と skill が呼ぶ道具を確かめる。次を 1 回の Bash で実行する。

   ```sh
   for t in herdr git jq yq rg fd ghq glow fb rumdl crit python3 shortid claude; do command -v "$t" >/dev/null || echo "missing: $t"; done
   ```

   完了条件: 出力が空か、`missing:` の行の一覧をオーナーに示している。
2. `claude plugin list` を実行し、`karrybit@skills-dir` と `karo@skills-dir` が読み込まれているか、`imozuru` の plugin（`karo:researcher` が使う）が入っているかを確かめる。`~/cos/rules/checkin.md` と `~/cos/rules/checkout.md` があれば、そこで使う plugin と外のサービスの接続も確かめる（ファイルがなければ確かめない）。
   完了条件: 確かめた plugin と接続のそれぞれについて、読み込まれているか、足りないことをオーナーに示している。
3. `~/.config/claude/skills/karo/scripts/settings-test ~/cos/.claude/settings.json` を単独で実行する。`FAIL` の行は、オーナーが `~/cos/.claude/settings.json` を直す（sandbox はその場所を書かせない）。
   完了条件: `settings-test: 0 failure(s)` が出たか、`FAIL` の行の一覧をオーナーに示している。
4. `git -C ~/cos branch --show-current` が `main` を出すかと、引数なしの `~/.config/claude/skills/karo/scripts/karo-check` を単独で実行した結果を確かめる。
   完了条件: `main` と `karo-check: 0 problem(s)` が出たか、違いをオーナーに示している。
5. 人がする段をオーナーに頼む。Claude Code のログイン、`~/cos` のフォルダの信頼のダイアログ、外のサービスの接続の認証、そしてオーナーのターミナルで `cos` を実行して CoS の会話を開き直すこと（`cos` は herdr の server をオーナーのターミナルから起こす）。
   完了条件: オーナーが、頼んだ段を終えたと答えた。

## pane が戻らないとき

- 右の列（`files` の pane と `thread` の pane）は、SessionStart の hook が `scripts/right-pane` で作り直す。right-pane は、`files` か `thread` の label の pane で shell と pager 以外が動いていると、列を変えずに `right-pane: <pane> is running <名前>; leaving the column as it is` を出して終わる。

1. `herdr pane list --workspace "$HERDR_WORKSPACE_ID"` を実行し、label が `files` か `thread` で始まる pane の `pane_id` と、right-pane の出力にある pane を見比べる。
   完了条件: 動いているものを止めないと列が戻らない pane の一覧が手元にある。
2. 一覧の pane で動いているものを止めてよいかをオーナーに尋ね、よいと答えた pane を `herdr pane close <pane_id>` で閉じる。
   完了条件: オーナーがよいと答えた pane がすべて閉じている。
3. `~/.config/claude/skills/karo/scripts/right-pane` を単独で実行する。
   完了条件: right-pane が何も出さずに終わり、`herdr pane list` に `files` と `thread` の pane がある。
