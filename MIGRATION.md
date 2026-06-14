# Migration: personal_neo

MacBook Neo を nix-darwin + chezmoi の管理下に移行する手順。

---

## 事前準備（このリポジトリ側）

### 1. ホスト名プレースホルダーを解決する

`nix/modules/profiles/personal_neo.nix` の `networking.hostName` はまだプレースホルダー。

personal_neo 上で実際のホスト名を確認する:

```sh
scutil --get LocalHostName
```

返ってきた値（例: `karrybit-MacBook-Neo`）で `personal_neo.nix` を更新する:

```nix
networking.hostName = "karrybit-MacBook-Neo";  # 実際の値に変更
```

更新後にコミット・プッシュしてから作業マシンに移る。

```sh
git add nix/modules/profiles/personal_neo.nix
git commit -m "fix(personal_neo): set actual hostname"
git push
```

---

## 移行手順（personal_neo 上で実行）

### 2. Homebrew をインストール（未インストールの場合）

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 3. chezmoi でドットファイルを適用

```sh
brew install chezmoi
chezmoi init --apply karrybit/dotfiles
# プロファイルを聞かれたら: personal_neo
```

chezmoi apply が行うこと:
- `~/.config/zsh/`, `~/.config/nvim/`, `~/.config/git/`, `~/.config/starship.toml` などを配置
- `run_onchange_` スクリプトを実行（Claude 設定の生成、スキルのシンクなど）

> **既存ファイルとの衝突:** chezmoi は既存の管理対象ファイルを上書きする。
> 特に `~/.gitconfig`（chezmoi は `~/.config/git/config` を配置するため競合しない）や
> 以前手動で置いた `~/.config/starship.toml` は chezmoi 版で置き換わる。
> 残したい設定があれば事前に退避すること。

### 4. Determinate Nix をインストール

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

インストール後、指示に従って新しいシェルを開く（またはターミナルを再起動）。

既存の nix インストール（`/nix/store` が存在する場合）は Determinate Nix と衝突する可能性がある。
その場合は先にアンインストールしてから再インストールすること。

### 5. Nix 設定を適用する（nixr）

新しいシェル（chezmoi apply 後）で実行:

```sh
nixr
```

内部的には以下を実行する:

```sh
sudo darwin-rebuild switch --flake ~/.local/share/chezmoi/nix#personal_neo
```

---

## nixr が行うこと（注意点）

### Homebrew パッケージの整理

`homebrew.onActivation.cleanup = "zap"` が設定されているため、nixr 実行後に
**nix 設定で宣言されていない Homebrew の formula と cask はすべて削除される**。

移行後に残る Homebrew 管理パッケージ:

| 種別 | パッケージ | 理由 |
|------|-----------|------|
| formula | `aqua` | nixpkgs 未収録 |
| formula | `chezmoi` | ブートストラップ依存 |
| cask | `personal_neo.nix` の `homebrew.casks` に列挙されたもの | nix-darwin 管理 |

それ以外の `brew install` でインストールしていたものはすべて削除される。
これは意図した動作（nix が代替する）だが、削除前に確認したい場合:

```sh
brew list        # 現在の formula 一覧
brew list --cask # 現在の cask 一覧
```

### Nix で管理されるパッケージ

`home.packages` の全ツール（bat, eza, fzf, lazygit, neovim, go, terraform など）が
`~/.nix-profile/bin/` に配置される。

PATH の優先順位は nix profile が Homebrew より前になるよう `.zshenv` で設定済み。

---

## 移行後の確認

```sh
# ツールが nix から提供されているか確認
which git      # → /etc/profiles/per-user/takumikaribe/bin/git
which starship # → /etc/profiles/per-user/takumikaribe/bin/starship

# tmux プラグインが正常にインストールされているか
tmux new-session
# prefix (Ctrl+t) を押してステータスバーが変わることを確認

# direnv が動作するか
cd /tmp && echo "use nix" > .envrc && direnv allow

# Git 設定が適用されているか（chezmoi 管理）
git config --global --list | head -10

# Starship が起動するか
starship --version

# ホスト名が正しく設定されているか
scutil --get LocalHostName
```

---

## トラブルシューティング

### `nixr` が失敗する — ホスト名不一致

`networking.hostName` に設定した値と実際のホスト名が異なっていても nixr は失敗しない
（nix-darwin がシステムのホスト名をその値に書き換える）。
逆に、書き換えたくない場合は `networking.hostName` 行を削除または実際の値に合わせること。

### Homebrew の PATH が nix より前に来る

```sh
which brew  # /opt/homebrew/bin/brew のはず
which git   # /etc/profiles/per-user/... であることを確認

# もし /opt/homebrew/bin/git になっていたら新しいシェルを開く
exec zsh
```

### chezmoi の差分が残っている

```sh
chezmoi status   # M がある場合は未適用の差分
chezmoi diff     # 内容を確認
chezmoi apply    # 適用
```
