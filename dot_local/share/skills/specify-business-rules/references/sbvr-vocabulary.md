# SBVR（語彙の表記と帰結の様相）

Last checked: 2026-08-06

SBVR（Semantics of Business Vocabulary and Business Rules）は OMG の標準で、業務語彙・業務事実・業務規則の意味を宣言的な自然言語で記述するための規定。**借用するのは2つ。語彙の表記規約と、帰結の様相の区別。** 前提と契機の構造は EARS が担当する（`references/ears-patterns.md`）。

## Source Summary

SBVR の核となる考えは次の一文に集約される。

> Rules build on facts, and facts build on concepts as expressed by terms.

規則は事実の上に乗り、事実は用語で表される概念の上に乗る。**この依存順序が、仕様を書く順序（語彙 → 規則）の根拠である。** 逆順に書くと、規則文の都合で用語が生えて同義語が増える。

### 4つの表記区分

SBVR Structured English は、形式的な意味を持つ要素を4つの書体で区別する。

| 区分 | 対象 | 書き方 |
| --- | --- | --- |
| **term** | 名詞概念（noun concept）の呼称 | 小文字・単数形。例: `business rule` |
| **Name** | 個体概念・固有名 | 適切に大文字化。数値もここ。例: `California` |
| **verb** | 動詞概念（verb concept）の語法 | 単数・能動・現在。例: `statement expresses proposition` |
| **keyword** | 文を組み立てる言語記号 | 例: `each`, `it is obligatory that` |

**書体で区別する意図は、規則文のどの語が定義済み概念かを見た目で判別可能にすること。** プレーンテキストではこれを角括弧で代替する（`[顧客]`）。代替である以上、囲む対象は term と Name に限り、様相語やキーワードは囲まない。

### 帰結の様相

SBVR は規則の様相を区別する。EARS の `shall` 一種類では表せない部分。

| 様相 | prefixed 形 | 日本語で固定する形 |
| --- | --- | --- |
| 義務 | It is obligatory that ... | 「〜しなければならない」 |
| 禁止 | It is prohibited that ... | 「〜してはならない」 |
| 許可 | It is permitted that ... | 「〜してよい」 |
| 必然 | It is necessary that ... | 「〜である」 |

記述の型は2つあり、意味は同じ。

- **prefixed（前置）**: "It is obligatory that each *rental* has at most three additional *drivers*."
- **embedded / mixfix（埋め込み）**: "A *rental* must have at most three additional *drivers*."

同様に "It is prohibited that *customer* exceeds *credit limit*." と "A *customer* must not exceed *credit limit*." は同じ規則を2つの記法で表したもの。

## 義務と必然の使い分け

ここを混ぜると規則の意味が変わる。

- **義務（しなければならない）** は破れる。破ったら違反であり、検出と対処の対象になる。業務規則の大半はこれ。
- **必然（である）** は破れない。定義上そうであるほかない事柄。「[申請] は 1つの [従業員] によって 提出された ものである」は必然で、システムがこれを「守る」ことはない。構造としてそうなっている。

必然を義務で書くと、存在しない違反への対処を実装しかねない。義務を必然で書くと、違反検出が仕様から落ちる。

**許可（してよい）は規則の数を増やす方向に働くので慎重に。** 明示的な許可が必要なのは、原則が禁止で例外的に許すときだけ。何も書かなければ許されている領域に許可規則を置くと、書かれていない行為が禁止されているように読める。

## 正例と反例

```
✅ 義務: [経費精算システム] は [申請] を [上長] の承認対象と しなければならない
✅ 禁止: [従業員] は 自身の [申請] を 承認 してはならない
✅ 許可: [経理部] は [上長] の承認を経ない [申請] を 承認 してよい
✅ 必然: [申請] は ちょうど1つの [従業員] に 紐づく ものである

❌ [経費精算システム] は [申請] を [上長] の承認対象と する
   → 様相がない。義務か必然か許可か決まらない。
❌ [従業員] は 自身の [申請] を 承認 できない
   → 「できない」は能力の記述で、禁止とも必然とも読める。禁止なら「してはならない」。
```

## 用語を作るときの規律

- **1概念1用語。** 同義語を作らない。「申請」と「経費申請」と「精算申請」が混在した時点で、規則が同じものを指しているか判定できなくなる。
- **用語は単数形・小文字（日本語では活用しない体言）で登録する。** 規則文の中で活用させない。
- **上位概念を必要になってから作る。** 「承認者」は上長と経理部の両方を指す必要が出た時点で作る。先に作ると使われない語彙が増える。
- **語彙で吸収できる変化を規則文に持ち込まない。** 承認者が増えるたびに規則文を直すのは、上位概念が欠けている合図。

## Practical Use

- 規則を書いていて用語に迷ったら、規則を書く手を止めて語彙に戻る。SBVR の依存順序に反した書き方をしている。
- 用語の定義は一文で書く。一文で書けないなら2概念が混ざっている。
- 角括弧が付いていない語が規則文にあるとき、それが概念なら語彙に登録する。第0段は「角括弧の中にあって語彙にない語」と「語彙にあって角括弧なしで使われた語」の両方を検出するが、**そもそも概念なのに一度も角括弧が付いていない語は検出できない。** そこはプローブB（語彙）が見る。

## Sources

- OMG, *Semantics of Business Vocabulary and Business Rules (SBVR)* v1.5 https://www.omg.org/spec/SBVR/1.5/PDF
- Ronald G. Ross "SBVR Speaks: (5) Notations for Business Rule Expression", *Business Rules Journal* https://www.brcommunity.com/articles.php?id=b286
- Ronald G. Ross "SBVR Speaks: (6) Concepts and Definitions in SBVR", *Business Rules Journal* https://www.brcommunity.com/articles.php?id=b288
- Semantics of Business Vocabulary and Business Rules（Wikipedia、位置づけの確認用）https://en.wikipedia.org/wiki/Semantics_of_Business_Vocabulary_and_Business_Rules

Revalidation trigger: SBVR のバージョンが上がり様相キーワードが変わったとき。日本語の様相固定形を変えたとき（スクリプトと同時に変える）。
