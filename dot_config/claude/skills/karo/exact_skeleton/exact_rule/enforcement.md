# 規則と強制するもの

オーナーに正されたときと、`karo:insights` で直しの候補を挙げるときに読む。

## 直し方

- オーナーに正されたら、その失敗を直し、関わる規則が下のどの表にもなければ「強制するものがない規則」の表に行を足す。
- 正された規則が表にあり、強制するものが「なし」なら、くり返しとして扱い、同じ変更で強い層に上げる。
- 正された規則が「仕組みで塞がないと決めた規則」の表にあれば、その行を「強制するものがない規則」の表に戻す（次の `karo:insights` が直しの候補にする）。
- 仕組みで塞いだら、行を「強制するものがある規則」の表に移し、強制するものを書く。
- 検討したうえで仕組みで塞がないと決めたら、行を「仕組みで塞がないと決めた規則」の表に移し、理由と出典を書く。
- 層は強い順に、道を 1 つにする（記録は commit の script だけが commit する、など）、karo の `scripts/commit` か `scripts/karo-check` の検査、hook、テスト、文書にする。上の層で塞げないときだけ下の層にする。
- 新しい検査を足すときは、記録にある実際の過去の失敗を入力にして、変更の前の版で落ちることを karo の `*-test` で示す。
- 検査の NG の文には、何をどう直すか（使う項目、列の名前、コマンド）を書く。
- 失敗が起きなくなった規則は、表から外す。

## 強制するものがある規則

| 規則（書いてある場所） | 強制するもの |
| --- | --- |
| herdr は単独で呼ぶ（AGENTS.md「sandbox」） | karo の `scripts/call-check`（hook） |
| karo の scripts は `~` の形で呼ぶ（AGENTS.md「sandbox」） | karo の `scripts/call-check`（hook。`karo:herdr-agent` の scripts を含む） |
| karo の rebase は `karo:land` skill で行い、sandbox の外でやり直さない（AGENTS.md「sandbox」） | karo の `scripts/call-check`（hook。sandbox の外の `git rebase` を止める。`--abort` は通す）、`karo:land` の `scripts/land` |
| 記録は「書き込み先」の表のファイルにだけ書く（AGENTS.md「書き込み先」） | karo の `scripts/commit`（commit するパスの確かめ） |
| 新しい記録のノートにフロントマターを付ける（`karo:record` skill の `frontmatter.md`） | karo の `scripts/karo-check`（`post-edit` の hook が書いたノートに、`scripts/commit` が commit に入る中身に、`--only` で呼ぶ） |
| ID の形（AGENTS.md「書式」） | karo の `scripts/karo-check`（フロントマターの `tasks` の ID の形） |
| 取り込まれていない commit や ignored なファイルが残る worktree は閉じない（`karo:delegate`「Agent を終了する」） | `karo:herdr-agent` の `agent-ctl close` |
| Agent の承認ダイアログに送るキーは Enter と q だけ（`rule/herdr-keys.md`） | `blocked` の Agent は `karo:herdr-agent` の `safe-key`、`idle` の Agent は `.claude/settings.json` の `permissions.ask` にある `herdr agent send-keys`（オーナーの確認） |

## 強制するものがない規則（くり返したもの）

`karo:insights` が、ここにある規則の違反を直しの候補にする。

| 規則（書いてある場所） | いまあるもの |
| --- | --- |

## 仕組みで塞がないと決めた規則

`karo:insights` は、ここにある規則の違反を直しの候補にしない。

| 規則（書いてある場所） | いまあるもの | 塞がない理由（出典） |
| --- | --- | --- |
