---
name: setup
description: 別のマシンで、karo と $KARO_HOME の仕組みが動くかを確かめ、人がする段で止まる手順。オーナーが /karo:setup を打ったとき、別のマシンで karo を使い始めるときに使う。
---

# karo の仕組みを確かめる

- この skill は、karo を有効にした `$KARO_HOME` の会話で動く（karo は `$KARO_HOME/.claude/settings.json` の `enabledPlugins` でだけ読み込まれる）。`$KARO_HOME` は、この skill の前に、オーナーがターミナルで `~/.config/claude/skills/karo/scripts/karo-setup` を実行して作る（骨組みの型の写し、git、空の `.claude/settings.local.json`、Beads。すでにあるファイルは上書きしない）。
- 確かめるのは構造（道具、plugin、settings、`$KARO_HOME` の git）で、記録の中身は確かめない。足りないものを入れる、settings を直す、ログインするのはオーナーで、karo は一覧を示して止まる。
- karo の scripts は `$KARO_STATE_HOME/` の下を、Agent の worktree は `git worktree add` が、それぞれ使うときに作るので、この skill はフォルダを作らない。

## 手順

1. karo の scripts と skill が呼ぶ道具を、`~/.config/claude/skills/karo/scripts/karo-setup --check` を単独で実行して確かめる。道具の一覧と入れ方の案内は karo-setup が持ち、karo-setup は道具を入れない。
   完了条件: `karo-setup: required tools found` が出て `missing:` の行がないか、`missing:` の行の一覧（使えなくなる機能と入れ方の案内つき）をオーナーに示している。
2. `claude plugin list` を実行し、`karrybit@skills-dir` と `karo@skills-dir` が読み込まれているか、`imozuru` の plugin（`karrybit:researcher` が分野を探る調査で使う）が入っているかを確かめる。`$KARO_HOME/rule/checkin.md` があれば、その「外の情報源」の節で使う plugin と外のサービスの接続も確かめる（ファイルがなければ確かめない）。
   完了条件: 確かめた plugin と接続のそれぞれについて、読み込まれているか、足りないことをオーナーに示している。
3. `~/.config/claude/skills/karo/scripts/settings-test $KARO_HOME/.claude/settings.json $KARO_HOME/.claude/settings.local.json $KARO_HOME/.claude/karo-settings.json` を単独で実行する。settings-test は、karo に共通の `settings.json`、オーナーや環境に依存する値を持つ git の外の `settings.local.json`、karo の会話だけが `--settings` で読む `karo-settings.json` を、Claude Code と同じく配列をつないで合わせてから確かめる。karo の hook は karo の `hooks/hooks.json` が登録するので、settings に同じ hook があると `FAIL` になる（hook が 2 回走る）。`FAIL` の行は、オーナーが 3 つのファイルのどれかを直す（sandbox はその場所を書かせない）。
   完了条件: `settings-test: 0 failure(s)` が出たか、`FAIL` の行の一覧をオーナーに示している。
4. `git -C $KARO_HOME branch --show-current` が `main` を出すかと、引数なしの `~/.config/claude/skills/karo/scripts/karo-check` を単独で実行した結果を確かめる。
   完了条件: `main` と `karo-check: 0 problem(s)` が出たか、違いをオーナーに示している。
5. 人がする段をオーナーに頼む。Claude Code のログイン、`$KARO_HOME` のフォルダの信頼のダイアログ、外のサービスの接続の認証、そしてオーナーのターミナルで `karo` を実行して karo の会話を開き直すこと（`karo` は herdr の server をオーナーのターミナルから起こす）。
   allow や deny などを足すとき（外のサービスへ書き込む前の確認に、使う MCP のツールの `permissions.ask` を置くときを含む）は、`$KARO_HOME/.claude/settings.local.json` を変えるよう案内する（`settings.json` は karo に共通の値だけを持つ）。
   完了条件: オーナーが、頼んだ段を終えたと答えた。
