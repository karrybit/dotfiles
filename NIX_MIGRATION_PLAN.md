# Nix 移行計画(chezmoi dotfiles / macOS Apple Silicon)

## Context

現状は chezmoi が dotfiles を管理し、パッケージは **Homebrew**(brew/cask/vscode拡張)・**aqua**(CLI 56/36本)・**rustup/cargo** の3系統に分散している。インストール手順は `run_onchange_*` スクリプトで冪等化されているが、宣言的な再現性・ロールバック・依存固定の面で弱い。

このプロジェクトの目的は **「現行管理を単に nix へ写すのではなく、nix を最大限活用した一元管理へ移行する」** こと。役割分担は **chezmoi = 配布 + シークレット、nix = 環境構築**。ただし環境を壊さず**インクリメンタル**に進める。確定した方針は以下:

- **対象3台と profile**: profile を唯一の真実とし、**OS 判定はしない**(profile → OS は所与):
  - `work` → macOS(社用) / nix-darwin
  - `personal_neo` → macOS(私用 Macbook Neo) / nix-darwin
  - `personal_minipc` → Linux(私用 Ubuntu) / **standalone home-manager**
- **一元化と全廃止**: CLI パッケージは **nix(home-manager `home.packages`)へ一元化**し、**aqua と package 系 `run_onchange` は可能な限り全廃止**。例外は cargo の一部(nixpkgs 欠落分)と vscode 拡張のみ。`personal_minipc` は clean slate な Linux のため **Homebrew/aqua を入れず最初から nix-native** で構築する(「最大限 nix」の試金石)。
- **ハイブリッド所有**: home-manager が「パッケージ + 主要プログラム設定(git/starship/tmux/zsh/nvim/direnv/fzf)」を所有。chezmoi は「暗号化シークレット(karabiner)+ 会社情報を含む生成設定(claude `settings.json` 等、pkl 経由で chezmoi 非管理)+ マシンブートストラップ」を残す。
- **インストーラ**: Determinate Nix。nix-darwin 併用時は **Determinate の darwin モジュール + `determinateNix.enable = true`** を使う(これが nix-darwin の Nix 管理を無効化する。旧来の `nix.enable = false` 単独指定より現行推奨)。Linux(mini PC)は Determinate or 公式インストーラ + standalone home-manager。
- **Rust**: `rustup` は維持(複数ツールチェイン切替の柔軟性優先)。cargo バイナリは nixpkgs にある物のみ Nix 化、無い物は `cargo install` のまま。
- **zsh**: 手作りファイル群(`zshenv.d/*`, `functions/*`, `widgets/*`, `lib/*`, `dot_zshrc` 等)は当面 `programs.zsh` で書き直さず、**home-manager の `xdg.configFile.source` でファイルのまま移送**。`programs.zsh` への将来移行は方針/手順を別ドキュメント **`NIX_ZSH_MIGRATION_PLAN.md`** に蓄積し、インクリメンタルに実施する。

クリーンスレート(Mac 2台: Nix 未インストール、arm64、Homebrew `/opt/homebrew` 稼働中。mini PC: Ubuntu、Nix 未導入)。

## 最終形(移行後の到達状態)

```
chezmoi リポジトリ (~/.local/share/chezmoi)
├── nix/                         # chezmoi 管理外(.chezmoiignore)。git 管理されるが dotfile 配備しない
│   ├── flake.nix / flake.lock   # profile → 構成 の静的マップ
│   ├── checks.nix               # checks.<system>(fmt/statix/deadnix/eval/home-build)
│   └── modules/
│       ├── darwin/common.nix    # darwin システム設定 + Determinate モジュール(Mac 2 profile 共有)
│       ├── darwin/homebrew.nix  # cask/mas(宣言的。Mac のみ)
│       ├── home/common.nix      # home-manager: パッケージ + xdg.configFile 群(全3 profile 共有)
│       ├── home/linux.nix       # personal_minipc 固有(Linux 専用)
│       └── profiles/{work,personal_neo,personal_minipc}.nix
├── dot_config/...               # zsh等のソースは残るが「home-manager が読む元」になる
└── (run_onchange の package 系は撤去 / claude・skills 系は残置)
```

flake 出力:
- `darwinConfigurations.work`, `darwinConfigurations.personal_neo`(macOS / nix-darwin)
- `homeConfigurations.personal_minipc`(Linux / standalone home-manager)

- パッケージ供給元: **Nix(home-manager `home.packages`)が CLI の唯一の主役**。aqua は全廃止。GUI は Homebrew cask だが **nix-darwin `homebrew` モジュールで宣言的管理**(Mac のみ)。rustup/一部 cargo bin と vscode 拡張のみ非Nix。
- 設定供給元: git/starship/tmux/nvim/direnv/fzf/zsh は **home-manager が `~/.config` にシンボリックリンク**(3台共通)。karabiner(暗号化)・会社情報を含む生成設定(pkl)・ブートストラップのみ chezmoi。
- プロファイル: chezmoi の `profile` プロンプトが唯一の真実。**OS 判定はせず profile → OS/builder を所与とする**。flake 側に profile→構成の静的マップを持たせ、rebuild ラッパが `chezmoi data | jq -r .profile` を読んでディスパッチ。
- 適用コマンド(rebuild ラッパが profile から自動選択):
  - darwin profile: `darwin-rebuild switch --flake ~/.local/share/chezmoi/nix#<profile>`
  - linux profile: `home-manager switch --flake ~/.local/share/chezmoi/nix#personal_minipc`

## パス所有権の分離(最大のリスク管理)

不変条件: **任意の時点で 1 パスの所有者は 1 ツールのみ**。home-manager に移すと同時に chezmoi から外す。各パスの引き継ぎ手順:

1. 当該パスを `.chezmoiignore` に追加(ターゲット相対パス。例 `.config/git`)→ `chezmoi apply` がそのパスを触らなくなる。
2. home-manager 宣言を追加(`programs.git` か、逐語コピーなら `xdg.configFile."...".source = ../../dot_config/...;`。`source` は **chezmoi のソースファイル**を指す。配備済みターゲットではない)。
3. 旧ターゲットを削除(`rm ~/.config/git/config` 等。内容は git に在る)→ rebuild(Mac=`darwin-rebuild switch`、Linux=`home-manager switch`)で home-manager が store シンボリックリンクを生成。home-manager は既存実体ファイルを上書きしないため削除が必須。

注: home/ モジュールは全3 profile 共有のため、設定移行はどの profile でも同じソースを参照する。Mac は nix-darwin 経由、`personal_minipc` は standalone home-manager 経由で同一の `modules/home/*` を適用する(差分は `modules/home/linux.nix` に限定)。

| パス | 新所有者 | 機構 | chezmoi 操作 |
|---|---|---|---|
| `~/.config/git/*` | home-manager | `programs.git`(逐語なら xdg.configFile) | `.config/git` を ignore |
| `~/.config/starship.toml` | home-manager | `programs.starship` + source | ignore |
| `~/.config/tmux/*` | home-manager | `programs.tmux` + source(tpm は brew 残置) | ignore |
| `~/.config/nvim/*` | home-manager | `xdg.configFile."nvim".source`(ディレクトリ逐語) | ignore |
| direnv / fzf | home-manager | `programs.direnv` / `programs.fzf`(zsh フック自動生成) | zsh 内の手書きフック行を削除 |
| `~/.config/zsh/**`(非tmpl) | home-manager | `xdg.configFile."zsh/...".source` 各ファイル | 個別に ignore |
| `~/.config/zsh/*.tmpl`(例 `20_tool_aqua.zsh.tmpl`) | **chezmoi 残置** | テンプレ。対応ツール完全撤去後に Nix 静的化 | 維持 |
| `private_karabiner/karabiner.json` | **chezmoi 残置** | 暗号化シークレット | 維持 |
| マシンブートストラップ | **chezmoi 残置** | — | 維持 |

順序: git/starship/tmux/nvim(自己完結)を先、**zsh は最後**(direnv/fzf/starship のシェル初期化と密結合。home-manager の `enableZshIntegration` でフック生成させ、同一コミットで `dot_zshrc`/`zshenv.d` の手書き対応行を削除)。

## PATH 優先順位(移行中)

`which X` が Nix の store パスを返すことで「Nix が供給している」と検証できる優先順を作る:

```
~/.nix-profile/bin
/etc/profiles/per-user/$USER/bin   # home-manager useUserPackages
/run/current-system/sw/bin         # nix-darwin システム
$AQUA_ROOT_DIR/bin                 # バッチ毎に縮小
$CARGO_HOME/bin                    # rustup/cargo
/opt/homebrew/bin /opt/homebrew/sbin
$XDG_BIN_HOME, /usr/local/sbin, system
```

**重要な是正点**: `dot_config/zsh/dot_zshrc:91` の末尾が Homebrew を再 prepend しており Nix を隠す。この行を「Nix パスを最後に prepend する」ブロックへ置換し、`typeset -U path`(92行目)で重複排除を維持。検証: `which rg` が `/nix/store/...` か `~/.nix-profile/bin` を返すこと(`/opt/homebrew/bin` でないこと)。

## 作業の進め方の原則(粒度)

- **1 ステップ = 1 コミット = 独立してロールバック可能**。各ステップは「変更 → rebuild/apply → 検証 → コミット」で閉じる。複数ツールを一度に動かさない。
- 各ステップに **完了条件(検証コマンド)** と **失敗時のロールバック** を持たせる。検証が通るまで次へ進まない。
- パッケージ移行は **1〜数本単位**(最大でも1バッチ=数本)で進め、各回 `which` 検証する。aqua/Homebrew は移行が終わるまで並行稼働させ、いつでも元の供給元に戻せる状態を保つ。
- 破壊的操作(`rm` での旧ターゲット削除、`cleanup = "zap"`)は対象を限定し、内容が git/Nix に保全されていることを確認してから実施。

## インクリメンタル工程

### フェーズ 0: 準備・退避(変更なし)
- **0.1** 現状スナップショット記録: `brew bundle dump`(参照用)、`aqua list`、主要ツールの `which -a`(rg/jq/go/kubectl 等)を控える。リポジトリが clean か `git status` 確認。
- **0.2** `~/.config` を tar で退避。`darwin-rebuild` 未導入のため現時点のロールバックは git revert + chezmoi apply であることを確認。
- 完了条件: スナップショットとバックアップが取得済み。

### フェーズ 1: Nix 本体の導入(パッケージ移行はまだしない)
- **1.1** Determinate Nix インストーラ実行。
- **1.2** 新規シェルで `nix --version` / flakes 有効を確認。検証: `nix --version && nix flake --help >/dev/null`
- **1.3** 既存ツールが無変更で動くこと(`which rg` 等が従来の供給元のまま)。
- ロールバック: `/nix/uninstall`(Determinate 提供)。

### フェーズ 2: flake 骨格のブートストラップ(空パッケージ)
- **2.1** `nix/` 作成し `.chezmoiignore` に `nix` 追記。検証: `chezmoi managed | grep -c '^.*nix/'` が 0。
- **2.2** `flake.nix` 最小(inputs: nixpkgs, determinate, nix-darwin, home-manager, flake-utils)。**profile→構成の静的マップ**(work/personal_neo=darwin、personal_minipc=linux)を定義。
- **2.3** `modules/darwin/common.nix`: Determinate darwin モジュール + `determinateNix.enable = true`、`system.stateVersion`、ユーザ定義(Mac 2 profile 共有)。
- **2.4** `modules/home/common.nix`: 空 `home.packages`、`home.stateVersion`、`useGlobalPkgs/useUserPackages`(全3 profile 共有)。`modules/home/linux.nix` スケルトン(personal_minipc 固有)。
- **2.5** `modules/profiles/{work,personal_neo,personal_minipc}.nix` スケルトン + flake outputs に **2 darwinConfigurations(work, personal_neo)+ 1 homeConfigurations(personal_minipc)**。
- **2.6** `nix flake check` が通る。
- **2.7** 初回適用。Mac: `darwin-rebuild switch --flake ./nix#work`(初回のみ `nix run nix-darwin -- switch ...`)、検証 `darwin-rebuild --list-generations`。Linux(mini PC): `nix run home-manager -- switch --flake ./nix#personal_minipc`、検証 `home-manager generations`。
- **2.8** **ロールバック往復テスト**: Mac=`darwin-rebuild --rollback` → 再 switch、Linux=`home-manager` 旧 generation を再 activate。以後のフェーズの安全網を確認。
- **2.9** rebuild ラッパ関数追加(`chezmoi data | jq -r .profile` で profile を読み、profile→構成マップに従い darwin profile は `darwin-rebuild switch`、linux profile は `home-manager switch` を `#<profile>` 付きで自動ディスパッチ)。
- **2.10** **テストハーネス導入(回帰安全網)**。以降のパッケージ/設定移行を機械的に検証できる土台をここで作る。フェーズ2のロールバック往復(2.8)が通った直後に入れることで、3 以降の各バッチの検証ゲートとして使える。詳細は §テストハーネス を参照。
  - **2.10a** 即時層(Nix 非依存・現行 dotfiles から動く): `Taskfile.yml`(go-task。`aqua` に既存の `go-task/task@v3.51.1` を再利用)に `render`/`zsh-lint`/`check` 追加。`test/render-and-lint.sh`(render→`zsh -n` 共有ロジック)、`test/Dockerfile`(`FROM nixos/nix`)。`.chezmoiignore` に `Taskfile.yml` と `test` を追記(配備しない)。
  - **2.10b** Nix 層(flake 骨格と同時): `nix/checks.nix`(`formatter.<system>` = nixfmt + `checks.<system>`: fmt/statix/deadnix/eval-darwin/home-linux)。`home-linux` チェックは**実構成 `homeConfigurations.personal_minipc.activationPackage`** を Linux でビルドして検証する(テスト用人工物ではなく本番ターゲット)。darwinConfigurations は eval のみ。
  - 検証: `task render && task zsh-lint` が green(着手前の現行 dotfiles で確認)、`task check` が mac で green、`task container` が green。
- ロールバック: 各ステップ git revert + 直前 generation へ rollback。

### フェーズ 3: PATH 是正 → CLI ツール移行(1〜数本ずつ)
- **3.0** PATH 優先順位の是正(検証の前提)。`dot_config/zsh/dot_zshrc:91` の Homebrew 再 prepend を Nix 優先ブロックへ置換し chezmoi apply。検証: 新シェルで `echo $path` に Nix パスが Homebrew より前。**この時点では全ツール Homebrew/aqua 供給のまま**なので `which` は変わらない(回帰なし確認)。
- **3.1〜** Batch1 を **数本ずつ**移行。各回:
  1. `nix eval nixpkgs#<pkg>.version` で在庫確認 → `home.packages` 追加 → rebuild。
  2. 検証 `which <tool>` が `/nix/store` or `~/.nix-profile/bin`。
  3. `aqua.<profile>.yaml` から該当行削除 → `aqua install --all`(プルーン)。
  4. `task flake-check`(+ 必要に応じ `task container`)green を確認し、再度 `which` 検証 + ツール単体の簡易動作確認 → コミット。
  - Batch1(確実): ripgrep, fd, bat, eza, fzf, jq, yq, delta, dust, hyperfine, gping, curlie, shellcheck, lazygit, ghq, tree-sitter, neovim, deno
  - Batch2(要バージョン確認/unfree): go, terraform(`allowUnfree`), tflint, actionlint, kustomize, kubectl, kind, helm, k6, buf, gofumpt, skaffold, kubectx, go-task, nickel, pkl, awscli2, gh
  - Batch3(欠落/陳腐化しやすい→aqua/cargo 残置判断): qsv, tbls, runn, jwt-cli, tfsec(非推奨), volta, gradle 系。各々 `nix eval` で在庫確認し、無ければ aqua 残置と理由を記録。
- **3.last** 3 profile すべて(work / personal_neo は `darwin-rebuild`、personal_minipc は `home-manager switch`)で rebuild & 主要ツール `which` を確認。aqua は全廃止が目標(残置が出た場合のみ理由を記録)。personal_minipc は aqua を最初から導入しないため対象外。
- ロールバック: 当該ツールを `home.packages` から外し aqua yaml に戻す(1コミット単位)。

### フェーズ 4: Homebrew(cask 宣言化 + CLI brew 移行)※ Mac のみ(work / personal_neo)。personal_minipc は対象外
- **4.1** `modules/darwin/homebrew.nix`: `enable=true`、`onActivation.cleanup="none"`、`autoUpdate=false`、`upgrade=false`、taps。空の casks で rebuild(差分なし確認)。
- **4.2** cask を **少数ずつ** `casks` へ移植 → rebuild → `brew bundle check` 相当で差分・再インストールが無いこと。
- **4.3** CLI brew を home.packages へ移行(antidote は zsh と結合するためフェーズ6と整合を取りつつ慎重に)。
- **4.4** 全 cask 移植後、`Brewfile.{work,personal_neo}`(Mac のみ)の cask を homebrew.nix へ集約。vscode 拡張は Brewfile/Homebrew 残置(移行しない)。personal_minipc(Linux)は Homebrew を使わないため対象外。
- **4.5** `cleanup` は `"none"` 維持を推奨。`"zap"` 化は全 cask 列挙確認後に限り、別ステップで実施。
- ロールバック: homebrew.nix の該当行削除 + Brewfile に戻す。

### フェーズ 5: Rust
- **5.1** `rustup` を `home.packages` に追加(ツールチェイン自体は rustup 管理のまま)。検証: `which rustc` が rustup shim、`rustup show` 動作。
- **5.2** nixpkgs 在庫の cargo bin(cargo-edit, cargo-expand, sccache, wasm-pack 等)を **1本ずつ** home.packages へ。検証: `which cargo-expand` が store。
  - **重要(二重管理の解消)**: cargo bin は現状 2 系統で供給されている — `Brewfile.work` の cargo ブロック(cargo-cache/deps/edit/expand/make/modules/sort/update/upgrades/workspaces, sea-orm-cli, wasm-pack)と `run_onchange_04_cargo_packages`(cargo-modules/upgrades/workspaces, sea-orm-cli)。**1本ずつ突き合わせて供給元を一意化**し、Nix 化した物は Brewfile/`run_onchange_04` の双方から除去する(同一ツールが Homebrew と cargo install の両方に残らないこと)。
- **5.3** 残り(cargo-sort/modules/upgrades/workspaces, sea-orm-cli 等)は `cargo install` 維持としてリスト整理。供給元は `run_onchange_04` のみに集約(Brewfile cargo ブロックからは撤去)。
- **5.4** `run_onchange_03/04` の役割を縮小(残置 cargo bin のみ管理)。
- ロールバック: 該当 cargo bin を home.packages から外す。

### フェーズ 6: 設定引き継ぎ(1パスずつ、所有権テーブル順、zsh 最後)
各ステップ共通手順: `.chezmoiignore` 追加 → home-manager 宣言追加 → 旧ターゲット `rm` → rebuild → `readlink ~/.config/<x>` が `/nix/store` → 新シェル/起動で動作確認 → コミット。
- **6.1** git
- **6.2** starship
- **6.3** tmux(tpm は brew/手動残置)
- **6.4** nvim(`xdg.configFile."nvim".source` でディレクトリ逐語)
- **6.5** direnv(`programs.direnv` でフック自動生成、`dot_zshrc:37` の手書き hook 削除)
- **6.6** fzf(`programs.fzf`、`lib/_fzf.zsh` との整合確認)
- **6.7** zsh(最も細かく分割):
  - **6.7a** 非テンプレ単独ファイル(`functions/*`, `widgets/*`, `lib/*`, `abbreviations.zsh`)を `xdg.configFile.source` で順次移送。
  - **6.7b** `zshenv.d/*`(非tmpl)を移送。`dot_zshenv`/`dot_zshrc` を最後に移送。
  - **6.7c** starship/direnv/fzf のシェル初期化を home-manager 生成へ寄せ、`dot_zshrc` の対応手書き行を削除。
  - **6.7d** テンプレファイル(`20_tool_aqua.zsh.tmpl` 等)は対応ツール完全撤去まで chezmoi 残置 → 撤去後に Nix 静的化。
- 完了条件: 各パスで `task render && task zsh-lint` が green、`chezmoi managed | grep -c zsh` が想定まで減少、新シェルで tmux 自動起動/補完/abbr/widget(Ctrl-R)/direnv が従来通り。
- ロールバック: ignore 解除 + home-manager 宣言削除 + `chezmoi apply` で復帰。

### フェーズ 7: 後片付け・ドキュメント
- **7.1** `run_onchange_01_homebrew` 削除(homebrew.nix へ移行済み)。
- **7.2** `run_onchange_02_aqua` 削除(aqua yaml 空化後)。残置ツールがあれば aqua のみ縮小維持。
  - **注意(OS ガード非対称)**: `run_onchange_01_homebrew` は `{{ if eq .chezmoi.os "darwin" }}` で守られているが、`run_onchange_02_aqua` は**ガード無しで `aqua install --all` を無条件実行**する。Linux コンテナ/CI 的文脈で誤って `chezmoi apply` すると aqua が走る live hazard。本スクリプト削除までの暫定防御として **darwin ガード追加**を検討(テストハーネスで Linux 適用を避ける前提とも整合)。
- **7.3** `run_onchange_03/04`(rust)を残置 cargo bin 用に整理。
- **7.4** `05_claude_settings`・`06_sync-skills` は chezmoi 固有のため残置。
- **7.5** README 更新(chezmoi と darwin-rebuild の責務境界、適用コマンド、プロファイル選択)。
- 完了条件: `chezmoi apply --dry-run` に package 系スクリプトが出ない。work / personal_neo で `darwin-rebuild switch` が差分なし、personal_minipc で `home-manager switch` が差分なし。

## テストハーネス(dotfiles / Nix の自動検証)

移行中の回帰を機械的に検出するための土台。**GitHub Actions / macOS CI は使わない**。3 層を整備し、Nix 非依存の層は移行着手前から動く(現行 dotfiles を即テスト可能)、Nix 依存の層は flake 骨格(フェーズ2)後に有効化する。タスクランナーは既存の go-task を再利用。

| 層 | コマンド | 検証内容 | 依存 |
|---|---|---|---|
| ローカル(即時) | `task render` | 全3 profile でテンプレが描画エラーなく展開 | chezmoi |
| ローカル(即時) | `task zsh-lint` | 描画済み zsh 全ファイルを `zsh -n` で構文チェック | zsh |
| Nix lint(P2後) | `task nix-fmt-check` / `task nix-lint` | `nixfmt --check` + `statix check` + `deadnix --fail` | nix/ |
| Nix(P2後) | `task flake-check` | `nix flake check`(mac=全部 / Linux=`--no-build`) | flake |
| コンテナ | `task container` | Linux で render+zsh-lint+nix-lint+Linux 可ビルド属性 | docker |
| まとめ | `task check`(= pre-push) | 上記を一括実行する単一ゲート | — |

### 技術判断
- **A. 混在 flake(darwin + linux)の検証**: `flake-utils.eachSystem` で `checks.<system>`(fmt/statix/deadnix)を全システムへ展開。**本番の `homeConfigurations.personal_minipc`**(standalone home-manager、Linux)を Linux でビルドして `home.packages` 解決を証明(mini PC は実機ターゲットなのでこれは本番検証を兼ねる)。`darwinConfigurations.{work,personal_neo}` は eval のみ(Linux=`nix flake check --no-build`、mac=完全 `nix flake check`)。home/ モジュールは Mac/Linux 共有のため、Linux build が通れば共有部の評価健全性も担保される。
- **B. 非対話プロファイル**: グローバル設定を汚さず per-file で `chezmoi execute-template --init --promptString profile=$P < <file>` を `for P in work personal_neo personal_minipc` でループ。
- **C. zsh 構文**: shellcheck は zsh 非対応(`path=()`/`typeset -U`/widget で誤検出)。`zsh -n` を使う。`.tmpl` は chezmoi で描画後、非テンプレはそのまま `zsh -n`。
- **D. Linux で `chezmoi apply` はしない**: `run_onchange_02_aqua` が `aqua install --all` を無条件実行するため危険(§フェーズ7.2 の注意)。コンテナは render+lint+構文+Linux 可ビルド属性のみ。将来 dry-run するなら `chezmoi apply --dry-run --exclude=scripts`。

### 限界(この Linux 中心・macOS CI 無し方式の弱点)
- `darwinConfigurations` の toplevel ビルド・Homebrew cask・vscode 拡張は**自動テスト外**。実ビルドは mac ローカルの `darwin-rebuild build` + `brew bundle check` のみがゲート。
- ランタイム挙動(tmux 自動起動・Ctrl-R widget・direnv hook `dot_zshrc:37`・starship・PATH 順 `dot_zshrc:91-92`)は `zsh -n` では見えない。フェーズ6 の手動 `readlink`/新シェル確認は残す。
- Linux(`personal_minipc`)は実機ターゲットかつ Nix でビルド可能なので、共有 home/ モジュールの回帰はコンテナ/ローカル Linux ビルドで捕捉できる。一方 darwin 固有部(nix-darwin オプション・homebrew・Determinate モジュール)は Mac ローカルでしか build されない点は不変。

## 主要編集ファイル

- 新規(Nix): `nix/flake.nix`(profile→構成 静的マップ + 2 darwinConfigurations + 1 homeConfigurations), `nix/modules/darwin/{common,homebrew}.nix`, `nix/modules/home/{common,zsh,linux}.nix`, `nix/modules/profiles/{work,personal_neo,personal_minipc}.nix`, `nix/checks.nix`
- 新規(テスト): `Taskfile.yml`, `test/render-and-lint.sh`, `test/Dockerfile`
- `/Users/takumikaribe/.local/share/chezmoi/.chezmoiignore`(`nix`・`Taskfile.yml`・`test` と移行済み config パスを追記)
- `/Users/takumikaribe/.local/share/chezmoi/dot_config/zsh/dot_zshrc`(91行目の Homebrew 再 prepend を Nix 優先へ是正)
- `.chezmoi.toml.tmpl`(profile プロンプトを work / personal_neo / personal_minipc の3値に更新)
- `dot_config/homebrew/Brewfile.{work,personal_neo}`(Mac のみ。`Brewfile.personal` をリネーム。cask/vscode は残し brew を削減 → 最終的に homebrew.nix へ集約。Linux 用 Brewfile は作らない)
- `dot_config/aquaproj-aqua/aqua.{work,personal_neo}.yaml`(`aqua.personal.yaml` をリネーム。バッチ毎に縮小し最終全廃止。Linux 用 aqua は作らない)
- `run_onchange_*` の hash 対象 profile 名追従(`personal` → `personal_neo`)。Linux profile では package 系 run_onchange を発火させない(OS ガード/profile 条件)
- rebuild ラッパ関数(`dot_config/zsh/functions/` に追加。`chezmoi data | jq -r .profile` でプロファイル選択)

## 検証(エンドツーエンド)

- フェーズ2後: `darwin-rebuild --list-generations` と `--rollback` の往復が成功すること。テストハーネス導入(2.10)後は `task check`(mac)と `task container`(Linux)が green。
- 各バッチ後: `task flake-check`(`home.packages` の解決を eval/build で証明)+ `task container`(home 設定がクロスプラットフォームで評価継続)を green にし、加えて移行ツールの `which` が Nix store/`~/.nix-profile` を指し、旧 `/opt/homebrew` や aqua bin を指さないこと。設定移行(フェーズ6)では `task render && task zsh-lint` を構文ゲートとし、`readlink` 確認は残す。
- 設定引き継ぎ後: `readlink` で `~/.config/<tool>` が `/nix/store` シンボリックリンクであること、かつ `chezmoi apply --dry-run` が当該パスに差分を出さないこと(二重所有が無い証明)。
- 新シェル起動: tmux 自動起動・starship・補完・abbreviations・widgets(Ctrl-R)・direnv が従来通り動くこと。
- 完了判定: README を更新し、`chezmoi managed` と `darwin-rebuild` の責務境界がドキュメントと一致すること。

---

# 別添: 問題・懸念事項

移行プロセス/移行後状態に関する既知のリスクと対処。

1. **Determinate ↔ nix-darwin の競合**: Determinate モジュールを入れずに通常の nix-darwin を適用すると activation が中断する("Determinate detected")。対処: `determinate.darwinModules.default` + `determinateNix.enable = true` を使う。副作用として nix-darwin の `nix.*`(gc/substituters/linux-builder)が使えず、Nix 設定は Determinate 側(`/etc/nix/nix.custom.conf`)へ移る。

2. **二重所有(最大リスク)**: chezmoi と home-manager が同一 `~/.config` パスを奪い合うと apply が壊れる。対処は §パス所有権の「ignore 追加 → 宣言追加 → 旧実体削除 → rebuild」を**同一コミットで**徹底すること以外にない。home-manager 宣言追加と `.chezmoiignore` 追記をセットにする。

3. **プロファイル選択のブリッジ**: Nix は eval 時に chezmoi の `profile` を読めない。flake 属性 `#work`/`#personal_neo`/`#personal_minipc` で選ぶため、rebuild ラッパで `chezmoi data | jq -r .profile` を読ませ、プロンプトを単一の真実に保つ。**profile → OS/builder は所与の静的マップ**(OS 判定しない): work・personal_neo は darwin(`darwin-rebuild`)、personal_minipc は linux(`home-manager switch`)。これを怠ると profile が二重管理になる。

4. **vscode 拡張**: MS 専有拡張(LiveShare 等)は nixpkgs に無い/unfree でライセンス制約あり。**移行せず Homebrew/Brewfile 管理のまま残す**。

5. **nixpkgs に無い cargo bin**: cargo-sort/modules/upgrades/workspaces, sea-orm-cli 等は陳腐化/欠落しやすい。`cargo install` を維持(スリム化した `04_cargo_packages` か home-manager activation script に寄せる)。

6. **Homebrew cleanup の事故**: `onActivation.cleanup` を最初から `"zap"` にすると flake に未記載の cask を削除する。**`"none"` で開始**し、全 cask を列挙し切ってから切替。`autoUpdate=false`/`upgrade=false` で rebuild を決定的に。Determinate 配下では Nix の GC は nix-darwin でなく Determinate が管理する点に注意。

7. **PATH 隠蔽**: `dot_zshrc:91` の Homebrew 再 prepend が Nix を隠す。是正必須(§PATH 優先順位)。VS Code 等の統合が PATH を書き換える点も考慮し、Nix prepend を最後段に置く。

8. **ロールバック**: Nix 側は `darwin-rebuild --rollback`/`--switch-generation N`、chezmoi 側は git revert。**フェーズ2 で一度ロールバックを実地検証**してから後続を信頼する。

9. **zsh テンプレート設定**: `20_tool_aqua.zsh.tmpl` 等プロファイル変数を含むファイルは home-manager がそのまま読めない。対応ツール完全撤去まで chezmoi 残置とし、撤去後に Nix 静的レンダリング(`pkgs.writeText`)へ変換する。

10. **nix-homebrew は初期不要**: Homebrew 自体の固定/移管が目的の nix-homebrew は、既存 `/opt/homebrew` が稼働中のため初期は導入しない。cask の宣言化は nix-darwin 標準 `homebrew` モジュールで足りる。

11. **テストの被覆ギャップ(macOS CI 無し)**: 採用方式(ローカル + Nix lint + Linux コンテナ)では `darwinConfigurations` の toplevel ビルド・Homebrew cask・vscode 拡張・ランタイム挙動(tmux/Ctrl-R/direnv/PATH 順)は自動テストされない。push 前の `task check`(mac ローカル)と手動 `readlink`/新シェル確認が唯一のゲートで、コンテナは補完。`homeConfigurations.test-*` は darwin と同一の home モジュールを import してドリフトを防ぐこと(乖離すると Linux green が偽の安心になる)。詳細は §テストハーネス。

12. **aqua スクリプトの live hazard**: `run_onchange_02_aqua` は OS ガード無しで `aqua install --all` を実行する(§フェーズ7.2)。Linux/CI 的文脈で誤って `chezmoi apply` すると aqua が走るため、テストは Linux で `chezmoi apply` を行わず render/lint/構文/Linux 可ビルド属性のみ検証する(§テストハーネス D)。**3 profile 化に伴い、package 系 run_onchange は Linux profile(personal_minipc)で発火しないよう profile/OS 条件で確実に閉じる**。

13. **Linux は standalone home-manager**: mini PC(personal_minipc)には nix-darwin が無いため、`homeConfigurations.personal_minipc` を `home-manager switch` で適用する。共有できるのは `modules/home/*` のみで、nix-darwin の `system.*`/`homebrew`/Determinate darwin モジュールは Mac 限定。Linux 固有差分は `modules/home/linux.nix` に隔離する。mini PC は clean slate のため Homebrew/aqua を導入せず最初から nix-native で構築し、「最大限 nix」の検証機とする。

14. **会社情報/シークレットの恒久方針**: claude `settings.json`(Vertex AI 環境値)など会社情報を含むファイルは **pkl 生成 + chezmoi 非管理**(`run_onchange_05` が base+personal+work の pkl から生成)。**nix へは移さない**。同種(将来の k8s 設定等)が出ても pkl パターンで回避し、nix/chezmoi 配布対象から外す。karabiner は引き続き chezmoi 暗号化シークレット。

15. **profile 値リネームの影響範囲**: `personal` → `personal_neo` への変更は `.chezmoi.toml.tmpl`・`Brewfile.personal`・`aqua.personal.yaml`・`run_onchange_*` の hash 対象に波及する。リネームは1コミットで一括し、`chezmoi diff`/`task render` で全 profile の描画が壊れないことを確認してから進める。
