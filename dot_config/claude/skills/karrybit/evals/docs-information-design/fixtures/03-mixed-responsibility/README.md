# kumo-sync

kumo-sync は、ローカルディレクトリを S3 互換ストレージへ一方向に同期する CLI です。差分は mtime とサイズで判定し、`--checksum` 指定時のみ SHA-256 で比較します。

## インストール

```
brew install example/tap/kumo-sync
```

## 使い方

```
kumo-sync push ./photos s3://my-bucket/photos
```

- `--dry-run`: 転送せず、転送予定のファイルだけを表示する
- `--checksum`: mtime/サイズではなく SHA-256 で差分を判定する（遅いが確実）
- `--delete`: 同期元に存在しないオブジェクトを同期先から削除する。**取り消せない**ので、最初は `--dry-run` と併用すること

認証情報は AWS SDK の標準的な探索順（環境変数 → `~/.aws/credentials` → インスタンスロール）で読み込みます。

## 開発環境のセットアップ

Go 1.23 以上が必要です。

```
git clone https://github.com/example/kumo-sync
cd kumo-sync
make tools   # golangci-lint と minio をインストール
make test    # ユニットテスト
make e2e     # ローカルの minio を起動して E2E テストを実行
```

E2E テストはポート 9000 を使います。PR を出す前に `make lint` が通ることを確認してください。コミットメッセージは Conventional Commits に従います。

## 内部設計

同期は 3 段のパイプラインです。

1. **scanner**: 同期元を走査し、`FileEntry` を channel に流す
2. **differ**: 同期先の `ListObjectsV2` 結果とマージ結合して転送対象を決める。同期先の一覧はページングしながら取得し、全件をメモリに載せない
3. **uploader**: 8 並列でアップロードする。5 GiB を超えるファイルはマルチパートに切り替える

differ がマージ結合を使うのは、同期先が数百万オブジェクトでもメモリ使用量を一定に保つためです。そのため scanner はパスを辞書順で出力しなければならず、この順序を崩す変更は differ を壊します。

## リリース手順（メンテナ向け）

1. `main` が green であることを確認する
2. `CHANGELOG.md` の Unreleased 節をバージョン番号に書き換える
3. `git tag vX.Y.Z && git push origin vX.Y.Z`
4. GitHub Actions の release ワークフローが goreleaser でバイナリを作り、Homebrew tap の formula を更新する
5. tap の PR が自動マージされたことを確認する。失敗した場合は `HOMEBREW_TAP_TOKEN` の期限切れを疑う

## ライセンス

Apache-2.0
