# zsh → home-manager (`programs.zsh`) 移行方針

`NIX_MIGRATION_PLAN.md` のフェーズ6.7 を補完する、zsh 設定の nix-native 化方針。
**当面は逐語移送(`xdg.configFile.source`)で現状維持**し、`programs.zsh` への書き直しは
本ドキュメントに沿って**インクリメンタル**に進める。今は方針の蓄積が目的で、実移行は
後続セッションで段階実施する。

関連: `NIX_MIGRATION_PLAN.md` フェーズ6.7(zsh)、§テストハーネス(`task render`/`task zsh-lint`)。

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

### B. 逐語維持(`xdg.configFile.source`。書き直さない)
- `functions/*`・`widgets/*`・`lib/*`・`abbreviations.zsh`・`completions/*`・
  `zshenv.d/*`(非テンプレ)・`env.d/*`。内容はファイルのまま store シンボリックリンク化。
- これらは `programs.zsh.initExtra`/`fpath`/`autoload` で読み込み配線のみ home-manager 側に持たせる。

### C. chezmoi 残置(home-manager がそのまま読めない)
- `zshenv.d/20_tool_aqua.zsh.tmpl` … profile 変数を含むテンプレ。**aqua 完全撤去(本体計画
  フェーズ7.2)まで chezmoi 残置**し、撤去後に削除 or `pkgs.writeText` で静的化。
- 手動配置の `port_forward.zsh`(`dot_zshrc:32-34`、chezmoi 管理外)はそのまま。

## 既存の OS 分岐と Linux 対応

`dot_zshrc` は既に `darwin*`/`linux*` 分岐を持つ(`:8-24` テーマ/manjaro、`:73-82` 関数
fpath)。`programs.zsh` 化の際は home-manager の `lib.mkIf pkgs.stdenv.isDarwin` 等へ
対応付ける。Linux(personal_minipc)では:
- `:59` の `brew --prefix` antidote は使えない → A のプラグイン宣言化が前提。
- manjaro 固有 source(`:16-22`)は Ubuntu では不要 → 条件分岐を見直す。
- `:91` の `/opt/homebrew` prepend は darwin 限定にガードする(本体計画フェーズ3.0 の PATH
  是正と整合)。

## インクリメンタル手順(案)

各ステップは「home-manager 宣言追加 → `.chezmoiignore` 追加 → 旧ターゲット `rm` → rebuild →
検証 → コミット」で閉じる(本体計画 §パス所有権と同じ不変条件)。順序:

1. **shell init の宣言化**(direnv → starship → fzf)。各々 home-manager 統合を有効化し、
   `dot_zshrc` の対応手書き行を同一コミットで削除。検証: 新シェルで hook/プロンプト/`^r` が従来通り。
2. **プラグイン宣言化**(antidote → `programs.zsh.antidote`)。`brew --prefix` 依存撤去。
   検証: syntax-highlighting/autosuggestions/history-substring-search が機能。
3. **逐語ファイル群の移送**(B)。`functions`/`widgets`/`lib`/`abbreviations`/`zshenv.d` を
   `xdg.configFile.source` で移し、読み込み配線を `programs.zsh` 側へ。検証: 補完・abbr・widget。
4. **エントリ最終化**。`dot_zshrc`/`dot_zshenv` の残余を `programs.zsh.initExtra` 等へ整理。
5. **テンプレ(C)の静的化**。aqua 撤去後に `20_tool_aqua.zsh.tmpl` を削除/静的化。

## 検証とロールバック

- 各段で `task render`(全3 profile)+ `task zsh-lint`(`zsh -n`)を green に。
- ランタイム確認(自動テスト外): tmux 自動起動・補完・abbr・widget(`^r`)・direnv・starship・
  PATH 順。Mac と mini PC(Linux)の両方で新シェル起動確認。
- ロールバック: home-manager 宣言削除 + `.chezmoiignore` 解除 + `chezmoi apply` で復帰
  (1 ステップ=1 コミット)。

## 当面の結論

今は **B/C を維持したまま A のうち direnv/starship/fzf/antidote のみを優先的に宣言化**する
余地がある(Homebrew 依存撤去 = Linux 対応の前提)。それ以外は逐語維持で十分。完全な
`programs.zsh` 化は本体計画フェーズ6.7 の中で段階的に判断する。
