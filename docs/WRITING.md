# 文書作成の Skill 運用

技術文書を書く、直す、レビューするときに、どの Skill を使うかを定める。対象は次の三つである。

| Skill | 担当 | 起動 | 置き場所 |
| --- | --- | --- | --- |
| `docs-information-design` | 文書に何を書き、どこに置くか。文書の分割、統合、文書間の整合 | 自動 | `dot_config/claude/skills/` |
| `japanese-tech-writing` | 日本語の文章の論理構成と文章品質 | 自動 | `dot_config/claude/skills/`（原典からの派生。`PROVENANCE.md` 参照） |
| `yomiyasu:yomiyasu` | 書き上がった日本語の独立した推敲 | 名前を出した依頼だけ | プラグイン（`settings.base.pkl` の `enabledPlugins`） |

## 設計原則

- 起動条件の正本は各 Skill の `description` である。この文書は対応関係と理由を記録するもので、Claude Code は実行時に読まない。`description` を変えたら、下の対応表と動作確認のケースを合わせて直す。
- Skill を選ぶことと、文書を書き換えてよいことは別である。書き換えてよいかは、依頼から決まる作業モードで判断する（ユーザー指示 `dot_config/claude/CLAUDE.md` の Scope Control）。
- 必要な Skill だけを使う。内容と構成が決まっている執筆に情報設計を足さず、通常の執筆に独立した推敲工程を足さない。
- 同じ文章を `japanese-tech-writing` と `yomiyasu` で重ねて直さない。両者の規範は細部で食い違う。

## 場面

| 場面 | 例 |
| --- | --- |
| S1 内容と構成が決まった文書を書く | 項目を指定した README の節、決定と理由を指定した ADR |
| S2 内容か構成が決まっていない | 何を書くか決まっていない設計書、まとまらない草稿、資料やコードから起こす文書 |
| S3 局所修正 | 一節への追記、レビュー指摘への対応、誤字や表記の修正 |
| S4 既存文書の更新 | コード変更への追随、最新化、読者や目的の変更 |
| S5 文書群の整理 | 文書間の整合確認、統合、分割、移動、廃止 |
| S6 レビュー | 全体または特定観点。自分の文書か他人の文書かは問わない |
| S7 明示的な日本語推敲 | yomiyasu を名指しした AI 臭さの除去 |

## 作業モード

モードは依頼の動詞で決まり、場面とは独立している。曖昧なときは書き換えないモードを選ぶ。

| モード | 行為 | 書き換え | `docs-information-design` の対応 |
| --- | --- | --- | --- |
| 相談 | 問題、読者、目的を一緒に確定する | しない | 1. Fix the frame |
| 提案 | 構成や変更方針を示す | しない | plan |
| 執筆・編集 | 文章を書く、書き換える | する | apply |
| 評価 | 問題点を指摘する | しない | audit |
| 検証 | 事実と文書間の整合を確かめる | しない | 4. Ground every fact、6. Check the result |

## 場面と Skill の対応

| 場面 | 主に使う | 併用 | 使わない Skill | 書き換え |
| --- | --- | --- | --- | --- |
| S1 | `japanese-tech-writing`（日本語のとき） | なし | `docs-information-design`：内容と構成が確定済み | 可 |
| S2 | `docs-information-design` | 日本語の本文を書く段階で `japanese-tech-writing` | `yomiyasu` | 相談か提案から始め、合意後に執筆 |
| S3 | なし（文を書き直すなら `japanese-tech-writing`） | なし | `docs-information-design`：範囲外の構造の問題は指摘だけする | 可（依頼の範囲内） |
| S4 | `docs-information-design` | `japanese-tech-writing` | `yomiyasu` | 可。大きな組み替えは提案を先に出す |
| S5 | `docs-information-design` | 書き直しを伴うときだけ `japanese-tech-writing` | `yomiyasu` | 提案を先に出す |
| S6 | 構成と情報の観点は `docs-information-design`、論理と文章の観点は `japanese-tech-writing`。全体レビューは両方 | なし | `yomiyasu`：書き換える Skill である | 不可 |
| S7 | `yomiyasu:yomiyasu` | なし | 他の二つ：同じ文章を重ねて直さない | `yomiyasu` の手順に従う |

ADR と PR 本文では、プラグインの `mattpocock-skills:domain-modeling`（ADR の書式と要否）と `mattpocock-skills:pr`（PR 本文）も起動しうる。これらは書式と要否を受け持ち、上の表の Skill と競合しない。

## 動作確認

各 Skill の起動と非起動を、次のケースで確かめる。○は起動する、×は起動しない、△はどちらでもよい。

| # | 依頼 | `docs-information-design` | `japanese-tech-writing` | `yomiyasu` | 期待する振る舞い |
| --- | --- | --- | --- | --- | --- |
| 1 | 3 項目を指定して README に「開発環境」節を足す | × | ○ | × | 書き換える |
| 2 | 設計書を書きたいが何を書くか決まっていない | ○ | △ | × | 書き換える前に相談か提案 |
| 3 | 設計書の一節を読みやすく書き直す | × | ○ | × | 書き換える |
| 4 | README の誤字を 1 か所直す | × | × | × | 書き換える |
| 5 | Issue 本文の論理構成をレビューする | △ | ○ | × | 書き換えない |
| 6 | 決定、理由、却下案を指定して ADR を書く | × | ○ | × | 書き換える |
| 7 | README の構成を変える | ○ | △ | × | 提案を先に出す |
| 8 | 少数の文書の整合を確かめる | △ | × | × | 書き換えない |
| 9 | yomiyasu で文章の AI 臭さを取る | × | × | ○ | `yomiyasu` の手順に従う |
| 10 | 通常のコード修正 | × | × | × | 文書を作らない |
| 11 | yomiyasu を名指しせずに、AI っぽくない自然な日本語にする | × | ○ | × | 書き換える |

確かめ方：

- 各ケースを fixture リポジトリの複製で `claude -p "<依頼>" --output-format stream-json --verbose --disallowedTools Edit,Write` として複数回実行し、出力の `Skill` ツール呼び出しを `jq` で数える。名前で呼ぶ Skill の起動は Skill ツール呼び出しとして現れる。
- 計測の前に、起動が分かっている依頼と起動しないはずの依頼を一つずつ流し、この方法で両者を区別できることを確かめる。
- 普段使うモデル（`settings.base.pkl` の `ANTHROPIC_MODEL`）で測る。起動はモデルによって変わる。
- `docs-information-design` の `description` は、`evals/trigger-evals.json` と skill-creator の `run_eval` でも確かめる（手順は `evals/README.md`）。
- 運用中は `/skill-doctor` で各 Skill の起動頻度を確認する。
