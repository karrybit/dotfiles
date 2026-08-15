# Provenance

- origin: local
- source: this dotfiles repository
- source_url: local
- license: local
- reviewed_at: 2026-08-15
- notes: 「必ず worktree を作成して subagent が行う。PR は draft。マージされたら worktree とローカルブランチを削除する」という繰り返しの依頼を手順化したもの。`analyze-tasks` を意図的に前提にしていない（着手条件を自前で持つ）。subagent に `git switch -c` を最初にやらせるのは、harness の自動命名だとマージ後に削除すべきブランチを特定できないため。draft は文章の指示だけで担保しており、機械的な強制は入れていない（PreToolUse hook で `gh pr create` を検査する版を作ったが、運用コストが見合わないと判断して取り下げた）。`EnterWorktree` は1セッション1 worktree の設計なので並行には使わず、記載もしていない。worktree 作成時にサンドボックスが `.git/config` への書き込みを拒否する事象はある業務リポジトリで観測されたもので、リポジトリごとに挙動が異なる。`disable-model-invocation: true` で明示呼び出しのみ。
