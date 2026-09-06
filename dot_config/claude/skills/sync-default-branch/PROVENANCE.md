# Provenance

- origin: local
- source: this dotfiles repository
- source_url: local
- license: local
- reviewed_at: 2026-09-02
- notes: 後片付けを `commit-commands:clean_gone`（公式プラグイン、`~/.config/claude/plugins/marketplaces/claude-plugins-official/plugins/commit-commands/commands/clean_gone.md`）に任せずこのスキルが持つのは、ソースを読んで確認した3点のため。あのコマンドは `git branch -v` / `git worktree list` / `git branch -D` しか実行せず、削除対象を `[gone]` で選び、ブランチを切り替えない。`-u` を付けない運用ではブランチに upstream が設定されず `[gone]` が現れないので、あの判定はこの環境で何も見つけない。加えて `git branch -D` は未マージの作業も黙って捨て、カレントブランチの削除拒否も報告されない。公式プラグインは直接編集せず、別スキルとして置いた。削除判定を `git branch --merged` と `gh pr list --head` の2経路にしているのは、squash マージされたブランチが前者の祖先判定に出ないため（`git cherry` は単一コミットの squash しか一致させられず代替にならない）。worktree の除去は破棄操作なので報告に留め、`parallel-work` 側に残した。`--prune` を明示するのは `fetch.prune` がリポジトリ側の設定に依存するため（このマシンではグローバルに true だが、他のリポジトリ/マシンでは保証できない）。`--ff-only` は乖離を黙って解消せず可視化するための選択。worktree 内から実行した場合にメイン worktree への `git -C` リダイレクトを避けているのは `parallel-work` の既知の制約と同じ理由（意図された隔離の回避を避ける）。根拠の詳細は `~/.local/share/agents/docs/sandbox-and-environment-gotchas.md`。
