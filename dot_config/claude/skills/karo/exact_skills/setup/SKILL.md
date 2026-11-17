---
name: setup
description: 別のマシンで、karo と ~/cos の仕組みが動くかを確かめ、人がする段で止まる手順。オーナーが /karo:setup を打ったとき、別のマシンで cos を使い始めるときに使う。
---

# karo の仕組みを確かめる

- この skill は、karo を有効にした `~/cos` の会話で動く（karo は `~/cos/.claude/settings.json` の `enabledPlugins` でだけ読み込まれる）。`~/cos` の記録そのものは karo に入っていないので、`~/cos` の用意はこの skill の前にオーナーが行う。
- 確かめるのは構造（道具、plugin、settings、`~/cos` の git）で、記録の中身は確かめない。足りないものを入れる、settings を直す、ログインするのはオーナーで、CoS は一覧を示して止まる。
- karo の scripts は `~/.local/state/cos/` の下を、Agent の worktree は `git worktree add` が、それぞれ使うときに作るので、この skill はフォルダを作らない。

## 手順

1. karo の scripts と skill が呼ぶ道具を確かめる。次を 1 回の Bash で実行する。

   ```sh
   for t in herdr git jq yq rg fd ghq rumdl crit terminal-browser python3 shortid claude bd; do command -v "$t" >/dev/null || echo "missing: $t"; done
   ```

   完了条件: 出力が空か、`missing:` の行の一覧をオーナーに示している。
2. `claude plugin list` を実行し、`karrybit@skills-dir` と `karo@skills-dir` が読み込まれているか、`imozuru` の plugin（`karo:researcher` が使う）が入っているかを確かめる。`~/cos/rules/checkin.md` と `~/cos/rules/checkout.md` があれば、そこで使う plugin と外のサービスの接続も確かめる（ファイルがなければ確かめない）。
   完了条件: 確かめた plugin と接続のそれぞれについて、読み込まれているか、足りないことをオーナーに示している。
3. `~/.config/claude/skills/karo/scripts/settings-test ~/cos/.claude/settings.json` を単独で実行する。karo の hook は karo の `hooks/hooks.json` が登録するので、settings に同じ hook があると `FAIL` になる（hook が 2 回走る）。`FAIL` の行は、オーナーが `~/cos/.claude/settings.json` を直す（sandbox はその場所を書かせない）。
   完了条件: `settings-test: 0 failure(s)` が出たか、`FAIL` の行の一覧をオーナーに示している。
4. `git -C ~/cos branch --show-current` が `main` を出すかと、引数なしの `~/.config/claude/skills/karo/scripts/karo-check` を単独で実行した結果を確かめる。
   完了条件: `main` と `karo-check: 0 problem(s)` が出たか、違いをオーナーに示している。
5. 人がする段をオーナーに頼む。Claude Code のログイン、`~/cos` のフォルダの信頼のダイアログ、外のサービスの接続の認証、そしてオーナーのターミナルで `cos` を実行して CoS の会話を開き直すこと（`cos` は herdr の server をオーナーのターミナルから起こす）。
   完了条件: オーナーが、頼んだ段を終えたと答えた。
