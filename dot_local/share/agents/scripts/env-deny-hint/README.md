# env-deny-hint

`.env*` の読み取りは `permissions.deny`（`settings.base.pkl`）で常にブロックされている。
サンドボックス内では、拒否されたパスがエラーを出さずに `ls`/`find`/`stat` の出力から
そのまま消えることがあり、Claude が「削除された」と誤って結論づける原因になっていた。

`bin/executable_remind-env-deny` は PostToolUse hook（matcher: `Bash`）として動く。
実行された Bash コマンドに `.env` らしきパスが含まれていた場合のみ、`additionalContext`
として「`.env*` の欠落・不可視はポリシーによるブロックであり削除ではない。削除と断定
する前に `git log` や利用者への確認を行うこと」という注意を毎回注入する。

## 設計判断

- **実際の権限は変えない。** `.env*` は引き続き `Read`/Bash 経由で拒否される。この
  スクリプトは Claude の解釈だけを補正する。
- **常にリマインドする（対象コマンドかどうかだけで判定）。** 拒否時にサンドボックスが
  エラー文字列を返さず、対象パスをそのまま隠すケースがあるため、エラー文字列の有無で
  判定を絞ると検知漏れが起こる。ノイズより検知漏れを避ける方を優先している。
- 依存: `jq`。無ければ何もせず終了する（`exit 0`）。

## 動作確認

```sh
echo '{"tool_input":{"command":"cat .env.example"}}' | \
  ~/.local/share/agents/scripts/env-deny-hint/bin/remind-env-deny
```

`hookSpecificOutput.additionalContext` を含む JSON が出力されれば正常。`.env` を含まない
コマンドでは何も出力しない（終了コード 0）。
