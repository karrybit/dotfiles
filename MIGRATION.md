# Migration: private_neo

chezmoi 管理済みの MacBook Neo に Nix (home-manager) を導入する手順。
Homebrew・chezmoi はインストール済みの前提。

---

## 手順

### 1. chezmoi プロファイルを設定する

`~/.config/chezmoi/chezmoi.toml` を編集してプロファイルを `private_neo` に設定する:

```toml
[data]
    name = "karrybit"
    profile = "private_neo"
```

ファイルが存在しない場合は新規作成する。設定後に chezmoi を適用する:

```sh
chezmoi apply
```

### 3. Determinate Nix をインストール

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

インストール後、指示に従って新しいシェルを開く（またはターミナルを再起動）。

既存の nix インストール（`/nix/store` が存在する場合）は Determinate Nix と衝突する可能性がある。
その場合は先にアンインストールしてから再インストールすること。

### 4. home-manager を適用する

初回は home-manager が PATH にないため `nix run` を使う:

```sh
nix run home-manager -- switch --flake ~/.local/share/chezmoi/nix#private_neo
```

以降は `home-manager switch --flake ~/.local/share/chezmoi/nix#private_neo` が使える。

### 5. Homebrew パッケージをインストール

```sh
brew bundle install --file ~/.config/homebrew/Brewfile.private_neo
```

---

## 移行後の確認

```sh
# ツールが nix から提供されているか確認
which git      # → ~/.nix-profile/bin/git
which starship # → ~/.nix-profile/bin/starship

# tmux プラグインが正常にインストールされているか
tmux new-session
# prefix (Ctrl+t) を押してステータスバーが変わることを確認

# direnv が動作するか
cd /tmp && echo "use nix" > .envrc && direnv allow
```

---

## トラブルシューティング

### Homebrew の PATH が nix より前に来る

```sh
which git   # ~/.nix-profile/bin/git であることを確認
# もし /opt/homebrew/bin/git になっていたら新しいシェルを開く
exec zsh
```

### chezmoi の差分が残っている

```sh
chezmoi status   # M がある場合は未適用の差分
chezmoi diff     # 内容を確認
chezmoi apply    # 適用
```
