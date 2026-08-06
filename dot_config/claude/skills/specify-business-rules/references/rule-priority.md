# 規則間の優先関係（DMN / Catala）

Last checked: 2026-08-06

**規則が重なったときどちらが勝つか**だけを規定する。語彙は ORM/SBVR、前提と契機は EARS が担当する。

主たる出典は **DMN**（Decision Model and Notation、OMG 標準）。業務上の意思決定を対象とし、決定表の欠陥を標準概念として定義している。**Catala** は木構造の優先関係についてのみ従として使う。

証拠の等級: **★** 原典本文を確認 / **▲** 実装者・専門家の解説 / **○** 二次情報

## 問題は既存文献が要求している

★ この軸が埋めるのは**機構**であって、問題意識ではない。Business Rules Manifesto（Business Rules Group, 2003）が逐語で要求している。

> **4.7** Exceptions to rules are expressed by other rules.
> **5.2** Business rules should be expressed in such a way that they can be **verified against each other for consistency**.

本形式は 4.7 を満たし（各例外が独立した規則レコードで、`例外元` が親を指す）、5.2 を機械化する（決定表で gap と overlap を出す）。**Manifesto は一貫性の検証を要求するが、検証の仕方を与えていない。** DMN の hit policy と例外の木がその「どうやるか」にあたる。

## なぜ DMN が主か

プローブAが作る成果物は**決定表**である。DMN は決定表の標準そのもので、探すべき欠陥を名前付きで定義している。プログラミング言語のコンパイラのエラーから欠陥を導くのは、同じ場所への遠回りだった。

- ★ DMN は OMG の仕様。現行は 1.7 beta（2024-09）。**本 reference が本文で確認したのは v1.3。**対象は business analysts / designers / developers / business owners。「The notation shows the dependencies between a set of related decisions, and on the business knowledge and input data required to make them. It is simple enough to be readily understandable by all business stakeholders.」決定表を含み、XML で組織間交換できる。
- **業務システムの意思決定が対象領域である。** Catala は法令（statutory law）のための言語で、領域が違う。

## 3つの欠陥クラス

**これがプローブAが探すもの。**

| 欠陥 | 呼び方 | 決定表での現れ方 | 等級 | 直し方 |
| --- | --- | --- | --- | --- |
| 隙間 | gap | 帰結が **0個** の行 | ★ | 原則（`例外元: なし`）を置くか条件を広げる |
| 重複 | overlap | 帰結が **2個以上** の行 | ★ | 片方を他方の例外にするか条件を排他にする |
| 冗長 | subsumption | 1つにまとめられる規則が複数 | ▲ | まとめる（fully contracted） |

★ **overlap は仕様が形式的に定義している。**

> If two input entries of the same input expression share no values, the entries (cells) are called **disjoint**. If there is an intersection, the entries are called **overlapping** (or even equal). 'Irrelevant' ('-') overlaps with any input entry of the input expression. **Two rules are overlapping if all corresponding input entries are overlapping.**

★ **hit policy は重複時の解決を定め、`Unique` が既定かつ規範である。** ここは実装者解説より仕様のほうが強い。

> The hit policy **SHALL default to Unique**, in which case the hit indicator is optional. Decision tables with the Unique hit policy **SHALL NOT contain overlapping rules**.

7種は `Unique / Any / Priority / First / Collect / Output order / Rule order`。**`Unique` が既定で「重複を含んではならない」と規定されている**ことが、本形式の「兄弟は条件が排他でなければならない」規律の根拠になる（best practice という以上に規範である）。

★ **gap の扱いは「エラー」ではなく「null」。** 仕様は完全性を要求しない。

> In that case, **no rule matches** and MinCreditScore returns the value **null**. Downstream logic referencing this variable must account for the possibility of null value.

つまり DMN では隙間は実行時に null として現れ、下流がそれを扱う責任を負う。**自然言語仕様の段では「帰結が決まらない」ことそのものが指摘である**——実装に null を流して黙って通すのを避けるために、ここで潰す。

▲ **subsumption は仕様の語ではない。** DMN 仕様本文に該当語は現れず、実務家の解説（Bruce Silver）に由来する。「複数の規則が1つにまとめられる」状態を指し、**fully contracted table** が best practice とされる。**gap / overlap と同格に扱わない**（プローブAでも優先度を下げてある）。

### 規則の順序に意味を持たせない

▲ `F`（First）は「決定表の論理は宣言的で、規則の順序に依存しないべき」という原則に反するため semi-deprecated とされる。

**本形式が `例外元` による明示的な親参照を使い、ファイル内の記述順に依存しないのはこの原則に沿っている。** 順序で優先を表すと、規則を並べ替えただけで意味が変わる。

## なぜ平坦な優先順位ではなく木か（Catala）

DMN の `P` は**出力値の平坦な順序リスト**で優先を表す。本形式は `例外元` で1規則1親を指すので**木**である。木を採る根拠が Catala にある。

- ★ 「Under the hood, Catala uses prioritized default logic; to the best of our knowledge, Catala is the first instance of a programming language designed with this logic as its core system.」（Merigoux, Chataing, Protzenko, ICFP 2021）
- ★ 「the one closest to the purposes of the law is known as prioritized default logic, wherein default values are guarded by justifications, and **defaults can be ordered according to their relative precedence**.」——優先は値の列ではなく**デフォルト間の相対的な順序**として与えられる。
- ★ 2つの例外が同時に成立したときの挙動は、実装上「If two non-⊥ exceptions are found, the automaton detects an invalid transition and aborts」。**重複は実行前に落とす**という設計。
- 例外は入れ子にできる（例外の例外）。**例外を書くには参照先に名前が必要**であり、これが「命名が装飾ではない」根拠である。名前のない規則は例外の対象になれない。

平坦な優先順位でも上の衝突例は解けるが、木は「**この規則はあの規則があるから存在する**」という業務判断を構造として残す。出力値の順序にはその情報が入らない。

**注意**: 以前この reference は Catala のエラー文字列を逐語の引用として載せていた。原典（ICFP 2021 論文）に該当語は現れず、要約器経由の記述だった。**欠陥の名前は DMN の標準用語（gap / overlap / subsumption）を使い、Catala は意味論の根拠としてのみ引く。**

## この形式での対応

| 概念 | 本形式 |
| --- | --- |
| 決定表の1行 | プローブAが作る表の1行 |
| gap | 帰結が0個 |
| overlap | 帰結が2個以上 |
| hit policy `U` | 兄弟の条件は排他 |
| デフォルトの相対順序 | `例外元: BR-...` |
| 原則（base case） | `例外元: なし` |
| 規則のラベル | 規則 ID |

## 正例と反例

**兄弟の重複（いちばん多い欠陥）**

```markdown
❌ ### BR-EXP-020 少額申請の自動承認
   - 例外元: BR-EXP-010
   - 規則: [申請金額] が 10,000円 以下 である間、... 自動承認 しなければならない

   ### BR-EXP-030 出張申請の経理承認
   - 例外元: BR-EXP-010          ← 020 と兄弟
   - 規則: [申請] が [出張] に 紐づく 間、... [経理部] の承認対象と しなければならない
```

8,000円の出張申請で 020 と 030 の両方が成立し、どちらが勝つか決まらない。**overlap** である。

```markdown
✅ ### BR-EXP-030 出張申請の経理承認
   - 例外元: BR-EXP-020          ← 020 の例外に変える
```

```
BR-EXP-010 上長承認（原則）
└── BR-EXP-020 少額なら自動承認
    └── BR-EXP-030 ただし出張なら経理承認
```

**原則の欠落**

```markdown
❌ 条件付きの規則しかなく、どれにも当たらない入力がある
   → gap。原則（例外元: なし）を必ず1つ置く。
```

**「原則として」で例外を隠す**

```markdown
❌ - 規則: [経費精算システム] は 原則として [申請] を [上長] の承認対象と しなければならない
```

例外の存在を示しながら、その例外を書いていない。例外を別の規則として書き `例外元` で結ぶ。第0段のスクリプトがこの語を検出する。**表現の好みではなく、構造の欠落が語彙に漏れている状態。**

## 木の設計判断

- **木の形は業務判断であり、機械的に決まらない。** 020 の例外にするか、010 の兄弟にして条件を狭めるかは、「出張なら金額を問わず経理が見るのか」という問いに答えて決まる。決まらないなら `未決定` に立てる。
- **深さ2を超えたら止まって考える。** 3段以上の例外は読めない。決定表そのものを正本にするほうが良いことがある。
- **例外の条件は親の条件を否定しない。** 「金額が1万円超のとき」を 020 の例外に書くのは誤り。それは 020 が成立しない領域なので 010 が担当する。例外は**親が成立する範囲の中**を狭める。
- **ID を再利用しない。** 例外は ID を参照するため、削除した ID を再利用すると過去の参照が別の規則を指す。

## Practical Use

- 例外を足すときは、必ず既存のどの規則の例外かを言う。「なし」にしたくなったら、それは新しい原則であり、既存の原則と領域が重なっていないか確認する。
- 兄弟が2つ以上できたら、条件が排他であることをその場で確かめる。第0段では検出できない。
- **subsumption は最後に見る。** gap と overlap を潰してから、まとめられる規則がないかを見る。順序を逆にすると、まとめた規則をまた分けることになる。
- 実行可能にしたいなら、ここで止めて DMN 実装（ルールエンジン）か Catala へ渡す。**この仕様形式はコンパイラではない。** 自然言語のまま構造を守ることが目的。

## Sources

- ★ OMG, *Decision Model and Notation (DMN)* 仕様本文 https://www.omg.org/spec/DMN/1.3/PDF — **v1.3 の本文を直接抽出して確認**（hit policy / overlap の形式定義 / Unique の SHALL NOT / no-match は null）。1.5 の PDF は取得サイズ上限を超え、1.6 は 404。仕様ページ（現行 1.7 beta）https://www.omg.org/spec/DMN/ は位置づけと目的の確認に使用
- ▲ Bruce Silver "DMN Hit Policy Explained", Trisotech https://www.trisotech.com/dmn-hit-policy-explained/
- ▲ DMN（Drools ドキュメント）https://docs.drools.org/latest/drools-docs/drools/DMN/index.html
- ▲ hit policy と完全性（SAP Signavio）https://help.sap.com/docs/signavio-process-modeler/user-guide/dmn-hit-policy
- ★ Denis Merigoux, Nicolas Chataing, Jonathan Protzenko "Catala: A Programming Language for the Law", *Proc. ACM Program. Lang.* 5(ICFP), 77:1-29, 2021 https://dl.acm.org/doi/10.1145/3473582 / preprint https://arxiv.org/pdf/2103.03198（本文を直接抽出して確認）
- ★ Business Rules Manifesto（Business Rules Group, 2003）https://www.businessrulesgroup.org/brmanifesto.htm — 4.7 / 5.2 を本文で確認。項番は版で異なる（Ross 2003 版では 3.5 / 3.6）
- ○ Catala 公式ドキュメント https://book.catala-lang.org/en/2-2-conditionals-exceptions.html （要約器経由。逐語引用には使わない）

Revalidation trigger: DMN の hit policy か gap の扱いが変わったとき。**確認したのは v1.3 の本文なので、v1.5 以降で hit policy・overlap の定義・no-match の挙動が変わっていないかを確認したとき**（1.5 の PDF は 10MB を超えるため直接ダウンロードが必要）。subsumption をプローブAの検査に加えた効果を実測したとき。
