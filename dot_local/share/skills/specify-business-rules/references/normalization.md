# 形のない記述を正規化する

Last checked: 2026-08-06

進行中の案件では、機能仕様はユーザーストーリーやユースケースとして**すでに書かれている**。書き方は会社・チーム・人ごとに違い、統一形式は存在しない。ICONIX や RDRA のような型はあるが、律儀に守られているとは限らない。

**だから固定形式を入力要件にしない。** 形式は正規化の**出力先**である。

## 3層に分ける

`~/.config/agents/AGENTS.md` の Information Design 規則（生観察 / 正規化済みレコード / 用途別出力）をそのまま適用する。

| 層 | 中身 | 変更するか |
| --- | --- | --- |
| **原文** | ストーリー、ユースケース、チケット、Confluence ページ。書かれたまま | **しない** |
| **正規化** | 原文から導出した用語・規則・フロー・未決定。各レコードは原文の行番号か引用を持つ | 作る |
| **指摘** | レビュー結果。ユーザーが読む | 作る |

各レコードは原文へ辿れること（lineage）。**正規化層が原文を置き換えてはいけない。** 用途が変われば正規化をやり直せる状態を保つ。

## 正規化できないことが欠陥である

これが手順の中心。正規化は前処理ではなく**レビューそのもの**である。

原文の各文を次のどれかに割り当てる。**この6種がこのskill全体で唯一の権威ある種別集合である。** 他の箇所はここを参照するだけにし、部分集合を書き直さない。

| 種別 | 見分け方 | 行き先 |
| --- | --- | --- |
| 規則 | 条件と、常に成り立つ帰結を述べている | 規則レコード |
| 例（シナリオ） | 特定の1ケースの入出力を述べている | 規則の根拠として添える |
| フロー手順 | 順序の中の1段。前の段を前提にする | フローレコード |
| 目標・理由 | 「〜したい」「〜のため」 | 正規化しない（そのまま残す） |
| 用語の定義 | 概念を説明している | 用語レコード |
| 未決定 | 決まっていない、または決められない | 未決定レコード |

**どれにも割り当てられない文が出たら、それが指摘である。** 「規則なのか例なのか判別できない」「フロー手順なのか常時成り立つ規則なのか読めない」——これは正規化の失敗ではなく、原文の曖昧さの検出である。

この形は「成果物を作らせ、作れない箇所を欠陥とする」の適用であり、観点を並べたチェックリストではない。**割り当て表を埋めさせることが検出機構である。**

## 例と規則を混同しない

いちばん多い曖昧さ。受入基準は Given-When-Then で書かれることが多いが、**GWT はシナリオ指向（特定の例）であり、EARS は規則指向（全域に効く義務）である。**

```
例（シナリオ）: 8,000円の申請を出したら自動承認された
規則:           [申請金額] が 10,000円 以下 である間、... 自動承認 しなければならない
```

例からは規則が一意に決まらない。8,000円が通ったことは、閾値が 10,000 なのか 8,000 なのか 100,000 なのかを決めない。**例しか書かれていない箇所は「規則が書かれていない」として扱う。** 境界値がどこかは書き手にしか埋められない。

逆に、例は規則の検算に使える。正規化した規則に原文の例を当てて、原文が述べた帰結と一致するかを見る。一致しなければ、規則の読み取りが間違っているか原文が矛盾している。

## 業務規則は散らばっている

進行中案件でいちばんよく起きているのはこれ。**1つの業務規則が複数ストーリーの受入基準に分割され、どこにも全体が書かれていない。**

```
US-1101 受入基準: 1万円以下の申請は自動承認される
US-1240 受入基準: 出張の申請は金額にかかわらず経理が確認する
US-1355 受入基準: 原則として上長承認が必要
```

3枚のチケットに散った3行が、1つの承認規則である。この状態では、8,000円の出張申請でどうなるかを**どのチケットも答えない**。誰も間違っていないのに仕様が決まっていない。

**この問題意識は既存文献に明記されている。** Business Rules Manifesto（Business Rules Group, 2003）から、逐語で3項目。

> **2.2** Rules are not process and not procedure. They should not be contained in either of these.
> **2.3** Rules apply across processes and procedures. There should be **one cohesive body of rules**, enforced consistently across all relevant areas of business activity.
> **5.2** Business rules should be expressed in such a way that they can be **verified against each other for consistency**.

Manifesto 2.2 の対象は **process と procedure** である。「ユースケースなどの要件文書に埋め込まれている」ことを述べているのは別の出典（enfocus: "embedded in ... requirement documents, such as use cases and business requirements documents"）で、**Manifesto に帰属させてはいけない。**

**規則レコードを ID で束ねる作業が、この散在を可視化する。** 集約した結果を正本にするかは別の判断（`references/spec-format.md`）。ただし出典側は分離をより強く要求している（Manifesto 2.3 の「one cohesive body of rules」、enfocus の「maintained separately from the requirements. Requirements should reference the rules」）。

## 既存の型との読み替え

チームが ICONIX や RDRA を部分的に使っているなら、次のように対応する。守っていなくても構わない。**対応物がある層は既存の成果物を再利用し、ない層だけを新たに作る。**

| 本skillの層 | アジャイル | ICONIX | RDRA |
| --- | --- | --- | --- |
| 語彙（ORM/SBVR） | 用語集があれば | ドメインモデル | 概念モデル（システム外部環境層） |
| 規則文（EARS） | 受入基準 | ユースケース本文の一部 | バリエーション・条件・状態モデル、プロトコルモデル |
| 命名 | ストーリーID（規則自体にはない） | — | — |
| 例外構造（DMN / Catala） | 不明（下記） | 不明（下記） | 不明（下記） |
| 未決定の3分類 | — | — | — |
| フロー | — | ユースケース本文（基本／代替） | 業務モデル（システム外部環境層） |

**語彙層は既存資産がある。** ICONIX のロバストネス分析は「付随するドメインモデルの文脈で書かれていることを保証することで、ユースケース記述の曖昧さを減らす」手法である。ドメインモデルがすでにあるなら、それを語彙レコードの出発点にする。RDRA の概念モデルも同じ位置。（**プローブBと同じことを図で行っている、というのはこちらの解釈であって出典の言明ではない。**）

**本skillが足すのは機構であって、問題意識ではない。** 以前ここには「例外構造には ICONIX・RDRA・アジャイルのいずれも対応物を持たない。ここが本skillが既存の型に足す部分である」と書いていたが、2点で過剰だった。

1. **問題は Manifesto が明記している。** 4.7「Exceptions to rules are expressed by other rules.」が例外の表し方を規定し、5.2 が規則間の一貫性検証を要求している。本skillの設計は 4.7 を満たし（各例外が独立した規則レコード）、5.2 を機械化する（決定表と `例外元`）。**新しいのは、要求されながら機構が与えられていなかった部分を埋めたことである。**
2. **「対応物なし」の根拠が薄い。** ICONIX・アジャイルについては反証も得られていないが、積極的な根拠もない（挙げている Rosenberg の URL は前付と第1章の抜粋のみ）。RDRA についても、バリエーション・条件の意味を述べた記述は挙げている出典2件に存在しない。**したがって表は「不明」とし、否定的主張はしない。**

アジャイルについては、そもそも要素集合が定まらない（手法の出典を1件も挙げていない）ため、肯定も否定もできない。

## Practical Use

- 正規化は原文を書き換えない。**別ファイルに作る。** 進行中案件のチケットを書き換えると、開発中のチームの参照先が壊れる。
- 全ストーリーを正規化しない。**1つの業務規則を疑ったら、それに触れているストーリーだけを集める。** 全件正規化は費用が価値を超える。
- 正規化の途中で「これは規則か例か」に迷ったら、迷ったこと自体を記録する。後で消せる。
- フロー手順は正規化してもこのskillでは使わない。`review-doc-fresh-eyes` の「手順の文書」型へ回す。

## Sources

証拠の等級: **★** 一次資料を確認 / **▲** 実装者・専門家の解説 / **○** 二次情報

- Information Design 規則と根拠: `~/.config/agents/AGENTS.md`、`~/.local/share/agents/docs/medallion-information-design.md`
- ★ Business Rules Manifesto（Business Rules Group, 2003）**一次** https://www.businessrulesgroup.org/brmanifesto.htm — 引用した 2.2 / 2.3 / 4.7 / 5.2 は本文で確認。**項番は版で異なる**（Ross 2003 版では 2.2→1.4、4.7→3.5、5.2→3.6）ので、項番を引くときは版を明示する
- ▲ Ross による Manifesto 解説（2003 版）http://web.archive.org/web/20091229134644/http://www.policy-workshop.org:80/2003/web/policy2003/common/RonaldPresentation.pdf — 原 URL（policy-workshop.org）は HTTP 522 で到達不能。archive.org のスナップショット（2009-12-29）を正とする
- ▲ 業務規則が要件文書に埋め込まれる問題（John Parker）http://web.archive.org/web/20240416041452/https://enfocussolutions.com/business-rules/ — 原 URL（enfocussolutions.com）はドメイン失効で 404。archive.org のスナップショット（2024-04-16）を正とする
- ▲ ICONIX のロバストネス分析 https://sparxsystems.com/enterprise_architect_user_guide/17.1/modeling_domains/iconix_process.html
- ○ Rosenberg & Stephens *Use Case Driven Object Modeling with UML* https://content.e-bookshelf.de/media/reading/L-5521-ca80696330.pdf — **URL の実体は前付と第1章の抜粋のみ。** 全体の主張の根拠には使えない
- ○ RDRA（二次情報のみ）https://qiita.com/tatane616/items/f7f4e5ad818fe8b125d6 、公式 http://masuda220.jugem.jp/?eid=363 — 層構成もバリエーション・条件・状態モデルの意味も、一次資料（書籍）未確認
- ▲ Given-When-Then がシナリオ指向であること https://www.ranorex.com/blog/given-when-then-tests/

Revalidation trigger: RDRA の一次資料（書籍）で層構成と、バリエーション・条件・状態モデルの意味、規則の優先関係を扱う構成要素の有無を確認したとき（読み替え表の「不明」を埋める）。ICONIX を Rosenberg の書籍全体で確認したとき。archive.org のスナップショットが失われたとき、または enfocus / Ross の記述に代替できる一次資料を見つけたとき。実案件で正規化を1回行い、割り当て表の6種が足りたかを確認したとき。
