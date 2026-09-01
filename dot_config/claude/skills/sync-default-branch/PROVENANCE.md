# Provenance

- origin: local
- source: this dotfiles repository
- source_url: local
- license: local
- reviewed_at: 2026-09-01
- notes: `commit-commands:clean_gone`（公式プラグイン、`~/.config/claude/plugins/marketplaces/claude-plugins-official/plugins/commit-commands/commands/clean_gone.md`）を読んで確認した通り、あのコマンドは `git branch -v` / `git worktree list` / `git branch -D` しか実行せず、ブランチの切り替えを一切行わない。乗っている作業ブランチが `[gone]` になっていると `git branch -D` がカレントブランチの削除を拒否し、後片付けが不完全に終わる。これがユーザーの「main に移動してくれないことがある」の実体で、公式プラグインなので直接編集せず、前段の別スキルとして切り出した。`--prune` を明示するのは `fetch.prune` がリポジトリ側の設定に依存するため（このマシンではグローバルに true だが、他のリポジトリ/マシンでは保証できない）。`--ff-only` は乖離を黙って解消せず可視化するための選択。worktree 内から実行した場合にメイン worktree への `git -C` リダイレクトを避けているのは `parallel-work` の既知の制約と同じ理由（意図された隔離の回避を避ける)。
