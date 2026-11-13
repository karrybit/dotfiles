# chrome-devtools-url-guard

chrome-devtools MCP サーバー（`dot_config/claude/modify_private_dot_claude.json` が
user scope に宣言する）は、ローカルで作った HTML の表示・console・アクセシビリティの
snapshot を確かめるためだけに使う。

`bin/executable_check-url` は PreToolUse hook（matcher:
`mcp__chrome-devtools__(new_page|navigate_page|navigate)`）として動き、次のどれでもない
URL を開く呼び出しを exit 2 で止める。

- `http://localhost`（ポートは任意）
- `http://127.0.0.1`（ポートは任意）
- `file://`

`url` を持たない呼び出し（`navigate_page` の back・forward・reload）は通す。

## 使い方の注意

- 開くのはローカルの開発サーバーとローカルのファイルだけにする。ログインが要るサイト、
  SaaS、クラウドのコンソールは、利用者が自分のブラウザで確かめる。
- スクリーンショットとページの中身（snapshot、console、`evaluate_script` の結果）は
  モデルに送られる。秘密やトークンを表示するページは、値をダミーに置き換えてから
  確かめる。
- ネットワークの中身を読む道具は、サーバーの引数 `--no-category-network` で外してある。

## 設計判断

- **サーバー側の引数で一時プロファイルと headless に固定する。** `--isolated` と
  `--headless` で、既存のプロファイルやタブを持つ Chrome に触れない。既存の Chrome
  につなぐ `--autoConnect`・`--browserUrl`・`--wsEndpoint` は使わない。
- **外への通信は、待ち受けのないポートを指す `--proxyServer=127.0.0.1:9` で止める。**
  ページが読み込む外部のスクリプトやフォントも失敗し、Chrome が既定で proxy を通さない
  loopback（`localhost`・`127.0.0.1`）と `file://` だけが開ける。
- **`evaluate_script` は止めない。** JavaScript からのページ移動（`location.href` など）
  は hook では見えないが、ブラウザは一時プロファイルで認証情報を持たず、開く起点は
  ローカルのページだけなので、止める仕組みを足す負荷に見合わない。
- **サーバーの `--allowedUrlPattern` は重ねない。** 外への通信は proxy で止まっている。
  この引数は Chrome 149 以上が要り、URL Pattern の書き方（ポートを省くと既定のポート
  だけに一致するなど）に癖があり、動きを確かめていない。
- **jq が無ければ止める。** URL を確かめられないまま通さない。

## 動作確認

```sh
guard=~/.local/share/agents/scripts/chrome-devtools-url-guard/bin/check-url
echo '{"tool_input":{"url":"http://localhost:8000/"}}' | "$guard"; echo $?
echo '{"tool_input":{"url":"https://www.google.com/"}}' | "$guard"; echo $?
```

1 つ目は 0、2 つ目は理由を stderr に出して 2 で終われば正常。
