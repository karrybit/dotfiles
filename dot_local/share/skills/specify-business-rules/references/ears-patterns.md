# EARS パターン

Last checked: 2026-08-06

EARS（Easy Approach to Requirements Syntax）は、Rolls-Royce の Alistair Mavin らがジェットエンジン制御系の耐空性規則（CS-E）を分析する過程で作った記法で、RE'09 で公表された。

**規定するのは規則文1文の構造**——前提・契機・主体・応答の分離と、その順序。規則間の優先は DMN/Catala、語彙は ORM/SBVR が担当する（`references/rule-priority.md`、`references/sbvr-vocabulary.md`）。

証拠の等級: **★** 原典本文を確認 / **▲** 公式ガイド（要約器経由） / **○** 二次情報

## Source Summary

★ 一般形は次のとおり（§4.1）。節の順序は時相論理に従うため有意味だと原典が明示する（「The order of the clauses in this syntax is also significant, since it follows temporal logic」）。

```
While <optional pre-condition>, when <optional trigger>,
the <system name> shall <system response>
```

▲ 構成要素の個数が決まっている。前提は0個以上、契機は0個か1個、システム名は1個、応答は1個以上。

★ `shall` が義務を表す語として固定される。**主体 `the <system name>` と応答も規定対象である**——前提と契機だけを規定するわけではない。

| パターン | キーワード | 意味 | 原典の例 |
| --- | --- | --- | --- |
| Ubiquitous | なし | 常に成立する | The mobile phone shall have a mass of less than XX grams. |
| State-driven | While（`During` も可） | 状態が続くあいだ成立 | While there is no card in the ATM, the ATM shall display "insert card to begin". |
| Event-driven | When | 事象の発生で起動 | When "mute" is selected, the laptop shall suppress all audio output. |
| Optional feature | Where | その機能を含む構成でのみ成立 | Where the control system includes an overspeed protection function, the control system shall test the availability of the overspeed protection function prior to aircraft dispatch. |
| Unwanted behaviour | If / Then | 望まない状況への応答 | If an invalid credit card number is entered, then the website shall display... |
| Complex | 上記の組合せ | 前提と契機を複数持つ | While the aircraft is on-ground, when reverse thrust is commanded, the control system shall enable deployment of the thrust reverser. |

★ `Where` の一般形は `WHERE <feature is included> the <system name> shall <system response>`（§4.6）。**「その機能を含むシステムでのみ適用される」までしか述べておらず、いつ決まるか・実行中に変わらないかは原典にない。**

### 組合せは自由（ここを誤ると検査が壊れる）

★ §4.7 は逐語で次のとおり。

> For requirements with complex conditional clauses, combinations of the keywords **When, While and Where** may be required.
> The keywords When, While and Where can also be used **within If-Then statements** to handle unwanted behaviour with more complex conditional clauses.

★ 原典自身の例が2件ある。**どちらも If-Then との組合せ**である。

> While the aircraft is in-flight, **if** reverse thrust is commanded, **then** the control system shall inhibit thrust reverser deployment.
> When selecting idle setting, **if** aircraft data is unavailable, **then** the control system shall select Approach Idle.

したがって「複合は While + When のみ」は誤りである。**キーワードの組合せをエラーにしてはいけない。** 導出は分類であって検査ではない。

（この誤りは以前このファイルに書かれ、`scripts/check-spec.py` の検査とその selftest にまで機械化されていた。現在は組合せを報告するだけで、回帰テストが入っている。）

### `During` は While の公式な代替

★ §4.5:

> To make requirements easier to read, the keyword `During` can be used instead of `While` for state-driven requirements. … In this context, the meaning of `During` is identical to `While`, and this alternative keyword is used purely to aid readability.

**原典自身が可読性のための同義語を1つ認めている。** 後述の「1パターン1語に固定」は日本語で機械検査するための**こちら側の制約**であって、原典の精神ではない。混同しないこと。

### 原典が明示している限界

★ §2:

> There is no claim made that this approach is **universally applicable to all levels of system decomposition**. The technique is most suitable to the definition of **high-level stakeholder requirements**.

★ §6 は消えた問題と減っただけの問題を区別する。

> …duplication, implementation and untestability. However, **the claim that omissions have been eliminated needs to be treated with caution.** … there is no evidence that other missing requirements have been captured. The problems of **ambiguity, vagueness and wordiness were reduced, but not eliminated.**

残った原因として lexical ambiguity（前提が推論で理解され明記されない）、general vagueness（高水準要求に固有で、設計判断が伴うまで除けない）、wordiness を挙げる。

★ 望ましさの区別も絶対ではない（§4.4 脚注）。

> Hence the distinction between wanted and unwanted behaviour is **a matter of viewpoint, or even a matter of style**.

**効果の源を「キーワード限定と節順固定の2つだけ」と限定しないこと。** どちらの出典も排他性を述べていない。§6 は要求数の増加を複合要求の分解に帰しており、分解そのものも効果に寄与している。

## 日本語での固定形

**ここが実務上いちばん壊れる箇所。** キーワードを限定しても、素直に日本語へ訳すと「場合」が3パターンを飲み込み、区別が消える。

```
When（契機）  → 「〜の場合」
If（逸脱）    → 「〜の場合」   ← 衝突
Where（構成） → 「〜の場合」   ← 衝突
```

そこで表層形を1パターン1語に固定し、**裸の「場合」を禁止語**にする。**これは機械検査のための独自制約である**（原典は `During` のような同義語を認めている）。

| パターン | 種別名 | 固定する日本語 | 検査キーワード |
| --- | --- | --- | --- |
| Ubiquitous | 常時 | （キーワードなし） | 他の4語を含まない |
| State-driven | 状態 | 「〜である間、」 | `間、` |
| Event-driven | 契機 | 「〜したとき、」 | `とき、` |
| Optional feature | 構成 | 「〜を備える構成では、」 | `構成では` |
| Unwanted behaviour | 逸脱 | 「〜が発生したならば、」 | `ならば、` |
| 上記の組合せ | 複合(…) | 該当する語を並べる | 該当する語すべて |

読点まで含めて検査するのは節の境界を機械的に見つけるため。「7年間 保持」のような語中の「間」を誤検出しない。

節の順序は原典どおり固定する。**前提 → 契機 → 主体 → 応答。** 日本語は語順が自由なので意識して守る。

**この表は `scripts/check-spec.py` の導出規則そのもの。** 変えるときはスクリプトと同時に変え、`--selftest` を走らせる。

## 正例と反例

**状態（While）**

```
✅ [申請] の [申請金額] が 10,000円 以下 である間、[経費精算システム] は
   [申請] を 自動承認 しなければならない

❌ [申請金額] が少額の場合、自動承認する
   → 「場合」が契機か状態か構成かを決めない。主体がない。様相がない。
```

**契機（When）**

```
✅ [申請] が 承認されたとき、[経費精算システム] は 会計システムへ 仕訳を
   送信 しなければならない

❌ 承認後、担当者が仕訳を送信する
   → 主体がシステムでない。様相がない。「承認後」は契機の固定語ではない。
```

**逸脱（If/Then）**

```
✅ [承認者] が 30日 以上 応答しない ことが 発生したならば、[経費精算システム] は
   [申請] を [従業員] に 差戻し しなければならない

❌ 承認が滞留した場合は適切に対応する
   → 滞留の閾値がない。「適切に」の判定者が決まらない。
```

**複合（原典が認める形）**

```
✅ 機体が 飛行中 である間、[逆推力] が 指令されたならば、[制御系] は
   展開を 抑止 しなければならない
   → 状態＋逸脱。原典 §4.7 の例と同型で、正当な EARS 複合形。

✅ [月次締め処理] が実行中である間、[申請] が 提出されたとき、
   [経費精算システム] は 受付を 保留 しなければならない
   → 状態＋契機。
```

**組合せは正当だが、多用は別の問題の兆候**

3語以上が同居する規則が多いなら、事実の粒度が粗く1つの規則に複数の規則が入っている疑いがある。**組合せ自体は誤りではない**ので、検査ではなく設計の見直しとして扱う。

## 誤用しやすい判断

- **状態か契機か迷ったら、終わりがあるかを見る。** 状態には終わりがあり、そのあいだ規則は成立し続ける。契機は一瞬で、応答は1回。
- **逸脱と契機の違いは望ましさ。** ただし原典が「視点、あるいは作法の問題」と留保している。**分ける実利は、異常系の規則が漏れやすく、まとめると数えられなくなること**にある。分類の正しさを争わない。
- **構成は製品構成の話に限る。** 実行時の条件（設定値、権限、フラグ）は状態として書くほうが読みやすい。ただし「構成は実行中に変わらない」は原典の主張ではなく、こちら側の運用方針である。

## Practical Use

- 規則を書く前にパターンを決め、それから文を書く。文を書いてからパターンを当てにいくと、文の都合でパターンが決まる（仕様ファイルに宣言欄はないが、この順序は守る）。
- **どのパターンにも収まらない規則が出たら、2つの可能性を両方見る。** 事実の粒度が粗い場合（`references/orm-fact-types.md`）と、**記法側が届いていない場合**。原典が §2 と §6 で後者の可能性を明示的に開いているので、常に前者と決めつけない。
- EARS は網羅性を保証しない。パターンに沿った規則が揃っていても、規則の集合としての穴（gap）は検査されない。そこは決定表（プローブA）が見る。

## Sources

- ★ Mavin, Wilkinson, Harwood, Novak "Easy Approach to Requirements Syntax (EARS)", RE'09（17th IEEE International Requirements Engineering Conference, 2009）https://ccy05327.github.io/SDD/08-PDF/Easy%20Approach%20to%20Requirements%20Syntax%20(EARS).pdf — 本文を直接抽出して §2 / §4.1–4.8 / §6 / §7 を確認
- ▲ Alistair Mavin, EARS 公式ガイド https://alistairmavin.com/ears/ — 要約器経由。**逐語引用には使わない**（要約器が存在しない例文を返した実績がある）
- ○ Easy Approach to Requirements Syntax（Wikipedia）https://en.wikipedia.org/wiki/Easy_Approach_to_Requirements_Syntax

Revalidation trigger: 日本語の固定形を変えるとき（スクリプトの検査キーワードと同時に変える）。§7 が予告する「望まない状態のための追加テンプレート」が公式に追加されたとき。公式ガイドの記述を逐語で引く必要が生じたとき（要約器を経由せず取得する）。
