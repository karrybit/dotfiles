# SBVR（語彙の表記と帰結の様相）

Last checked: 2026-08-06

SBVR（Semantics of Business Vocabulary and Business Rules）は OMG の標準（v1.5、`formal/2019-10-02`）で、業務語彙・業務事実・業務規則の意味を宣言的な自然言語で記述するための規定。**借用するのは2つ。語彙の表記規約と、帰結の様相の区別。** 前提と契機の構造は EARS が担当する（`references/ears-patterns.md`）。

証拠の等級: **★** 規格本文を確認 / **▲** Ross の解説 / **○** 二次情報

## 依存順序

○ 「Rules build on facts, and facts build on concepts as expressed by terms.」——規則は事実の上に乗り、事実は用語で表される概念の上に乗る。**この依存順序が、仕様を書く順序（語彙 → 規則）の根拠である。**

**この一文は SBVR 規格の言明ではない。** 出典は Business Rules Manifesto（Business Rules Group, 2003）で、Ross は「Business Rules Mantra」と呼ぶ（別表記「Rules are based on facts, and facts build on concepts」）。SBVR 1.5 本文には現れない。依存順序という結論は SBVR の概念→事実型→規則の構成から支持されるが、**この引用を SBVR に帰属させてはいけない。**

## 4つの表記区分

▲ SBVR Structured English は、形式的な意味を持つ要素を4つの書体で区別する。

| 区分 | 対象 | 書き方 |
| --- | --- | --- |
| **term** | 名詞概念（noun concept）の呼称 | 小文字・単数形。例: `business rule` |
| **Name** | 個体概念・固有名 | 適切に大文字化。数値もここ。例: `California` |
| **verb** | 動詞概念（verb concept）の語法 | 単数・能動形。例: `statement expresses proposition` |
| **keyword** | 文を組み立てる言語記号 | 例: `each`, `it is obligatory that` |

★ **SBVR Structured English は非規範である**（Annex A は "(informative)"）。▲ Ross も「as a notation, it is non-normative in the SBVR standard」「just one of possibly many notations」とする。**だから角括弧による代替が許される。** 書体で区別する意図は「規則文のどの語が定義済み概念か」を見た目で判別可能にすることなので、書体の代わりに区切り記号を使う。

▲ 語彙エントリの primary representation は **designation（term / Name）または verb concept wording** である。つまり動詞概念語法も語彙エントリなので、囲む対象を term と Name だけに限ると概念が印付けから漏れる。

★ 登録形は単数・能動で固定するが、**使用時の活用は許される。**

> Terms are defined in singular form. **Plural forms are implicitly available for use.**
> Infinitive, subjunctive, passive, and plural forms of verbs are **implicitly available for use** in statements and definitions.

登録を固定形にする（前半）とだけ書き、規則文の中で活用させないとは書かないこと。

★ 量化子や論理演算子を呼称・語法に埋め込まないことが推奨される（A.4.1）。

## 帰結の様相は2系列×3

★ ここが最重要。様相は **Behavioral（行動的）** と **Definitional（定義的）** の2系列で、各3つ。EARS の `shall` 一種類では表せない部分。

|  | prefixed | embedded | 日本語で固定する形 |
| --- | --- | --- | --- |
| **行動的・義務** | It is obligatory that | must | 「〜しなければならない」 |
| **行動的・禁止** | It is prohibited that | must not | 「〜してはならない」 |
| **行動的・許可** | It is permitted that | may | 「〜してよい」 |
| **定義的・必然** | It is necessary that | always | 「〜である」 |
| **定義的・不可能** | It is impossible that | never | 「〜ことはない」 |
| **定義的・可能** | It is possible that | sometimes | 「〜しうる」 |

★ 規格の例（逐語）:

> It is impossible that the same rental car is owned by more than one branch.
> The same rental car is **never** owned by more than one branch.

▲ prefixed と embedded は同じ規則の2記法で意味は同じ。「It is obligatory that each *rental* has at most three additional *drivers*.」と「A *rental* must have at most three additional *drivers*.」は同一。

★ **系列内では書き換え等価。** 「One behavioral business rule can be expressed as various equivalent kinds of statements by introducing or removing negation.」義務・禁止・制限付き許可は否定の出し入れで相互変換でき、意味は変わらない。定義的系列（必然・不可能・制限付き可能）も同様。

**意味が変わるのは系列をまたぐときだけ。**

## 系列の使い分け

- **行動的（義務・禁止・許可）は破れる。** 破ったら違反であり、検出と対処の対象になりうる。
- **定義的（必然・不可能・可能）は破れない。** 定義上そうであるほかない事柄。「[申請] は ちょうど1つの [従業員] に 紐づく ものである」は必然で、システムがこれを「守る」ことはない。

必然を義務で書くと、存在しない違反への対処を実装しかねない。義務を必然で書くと、違反検出が仕様から落ちる。

★ ただし**義務なら必ず強制される、ではない。** 規格は enforcement level を6段階持つ（strict / deferred / pre-authorized override / post-justified override / override with explanation / **guideline（suggested, but not enforced）**）。義務でも guideline 水準なら強制されない。強制水準を書き分ける必要があるなら、規則の属性として別に持つ。

## 無制限の許可・可能は規則ではない

★ これは見落としやすい。

> Necessity: **No business rule is an advice.**

`advice` は「ある状態が許される／ありうることを表す element of guidance」。**無制限の許可はこれにあたり、業務規則ではない。** 規則になるのは条件付きの形だけである。

★ 規格の定義（逐語）:

> **restricted permission statement**: … worded as the state of affairs being permitted **only if** a given condition is met
> **restricted possibility statement**: … worded as the state of affairs being possible **only if** a given condition is met
> Example: It is possible that a rental is an open rental **only if** the rental car of the rental has been picked up.

★ また「Every behavioral business rule implies an advice of permission」——義務からは許可が自動的に導かれる。**だから許されていることをわざわざ書く必要はない。**

この仕様形式では、条件は EARS のキーワードで表れる。したがって**キーワードを1つも持たない（＝常時の）許可・可能は規則になっていない**。第0段がこれを検出する（E218）。

## 用語を作るときの規律

- ★ **1概念に primary representation を1つ。ただし同義語は禁止せず登録する。** 規格は `Synonym`（名詞概念の別呼称）、`Synonymous Form`（動詞概念の別語法）、`See`（非推奨呼称から推奨呼称への参照）を備える。**「同義語を作らない」は誤り**で、正しい運用は「代表語を1つ決め、残りを同義語として登録する」。
  - 進行中案件のレビューではこれが実務的に重要。「申請／経費申請／精算申請」が既に散在しているとき、全部改名させるのは非現実的である。**代表語を決め、残りを同義語として登録すれば、原文を書き換えずに統制できる。**
- ★ **定義は文ではない。** 「A definition is shown as an expression that can be logically substituted for the primary representation. **It is not a sentence, so it does not end in a period.**」置換可能な句を書く。例: `corporate rental agreement` → "contract that establishes a negotiated set of rates under which a qualified corporate renter can rent a car"。**「一文で書く」は形式が逆。** 1概念に絞るという狙いは、句で書いても達成できる。
- **上位概念は必要になってから作る。** 「承認者」は上長と経理部の両方を指す必要が出た時点で作る。
- **語彙で吸収できる変化を規則文に持ち込まない。** 承認者が増えるたびに規則文を直すのは、上位概念が欠けている兆候。

## 正例と反例

```
✅ 義務:   [経費精算システム] は [申請] を [上長] の承認対象と しなければならない
✅ 禁止:   [従業員] は 自身の [申請] を 承認 してはならない
✅ 必然:   [申請] は ちょうど1つの [従業員] に 紐づく ものである
✅ 不可能: [申請] が 2つの [経理部] に 同時に割り当てられる ことはない
✅ 許可:   [申請] が [出張] に 紐づく 間、[経理部] は [上長] の承認を経ずに
           [申請] を 承認 してよい      ← 条件付きなので規則

❌ [経費精算システム] は [申請] を [上長] の承認対象と する
   → 様相がない。義務か必然か許可か決まらない。
❌ [従業員] は 自身の [申請] を 承認 できない
   → 「できない」は禁止・必然・不可能の3つに読める。破れるなら禁止「してはならない」、
      定義上ありえないなら不可能「ことはない」。
❌ [経理部] は [申請] を 承認 してよい
   → 無制限の許可。SBVR では規則ではなく advice。条件を付けるか、規則から外す。
```

## Practical Use

- 規則を書いていて用語に迷ったら、手を止めて語彙に戻る。依存順序に反した書き方をしている。
- **「破ったらどうなりますか」が系列を分ける最短の問い。** 「何も起きない、破れない」なら定義的、「違反として検出し対処する」なら行動的。
- 系列内の書き換え（義務↔禁止）で迷う必要はない。読みやすいほうを選ぶ。**系列をまたぐ取り違えだけを警戒する。**
- 角括弧が付いていない語が規則文にあるとき、それが概念（名詞概念・個体概念・**動詞概念語法**）なら語彙に登録する。第0段は「角括弧の中にあって語彙にない語」と「語彙にあって角括弧なしで使われた語」を検出するが、**一度も角括弧が付いていない概念は検出できない。** そこはプローブB（語彙）が見る。

## Sources

- ★ OMG, *Semantics of Business Vocabulary and Business Rules (SBVR)* v1.5, `formal/2019-10-02`, October 2019 https://www.omg.org/spec/SBVR/1.5/PDF — 本文を直接抽出して確認（16.1.2 / 17.2.1 / 18.1.3 / 18.2.1 / Annex A）
- ▲ Ronald G. Ross "SBVR Speaks: (5) Notations for Business Rule Expression" https://www.brcommunity.com/articles.php?id=b286
- ▲ Ronald G. Ross "SBVR Speaks: (6) Concepts and Definitions in SBVR" https://www.brcommunity.com/articles.php?id=b288
- ○ 依存順序の引用元: Business Rules Manifesto https://www.businessrulesgroup.org/brmanifesto.htm （SBVR ではない）

Revalidation trigger: SBVR のバージョンが上がり様相キーワードか enforcement level が変わったとき。日本語の様相固定形を変えたとき（`scripts/check-spec.py` の `MODALITY_SERIES` と同時に変える）。同義語登録を実運用で1回行い、代表語の決め方が足りたか確認したとき。
