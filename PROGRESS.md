# Nix 移行 進捗記録

計画書: `NIX_MIGRATION_PLAN.md` / `NIX_ZSH_MIGRATION_PLAN.md`

セッションを跨いで作業を継続するための進捗・課題ログ。
各ステップ完了時にこのファイルを更新する。

---

## 凡例

| 記号 | 意味 |
|---|---|
| ✅ | 完了 |
| 🔄 | 進行中 |
| ⏸ | 保留(理由あり) |
| ❌ | 断念(理由あり) |
| ⬜ | 未着手 |

---

## フェーズ 0: 準備・退避

| ステップ | 状態 | メモ |
|---|---|---|
| 0.1 git status 確認 | ✅ | clean(未コミット変更は今セッション分のみ) |
| 0.2 `.chezmoiignore` に `snapshots` 追記 | ✅ | `PROGRESS.md` / `snapshots` を同時追記 |
| 0.3 テキストスナップショット取得 | ✅ | `snapshots/Brewfile.snapshot`(112行), `aqua-list.txt`(2383行), `which-all.txt`(20行) |
| 0.4 `~/.config` tar ローカル退避 | ✅ | `~/dotconfig-backup-20260614.tar.gz`(168MB, リポジトリ外) |
| 0.5 `snapshots/` コミット | ✅ | 4f0a8d2 |
| 0.6 ロールバック手段確認 | ✅ | darwin-rebuild 未導入のため `git revert + chezmoi apply` |

## フェーズ 1: Nix 本体の導入

| ステップ | 状態 | メモ |
|---|---|---|
| 1.1 Determinate Nix インストール | ✅ | インストール済み。新ターミナルを開くまで PATH に反映されない |
| 1.2 `nix --version` / flakes 有効確認 | ✅ | Determinate Nix 3.21.1 / `/etc/nix/nix.conf` に `extra-experimental-features = nix-command flakes` 確認済み |
| 1.3 既存ツールが無変更で動くこと | ✅ | aqua/brew/zsh/git が従来の供給元のまま動作確認済み |

## フェーズ 2: flake 骨格のブートストラップ

| ステップ | 状態 | メモ |
|---|---|---|
| 2.1 `nix/` 作成・`.chezmoiignore` 追記 | ✅ | `chezmoi managed \| grep nix/` = 0 確認済み |
| 2.2 `flake.nix` 最小構成 | ✅ | nixpkgs-unstable + follows ピン + mkDarwin/mkHome map |
| 2.3 `modules/darwin/common.nix` | ✅ | determinateNix.enable + system.stateVersion = 5 |
| 2.4 `modules/home/common.nix` + `linux.nix` スケルトン | ✅ | allowUnfree は linux.nix のみ(useGlobalPkgs 非互換) |
| 2.5 `modules/profiles/{work,personal_neo,personal_minipc}.nix` | ✅ | personal_neo の hostname は仮("personal-neo") |
| 2.6 `nix flake check` | ✅ | darwin 2構成 ✅、x86_64-linux は Mac では skip(正常) |
| 2.7 初回適用(Mac: darwin-rebuild / Linux: home-manager) | ⬜ | **次: `darwin-rebuild switch --flake ./nix#work`** |
| 2.8 ロールバック往復テスト | ⬜ | |
| 2.9 rebuild ラッパ関数追加 | ⬜ | |
| 2.10a テストハーネス即時層(Taskfile / render / zsh-lint) | ⬜ | |
| 2.10b テストハーネス Nix 層(checks.nix) | ⬜ | |

## フェーズ 3: PATH 是正 → CLI ツール移行

| ステップ | 状態 | メモ |
|---|---|---|
| 3.0 PATH 優先順位是正(`dot_zshrc:91`) | ⬜ | |
| 3.1〜 Batch1(ripgrep/fd/bat/eza/fzf/jq/yq/delta/dust/hyperfine/gping/curlie/shellcheck/lazygit/ghq/tree-sitter/neovim/deno) | ⬜ | |
| 3.2〜 Batch2(go/terraform/tflint/actionlint/kustomize/kubectl/kind/helm/k6/buf/gofumpt/skaffold/kubectx/go-task/nickel/pkl/awscli2/gh) | ⬜ | |
| 3.3〜 Batch3(qsv/tbls/runn/jwt-cli/tfsec/volta/gradle 系 ― 在庫確認後判断) | ⬜ | |
| 3.last 3 profile 全台 rebuild & which 確認 | ⬜ | |

## フェーズ 4: Homebrew 宣言化(Mac のみ)

| ステップ | 状態 | メモ |
|---|---|---|
| 4.1 `modules/darwin/homebrew.nix` 空構成 | ⬜ | cleanup="none" |
| 4.2 cask 少数ずつ移植 | ⬜ | |
| 4.3 CLI brew → home.packages 移行 | ⬜ | |
| 4.4 全 cask 移植・Brewfile 集約 | ⬜ | |
| 4.5 cleanup="zap" 切替(全列挙後) | ⬜ | |

## フェーズ 5: Rust

| ステップ | 状態 | メモ |
|---|---|---|
| 5.1 `rustup` を home.packages へ | ⬜ | |
| 5.2 nixpkgs 在庫 cargo bin を 1 本ずつ移行 | ⬜ | Brewfile/run_onchange_04 双方から除去 |
| 5.3 残り cargo bin を run_onchange_04 に集約 | ⬜ | |
| 5.4 run_onchange_03/04 縮小 | ⬜ | |

## フェーズ 6: 設定引き継ぎ

| ステップ | 状態 | メモ |
|---|---|---|
| 6.1 git | ⬜ | |
| 6.2 starship | ⬜ | |
| 6.3 tmux(tpm は残置) | ⬜ | |
| 6.4 nvim | ⬜ | |
| 6.5 direnv | ⬜ | |
| 6.6 fzf | ⬜ | |
| 6.7a zsh 非テンプレ単独ファイル | ⬜ | functions/widgets/lib/abbreviations |
| 6.7b zsh zshenv.d(非tmpl) / dot_zshenv / dot_zshrc | ⬜ | |
| 6.7c starship/direnv/fzf init を home-manager 生成へ | ⬜ | |
| 6.7d テンプレ残置 → aqua 撤去後に静的化 | ⬜ | |

## フェーズ 7: 後片付け・ドキュメント

| ステップ | 状態 | メモ |
|---|---|---|
| 7.1 `run_onchange_01_homebrew` 削除 | ⬜ | |
| 7.2 `run_onchange_02_aqua` 削除 | ⬜ | |
| 7.3 `run_onchange_03/04` 整理 | ⬜ | |
| 7.4 `05_claude_settings`/`06_sync-skills` 残置確認 | ⬜ | |
| 7.5 README 更新 | ⬜ | |

---

## 課題ログ

| 日付 | フェーズ | 内容 | 状態 |
|---|---|---|---|
| 2026-06-14 | 計画 | フェーズ0のバックアップをリポジトリ外に置く設計だったが、`snapshots/` をリポジトリ内に作り `.chezmoiignore` で除外する方式に修正。git 管理されるが chezmoi は配備しない。 | ✅ 解決済み |
| 2026-06-14 | 2.4 | home/common.nix で `nixpkgs.config.allowUnfree` を設定すると `useGlobalPkgs=true` と非互換の警告。Mac(darwin)は darwin/common.nix で設定、Linux(personal_minipc)は home/linux.nix で設定する設計に修正。 | ✅ 解決済み |
| 2026-06-14 | 2.2 | nix-darwin の flake URL は `github:nix-community/nix-darwin` ではなく `github:LnL7/nix-darwin`。 | ✅ 解決済み |
| 2026-06-14 | profile | `personal` → `personal_neo` リネーム実施。`Brewfile.personal_neo`/`aqua.personal_neo.yaml` に改名。`run_onchange_02_aqua` に `personal_minipc` ガード追加(aqua は Linux で動かさない)。 | ✅ 解決済み |
