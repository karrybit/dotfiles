# aqua-policy-allow

aqua は `aqua/aqua-policy.yaml` を、そのファイルの**絶対パス**が許可されるまで無視する。
許可の記録も絶対パスごと（`AQUA_ROOT_DIR/policies/<絶対パス>`）に持つ。git worktree は
毎回別のパスなので、worktree を作った直後は aqua が包む全コマンドがポリシー警告を出し、
`aqua policy allow` を手で打つまで消えない。

`bin/allow-project-policy` は SessionStart hook として動き、セッションが開いた
ディレクトリの `aqua/aqua-policy.yaml` を許可する。成功時は無言。

## 設計判断

- **成功時は何も出さない。** セッション開始時に「道具が使える状態になった」ことを
  報告する価値はない。失敗だけ `systemMessage` で伝える。
- **ポリシーファイルが無いリポジトリでは即 `exit 0`。** user global な hook なので
  aqua を使わないリポジトリでも毎回走る。
- **リポジトリ側が同等の hook を持つことを想定している。** チーム全員に効かせたい
  リポジトリは自前で登録する。1 つのファイルを共有することはできない（チームメイトの
  手元にこのディレクトリは無い）。allow は冪等なので、両方が走っても無駄な no-op が
  1 回増えるだけである。
- **色のエスケープを落とす。** aqua は色付きでログを出すため、そのまま
  `systemMessage` に載せると読ませたい場面で読めない。
- 依存: `aqua`。`jq` は失敗時のメッセージ整形にのみ使い、無ければ stderr に出す。

## 動作確認

```sh
CLAUDE_PROJECT_DIR=<aqua/aqua-policy.yaml を持つリポジトリ> \
  ~/.local/share/agents/scripts/aqua-policy-allow/bin/allow-project-policy
echo "exit=$?"
```

成功すれば無出力で `exit=0`。2 回続けて実行しても同じである（冪等）。許可されたかは
`ls "$HOME/.local/share/aquaproj-aqua/policies<絶対パス>"` で確認できる。

ポリシーファイルを持たないディレクトリを渡した場合も無出力で `exit=0` になる。
