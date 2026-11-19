# 承認ダイアログとキーの送信

AGENTS.md の「Herdr の操作」に書いた場面で読む。画面の読み方、キーの送り方、送ったあとの確かめは `karo:herdr-agent` skill の「止まった Agent に答える」に従い、このファイルはどれに karo が答えるかと記録を決める。

## karo が答えるダイアログ

- Agent の承認ダイアログ（Herdr が `blocked` と出す Agent と、`agent-report --wait` が `status: awaiting-answer` で返した `idle` の Agent のもの）は、`herdr agent read` でコマンドの全文を読んでから扱う。スクリプトを動かすものは、そのスクリプトの中身も読む。
- 次のどれかにあたるダイアログには、karo が Yes を答える。
  - 読むだけのコマンド。
  - Agent の worktree、scratchpad、Agent が試しのために作った workspace（label が `-test` で終わるもの）、使い捨ての herdr のセッションの中だけで済む操作。その workspace を閉じることも含む。
  - Agent の worktree の中で、git が追跡しているファイルを `git rm`（`-r` を含む）で消すか、`git mv` で worktree の中の別のパスに移す操作のうち、`-f` も `--force` も付けないもの。消したファイルも移す前のパスも git の履歴から戻せる。
- push、上にあたらない削除と移動（`-f` か `--force` を付けた `git rm` と `git mv`、追跡していないファイルや ignored のファイルの削除、`rm -rf`、worktree の外の削除）、外への送信、karo の pane に触るもの、`view - ` の pane へのキー、秘密の情報を読むもの、内容がわからないもの、上のどれにあたるか迷うもの、起動時の信頼のダイアログ、Agent の AskUserQuestion は、AGENTS.md の「Herdr の操作」のとおり AskUserQuestion でオーナーに尋ね、オーナーの答えを skill の手順で送る。

## 答えたあと

- ダイアログに答えたら、答えたダイアログのコマンドの要旨を、その Agent のタスクの Beads に `メモ:` の comment で書く（`karo:tasks` skill の「comment の語」）。

## ページャ

- pane のページャは、skill の `safe-key quit` で閉じる。
