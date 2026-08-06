# Catala 式 default logic（原則と例外）

Last checked: 2026-08-06

Catala は法令をそのまま実行可能な形にするために作られた DSL（Merigoux, Chataing, Protzenko, ICFP 2021）。**借用するのは言語ではなく、原則と例外の表し方だけ。** ここでは自然言語の仕様に対して、Catala の構造と失敗モードを設計規律として使う。

## Source Summary

Catala の中核は **prioritized default logic**（優先度付きデフォルト論理）で、これを核に据えた最初のプログラミング言語とされる。狙いは、法令に遍在する「一般規定と例外」の論理を素直に書けるようにすること。

各変数は**1つの base case と、それに対する例外の木**として定義される。例外は入れ子にできる（「例外の例外」）。

```catala
scope IncomeTaxComputation:
  label article_2 definition tax_rate equals 20%
```

```catala
scope IncomeTaxComputation:
  label article_3 exception article_2
  definition tax_rate
  under condition individual.number_of_children >= 2
  consequence equals 15%
```

`exception <label>` が優先を宣言する。両方の条件が成立するとき、例外が勝つ。

**例外を書くには参照先にラベルが必要。** これが「名前付き業務規則」の必要性そのものである。名前のない規則は例外の対象になれない。

### 2つの失敗モード

Catala が検出する誤りは2種類しかなく、これがそのまま仕様レビューで探すべき欠陥の定義になる。

| Catala のエラー | 意味 | 仕様側での現れ方 |
| --- | --- | --- |
| `conflict between multiple valid consequences for assigning the same variable` | 複数の例外が同時に成立し、優先が決まっていない | ある入力で帰結が2つ以上ある |
| `no definitions apply` | どの条件も成立せず、base case もない | ある入力で帰結が1つもない |

木の**別の階層**にある定義は衝突しない。優先が木で決まっているため。衝突するのは**同じ親を持つ兄弟**だけで、兄弟は条件が互いに排他か、一方が他方の例外になっているかのどちらかでなければならない。

もう一つ重要な性質として、Catala は法令の条文とコードを隣に並べる literate programming の形をとる。条文とコードが対応していることを目で追える。

## 自然言語仕様への写し方

| Catala | この仕様形式 |
| --- | --- |
| `label` | 規則 ID（`BR-<AREA>-<NNN>`） |
| `definition ... equals` | 規則文の帰結 |
| `under condition` | EARS の前提・契機 |
| `exception <label>` | `例外元: BR-...` |
| base case | `例外元: なし` |
| 条文とコードの並置 | 出典（規程・法令）の条番号を規則に併記 |

## 正例と反例

**兄弟の衝突（いちばん多い欠陥）**

```markdown
❌ ### BR-EXP-020 少額申請の自動承認
   - 例外元: BR-EXP-010
   - 規則: [申請金額] が 10,000円 以下 である間、... 自動承認 しなければならない

   ### BR-EXP-030 出張申請の経理承認
   - 例外元: BR-EXP-010          ← 020 と兄弟
   - 規則: [申請] が [出張] に 紐づく 間、... [経理部] の承認対象と しなければならない
```

8,000円の出張申請で 020 と 030 の両方が成立し、どちらが勝つか決まらない。`conflict` に相当する。

```markdown
✅ ### BR-EXP-030 出張申請の経理承認
   - 例外元: BR-EXP-020          ← 020 の例外に変える
```

木にすることで「出張なら少額でも経理が見る」という業務判断が明示される。

```
BR-EXP-010 上長承認（原則）
└── BR-EXP-020 少額なら自動承認
    └── BR-EXP-030 ただし出張なら経理承認
```

**base case の欠落**

```markdown
❌ 条件付きの規則しかなく、どれにも当たらない入力がある
   → `no definitions apply` に相当。原則（例外元: なし）を必ず1つ置く。
```

**「原則として」で例外を隠す**

```markdown
❌ - 規則: [経費精算システム] は 原則として [申請] を [上長] の承認対象と しなければならない
```

「原則として」は例外の存在を示しながら、その例外を書いていない。例外を別の規則として書き、`例外元` で結ぶ。第0段のスクリプトがこの語を検出する。**これは表現の好みではなく、構造の欠落を語彙が漏らしている状態。**

## 木の設計判断

- **木の形は業務判断であり、機械的に決まらない。** 020 の例外にするか 010 の兄弟にして条件を狭めるかは、「出張なら金額を問わず経理が見るのか」という業務の問いに答えて決まる。決まらないなら `未決定` に立てる。
- **深さ2を超えたら止まって考える。** 3段以上の例外は読めなくなる。決定表そのものを正本にするほうが良いことがある。
- **例外の条件は親の条件を否定しない。** 「金額が1万円超のとき」を 020 の例外に書くのは誤り。それは 020 が成立しない領域なので、010 が担当する。例外は**親が成立する範囲の中**を狭める。
- **ID を再利用しない。** 例外は ID を参照するため、削除した ID を再利用すると過去の参照が別の規則を指す。

## Practical Use

- 例外を足すときは、必ず既存のどの規則の例外かを言う。「なし」にしたくなったら、それは新しい原則であり、既存の原則と領域が重なっていないかを確認する。
- 兄弟が2つ以上できたら、条件が排他であることをその場で確かめる。排他でないなら片方を他方の例外にする。第0段では検出できない。
- 実行可能にしたいなら、ここで止めて本物の Catala かルールエンジンへ渡す。**この仕様形式はコンパイラではない。** 自然言語のまま構造を守ることが目的。

## Sources

- Denis Merigoux, Nicolas Chataing, Jonathan Protzenko "Catala: A Programming Language for the Law", *Proc. ACM Program. Lang.* 5(ICFP), 77:1-29, 2021 https://dl.acm.org/doi/10.1145/3473582 / preprint https://arxiv.org/pdf/2103.03198
- Catala 公式ドキュメント「Conditional definitions and exceptions」https://book.catala-lang.org/en/2-2-conditionals-exceptions.html
- Catala 公式ドキュメント「Definitions and exceptions」（例外の木の意味論）https://book.catala-lang.org/en/5-4-definitions-exceptions.html

Revalidation trigger: Catala のエラー名称・例外構文が変わったとき（失敗モードの2分類は言語仕様に依存する）。例外の深さの実運用上の上限を実測で決めたとき。
