# zsh → home-manager (`programs.zsh`) 移行方針

`NIX_MIGRATION_PLAN.md` のフェーズ6.7 を補完する、zsh 設定の nix-native 化方針。
**当面は逐語移送(`xdg.configFile.source`)で現状維持**し、`programs.zsh` への書き直しは
本ドキュメントに沿って**インクリメンタル**に進める。今は方針の蓄積が目的で、実移行は
後続セッションで段階実施する。

関連: `NIX_MIGRATION_PLAN.md` フェーズ6.7(zsh)、§テストハーネス(`task render`/`task zsh-lint`)、§参考(antidote→`programs.zsh.antidote` 等の外部実例)。

## なぜ慎重に進めるか

- 手作り zsh 群は補完・widget・abbr・プラグイン・OS 分岐が密結合で、`programs.zsh` への
  一括書き直しは回帰リスクが高い。
- 一方「最大限 nix」の観点では、プラグイン管理とシェル初期化(direnv/starship/fzf)は
  home-manager が宣言的に生成でき、`brew --prefix` 依存や手書き eval を排除できる。
- **3 台(work/personal_neo=macOS、personal_minipc=Linux)で同一 home/ モジュールを共有**
  する前提のため、Homebrew 依存(下記)の解消は Linux 対応の必須条件でもある。

## 現行構成の棚卸し(`dot_config/zsh/`)

| 区分 | ファイル | 備考 |
|---|---|---|
| エントリ | `dot_zshrc` / `dot_zshenv` | tmux 自動起動・補完・各種 source の中枢 |
| 略語 | `abbreviations.zsh` | `dot_zshrc:26` で source |
| プラグイン | `dot_zsh_plugins.txt`(antidote) | zsh-completions / ez-compinit / syntax-highlighting / autosuggestions / history-substring-search |
| env(宣言) | `zshenv.d/*.zsh` | `00_xdg` `10_path_system` `20_tool_*`(多数)`80_input` `90_zsh` `99_path_dedupe`。**`20_tool_aqua.zsh.tmpl` のみテンプレ** |
| env(対話) | `env.d/*.zsh` | `gcloud.zsh` `sdkman.zsh`(手動導入ツール初期化) |
| 関数 | `functions/*` | 22 本 + `functions/darwin/ports` `functions/linux/gnu_top`(OS 別) |
| widget | `widgets/*` | fzf 履歴 widget(`__select_history_with_fzf`、`dot_zshrc:84-85` で `^r` バインド) |
| lib | `lib/_fzf.zsh` `lib/_ui.zsh` | fzf 設定は独立 init 行が無くここに集約 |
| 補完 | `completions/git-completion.{bash,zsh}` | |

## nix 化の分類

### A. home-manager の `programs.*` / 宣言機能へ寄せる(nix-native 化の主対象)
- **プラグイン**: `dot_zsh_plugins.txt`(antidote)→ `programs.zsh.antidote`(home-manager
  がプラグイン管理)。これにより `dot_zshrc:59` の `source $(brew --prefix)/opt/antidote/...`
  という **Homebrew 依存を撤去**(Linux 必須)。`bindkey` の history-substring-search も
  プラグイン読込後に home-manager 生成へ。
- **direnv**: `dot_zshrc:37` `eval "$(direnv hook zsh)"` → `programs.direnv.enableZshIntegration`。
- **starship**: `dot_zshrc:53` `eval "$(starship init zsh)"` → `programs.starship.enableZshIntegration`。
- **fzf**: `programs.fzf.enableZshIntegration` と `lib/_fzf.zsh`・widget(`^r`)の整合を取る
  (キーバインドの二重定義に注意)。
- **history オプション**(`dot_zshrc:45-50`)/ **補完初期化**(`compinit`/`bashcompinit`):
  `programs.zsh` の `history`/`enableCompletion` 等へ寄せられる分は寄せる。

### B. chezmoi 残置(逐語移送は行わない — 方針変更)
- `functions/*`・`widgets/*`・`lib/*`・`abbreviations.zsh`・`completions/*`・
  `zshenv.d/*`(非テンプレ)・`env.d/*` は **chezmoi で管理継続**。
- **変更理由**: `xdg.configFile.source` による home-manager 移送を当初計画したが、以下の理由で不採用とした。
  1. **責務不一致**: chezmoi の責務は任意ファイルの配備。custom shell スクリプト群はまさにその対象であり、home-manager に移す理由がない。
  2. **不変性の弊害**: nix store 経由のシンボリックリンクになると読み取り専用になり、関数を開発中に直接編集できなくなる。すべての変更が `nixr` 経由になる。
  3. **Linux 互換の誤解**: これらのファイルには Homebrew パスが含まれていない。Linux 互換の問題は antidote の `brew --prefix` 依存(A の課題)であり B は無関係。
- `programs.zsh.initExtra`/`fpath`/`autoload` の配線は dot_zshrc(chezmoi 管理)に残す。

### C. chezmoi 残置(その他)
- `zshenv.d/20_tool_aqua.zsh.tmpl` … **aqua 廃止(フェーズ6補)時に削除済み**。テンプレート残置なし。
- 手動配置の `port_forward.zsh`(`dot_zshrc:32-34`、chezmoi 管理外)はそのまま。

## 既存の OS 分岐と Linux 対応

`dot_zshrc` は既に `darwin*`/`linux*` 分岐を持つ(`:8-24` テーマ/manjaro、`:73-82` 関数
fpath)。`programs.zsh` 化の際は home-manager の `lib.mkIf pkgs.stdenv.isDarwin` 等へ
対応付ける。Linux(personal_minipc)では:
- `:59` の `brew --prefix` antidote は使えない → A のプラグイン宣言化が前提。
- manjaro 固有 source(`:16-22`)は Ubuntu では不要 → 条件分岐を見直す。
- `:91` の `/opt/homebrew` prepend は darwin 限定にガードする(本体計画フェーズ3.0 の PATH
  是正と整合)。

## インクリメンタル手順(改訂版)

各ステップは「home-manager 宣言追加 → 旧ターゲット `rm` → rebuild → 検証 → コミット」で閉じる。

1. **antidote の nix 移行**(6.7b)。nix パッケージ化し `brew --prefix` 依存を撤去。
   `dot_zshrc` の antidote source 行を nix store パス経由に修正。
   homebrew.nix から antidote / zsh-autosuggestions / zsh-completions を削除。
   検証: syntax-highlighting / autosuggestions / history-substring-search が機能。
2. **shell init の除去**(6.7c)。`programs.direnv.enableZshIntegration` /
   `programs.starship.enableZshIntegration` を有効化し `dot_zshrc` の eval 行を削除。
   ※ `programs.zsh.enable = true` が必要かを先に判断する。
3. **dot_zshrc/dot_zshenv の再評価**(6.7d)。上記完了後に chezmoi 残置が適切かを判断。

**B(functions/widgets/lib 等)は chezmoi 管理継続。逐語移送は行わない。**

## 検証とロールバック

- 各段で `task render`(全3 profile)+ `task zsh-lint`(`zsh -n`)を green に。
- ランタイム確認(自動テスト外): tmux 自動起動・補完・abbr・widget(`^r`)・direnv・starship・
  PATH 順。Mac と mini PC(Linux)の両方で新シェル起動確認。
- ロールバック: home-manager 宣言削除 + `.chezmoiignore` 解除 + `chezmoi apply` で復帰
  (1 ステップ=1 コミット)。

## 当面の結論(更新)

- **A(nix-native 化)のうち direnv/starship は完了**。fzf はスキップ(カスタム実装を維持)。**antidote が残り**。
- **B(逐語ファイル群)は chezmoi 残置に方針変更**。責務不一致・不変性の弊害・Linux 互換への無関係を根拠とする。
- **C のテンプレートは削除済み**(aqua 廃止時)。
- 完全な `programs.zsh` 化は必須ではない。antidote の `brew --prefix` 依存撤去が実質的なゴール。
