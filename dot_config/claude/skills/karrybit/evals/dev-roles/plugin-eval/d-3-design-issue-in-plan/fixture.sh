#!/bin/bash
set -eu
cp -R "$(dirname "$0")/../../fixtures/export-design-docs/." .
cat >> docs/design/export-job.md <<'EOF'
| U6 | 止める: Job の基盤の 1 run の実行時間の上限（15 分と聞いているが、基盤の文書では確かめていない）と、大きいテナントの 7 日分（約 300 万行）を 1 run で書き終えられるか。外れると、1 回の要求を 1 run で処理する J2・J4 の設計が変わる |
| U7 | 後で: dev の Job の基盤で、run-now から RUNNING になるまでの待ち時間（数秒と見込む。長くても画面の 5 秒ごとの読み取りで吸収できる） |

## 6. ダウンロードの URL

- Job は J4 のファイルを書いたあと、期限 24 時間の署名付き URL を作り、run の出力に載せる。API サーバーは、その URL をそのまま画面に返す。
EOF
git init -q
git add -A
git -c user.name=fixture -c user.email=fixture@example.invalid commit -qm fixture
