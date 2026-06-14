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
| 2.7 初回適用(Mac: darwin-rebuild / Linux: home-manager) | ✅ | nix-darwin 26.11.aabb203 + home-manager 同時 activate 成功。generation 1 作成。詳細は課題ログ参照 |
| 2.8 ロールバック往復テスト | ✅ | gen 2 作成→rollback→再 switch 成功。初回ブートストラップが `nix run` 経由のため gen 0 なし(正常) |
| 2.9 rebuild ラッパ関数追加 | ✅ | `dot_config/zsh/functions/nixr` 作成。chezmoi data .profile で darwin-rebuild/home-manager を自動選択 |
| 2.10a テストハーネス即時層(Taskfile / render / zsh-lint) | ✅ | `Taskfile.yml` + `test/render-and-lint.sh` + `test/Dockerfile` 作成。65 files / 0 failed 確認済み |
| 2.10b テストハーネス Nix 層(checks.nix) | ✅ | `nix/checks.nix` 作成。darwin 4 checks ✅ / linux は Mac で skip(正常) |

## フェーズ 3: PATH 是正 → CLI ツール移行

| ステップ | 状態 | メモ |
|---|---|---|
| 3.0 PATH 優先順位是正(`dot_zshrc:91`) | ✅ | `10_path_system.zsh` + `dot_zshrc:91` 修正。Nix > Homebrew > tools > system 確認 |
| 3.1〜 Batch1(ripgrep/fd/bat/eza/fzf/jq/yq/delta/dust/hyperfine/gping/curlie/shellcheck/lazygit/ghq/tree-sitter/neovim/deno) | ✅ | home.packages に追加。aqua 両ファイル・Brewfile.work(git-delta)から削除。/etc/profiles/per-user/.../bin/ に全18本を確認 |
| 3.2〜 Batch2(go/terraform/tflint/actionlint/kustomize/kubectl/kind/helm/k6/buf/gofumpt/skaffold/kubectx/go-task/nickel/pkl/awscli2/gh) | ✅ | common 9本(home/common.nix) + work専用9本(profiles/work.nix)。全て /etc/profiles/per-user/.../bin/ を確認 |
| 3.3〜 Batch3(qsv/tbls/runn/jwt-cli/tfsec/volta/gradle 系 ― 在庫確認後判断) | ✅ | 6本移行(qsv jwt-cli tfsec volta common / runn tbls work)。gradle は nixpkgs 8.x vs aqua 9.x のため aqua 残置 |
| 3.last 3 profile 全台 rebuild & which 確認 | ✅ | work profile: 全33本 /etc/profiles/per-user/.../bin/ を確認。jwt-cli パッケージのバイナリ名は `jwt` |

## フェーズ 4: Homebrew 宣言化(Mac のみ)

| ステップ | 状態 | メモ |
|---|---|---|
| 4.1 `modules/darwin/homebrew.nix` 空構成 | ✅ | cleanup="none" / system.primaryUser 必須(nix-darwin 新要件) |
| 4.2 cask 少数ずつ移植 | ✅ | 4.4 と同時実施 |
| 4.3 CLI brew → home.packages 移行 | ✅ | awscli/dbmate/git-delta を nix 移行・Brewfile から除去 |
| 4.4 全 cask 移植・Brewfile 集約 | ✅ | work/personal_neo 全 cask を homebrew.nix + profile nix に集約 |
| 4.5 cleanup="zap" 切替(全列挙後) | ✅ | VSCode extensions → settings sync / cargo lines → run_onchange_04 継続。Brewfile 両ファイル削除・run_onchange_01 削除(7.1 前倒し) |

## フェーズ 5: Rust

| ステップ | 状態 | メモ |
|---|---|---|
| 5.1 `rustup` を home.packages へ | ✅ | aqua.work.yaml から除去 |
| 5.2 nixpkgs 在庫 cargo bin を 1 本ずつ移行 | ✅ | cargo-binstall/cache/edit/expand/modules/sort/update/workspaces/sea-orm-cli → work.nix。homebrew.brews から削除 |
| 5.3 残り cargo bin を run_onchange_04 に集約 | ✅ | cargo-upgrades のみ残置(nixpkgs 未収録) |
| 5.4 run_onchange_03/04 縮小 | ✅ | rust/package を 1 行に縮小。run_onchange_03 は継続(rustup components) |

## フェーズ 6: 設定引き継ぎ

| ステップ | 状態 | メモ |
|---|---|---|
| 6.1 git | ✅ | programs.git + programs.delta。chezmoi の dot_config/git/ を削除 |
| 6.2 starship | ✅ | programs.starship.settings。chezmoi の dot_config/starship.toml を削除 |
| 6.3 tmux | ✅ | programs.tmux.plugins で TPM 置換。tmux/tpm を homebrew から削除 |
| 6.4 nvim | ❌ | スキップ。lazy.nvim ベースの Lua 構成を chezmoi で管理継続。neovim バイナリは home.packages で nix 管理済み |
| 6.5 direnv | ✅ | programs.direnv + nix-direnv。shell hook は 6.7c で処理 |
| 6.6 fzf | ❌ | スキップ。カスタム関数は chezmoi zsh ファイルで管理継続。fzf バイナリは home.packages 管理済み |
| 6.7a zsh 非テンプレ単独ファイル | ❌ | スキップ。functions/widgets/lib/abbreviations/zshenv.d は chezmoi で管理継続。home-manager への逐語移送はツール責務の観点から不適切(NIX_ZSH_MIGRATION_PLAN.md 参照) |
| 6.7b antidote の nix 移行 | ⬜ | `brew --prefix/opt/antidote` 依存を撤去。nix パッケージ化 + dot_zshrc の source 行を修正。homebrew.nix から antidote / zsh-autosuggestions / zsh-completions を削除 |
| 6.7c shell init を zshrc から除去 | ⬜ | dot_zshrc の `eval "$(direnv hook zsh)"` と `eval "$(starship init zsh)"` を削除。programs.direnv/starship の enableZshIntegration で代替 — ただし programs.zsh.enable が前提 |
| 6.7d dot_zshrc / dot_zshenv 最終整理 | ⬜ | 6.7b/c 完了後に chezmoi 残置が適切か再評価 |
| 6.7e テンプレ静的化 | ✅ | aqua 廃止時に 20_tool_aqua.zsh.tmpl 削除済み。残テンプレなし |

### homebrew.nix Phase 6 残置 formula

antidote / zsh-autosuggestions / zsh-completions は 6.7b で nix 移行後に homebrew.nix から削除する。

## フェーズ 6補: aqua 廃止・Homebrew formula 整理(フェーズ5直後に実施)

| ステップ | 状態 | メモ |
|---|---|---|
| aqua の global package 管理廃止 | ✅ | aqua.work.yaml / aqua.personal_neo.yaml / run_onchange_02 削除。aqua 本体は Homebrew に残置(nixpkgs 未収録) |
| 残 Homebrew formula の nix 移行 | ✅ | autoconf cmake git gnused libpq openjdk python313 tree wget → work/personal_neo に追加 |
| zsh-abbr の nix 移行 | ✅ | work/personal_neo に追加 |
| common.nix からパッケージ除去 | ✅ | プロファイル別完全独立に設計変更。AGENTS.md に設計思想を記録 |

## フェーズ 7: 後片付け・ドキュメント

| ステップ | 状態 | メモ |
|---|---|---|
| 7.1 `run_onchange_01_homebrew` 削除 | ✅ | 4.5 と同時に実施 |
| 7.2 `run_onchange_02_aqua` 削除 | ✅ | フェーズ6補で実施 |
| 7.3 `run_onchange_03/04` 整理 | ⬜ | |
| 7.4 `05_claude_settings`/`06_sync-skills` 残置確認 | ⬜ | |
| 7.5 README 更新 | ⬜ | |

---

## 次セッションの開始点

**最初にやること: 6.7b antidote の nix 移行**

フェーズ6 の残作業:
1. **6.7b**: antidote を nix パッケージ化し `brew --prefix` 依存を撤去。homebrew.nix から antidote / zsh-autosuggestions / zsh-completions を削除。
2. **6.7c**: dot_zshrc の direnv/starship eval 行を削除(programs.zsh.enable が必要か検討)。
3. **6.7d**: dot_zshrc/dot_zshenv の残置が適切か再評価。

設計方針:
- functions/widgets/lib/abbreviations/zshenv.d は chezmoi 管理継続(home-manager 逐語移送は責務不一致のため行わない)
- NIX_ZSH_MIGRATION_PLAN.md に詳細方針を記録

残る run_onchange:
- run_onchange_03_rustup_components: rustup components (cargo/clippy/rustfmt)
- run_onchange_04_cargo_packages: cargo-upgrades のみ
- run_onchange_05_claude_settings: Claude 設定
- run_onchange_06_sync-skills: スキル同期

Homebrew に残る formula:
- antidote / zsh-autosuggestions / zsh-completions → 6.7b で nix 移行後に削除
- aqua → nixpkgs 未収録のため永続的に Homebrew 管理
- chezmoi → bootstrap 依存のため永続的に Homebrew 管理

---

## 確立済み事実(次セッションの前提知識)

| 項目 | 値 |
|---|---|
| Nix バージョン | Determinate Nix 3.21.1 (nix 2.34.7) |
| nix-darwin バージョン | 26.11.aabb203 |
| system generation | 2 (2.8 のロールバックテストで switch ×2 実施済み) |
| darwin-rebuild PATH | `/run/current-system/sw/bin/darwin-rebuild` — 新シェルで PATH に入ることを確認済み ✅ |
| flake パス | `~/.local/share/chezmoi/nix` |
| flake attribute | `darwinConfigurations.work` (このMac) |
| rebuild コマンド | `nixr` または `sudo darwin-rebuild switch --flake ~/.local/share/chezmoi/nix#work` |
| nixr 関数 | `dot_config/zsh/functions/nixr` — 新シェルで自動 autoload。サブコマンド: switch / rollback / list |
| nix.custom.conf | nix-darwin + Determinate が共同管理。内容は `cores=0 / sandbox=false` |
| personal_neo hostname | 仮("personal-neo") → 実機で確認して修正 |

---

## 課題ログ

| 日付 | フェーズ | 内容 | 状態 |
|---|---|---|---|
| 2026-06-14 | 計画 | フェーズ0のバックアップをリポジトリ外に置く設計だったが、`snapshots/` をリポジトリ内に作り `.chezmoiignore` で除外する方式に修正。git 管理されるが chezmoi は配備しない。 | ✅ 解決済み |
| 2026-06-14 | 2.4 | home/common.nix で `nixpkgs.config.allowUnfree` を設定すると `useGlobalPkgs=true` と非互換の警告。Mac(darwin)は darwin/common.nix で設定、Linux(personal_minipc)は home/linux.nix で設定する設計に修正。 | ✅ 解決済み |
| 2026-06-14 | 2.2 | nix-darwin の flake URL は `github:nix-community/nix-darwin` ではなく `github:LnL7/nix-darwin`。 | ✅ 解決済み |
| 2026-06-14 | profile | `personal` → `personal_neo` リネーム実施。`Brewfile.personal_neo`/`aqua.personal_neo.yaml` に改名。`run_onchange_02_aqua` に `personal_minipc` ガード追加(aqua は Linux で動かさない)。 | ✅ 解決済み |
| 2026-06-14 | 2.7 | 初回 darwin-rebuild に sudo が必要。`nix run github:LnL7/nix-darwin/... -- switch` だと activation で "must be run as root" エラー。`sudo nix run ...` で解決。 | ✅ 解決済み |
| 2026-06-14 | 2.7 | `/etc/nix/nix.custom.conf` が Determinate Nix インストーラが作成した空ファイルで存在しており、nix-darwin の activation が衝突してエラー。`sudo mv /etc/nix/nix.custom.conf /etc/nix/nix.custom.conf.before-nix-darwin` でリネームして解決。nix-darwin が書き込んだ内容は `cores=0 / sandbox=false`(Determinate module 管理)。 | ✅ 解決済み |
| 2026-06-14 | 2.7 | darwin-rebuild は activation 後 `/run/current-system/sw/bin/` に存在するが、現行シェルの PATH には入っていない。新しいターミナルを開くと zsh 設定で PATH が更新される(要確認)。 | ✅ 解決済み — 翌セッションで `which darwin-rebuild` = `/run/current-system/sw/bin/darwin-rebuild` を確認 |
