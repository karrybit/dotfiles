# EARS パターン

Last checked: 2026-08-06

EARS（Easy Approach to Requirements Syntax）は、Rolls-Royce の Alistair Mavin らがジェット engine 制御系の耐空性規則を分析する過程で作った記法で、RE'09 で公表された。**規則文の「前提と契機」の構造だけを規定する。** 帰結の様相は SBVR、規則間の優先は Catala が担当する（`references/sbvr-vocabulary.md`、`references/catala-default-logic.md`）。

## Source Summary

効果の源は2つだけ。**キーワードを少数に限定すること**と、**節の順序を固定すること**である。自由記述に対して弱い制約をかけ、曖昧さ・漠然さ・不完全さを減らす。訓練コストが小さいことが設計目標に含まれている。

一般形は次のとおりで、すべてのパターンはこの部分形にあたる。

```
While <optional pre-condition>, when <optional trigger>,
the <system name> shall <system response>
```

構成要素の個数が決まっている。前提は0個以上、契機は0個か1個、システム名は1個、応答は1個以上。

| パターン | キーワード | 意味 | 原典の例 |
| --- | --- | --- | --- |
| Ubiquitous | なし | 常に成立する | The mobile phone shall have a mass of less than XX grams. |
| State-driven | While | 状態が続くあいだ成立 | While there is no card in the ATM, the ATM shall display "insert card to begin". |
| Event-driven | When | 事象の発生で起動 | When "mute" is selected, the laptop shall suppress all audio output. |
| Optional feature | Where | その機能を含む構成でのみ成立 | Where the car has a sunroof, the car shall have a sunroof control panel on the driver door. |
| Unwanted behaviour | If / Then | 望まない状況への応答 | If an invalid credit card number is entered, then the website shall display... |
| Complex | While + When | 前提と契機の両方を持つ | While <precondition>, when <trigger>, the <system> shall <response> |

`shall` が義務を表す語として固定されている。

## 日本語での固定形

**ここが実務上いちばん壊れる箇所。** EARS の効果はキーワードの限定から来ているのに、素直に日本語へ訳すと「場合」が3パターンを飲み込み、区別が消える。

```
When（契機）  → 「〜の場合」
If（逸脱）    → 「〜の場合」   ← 衝突
Where（構成） → 「〜の場合」   ← 衝突
```

そこで表層形を1パターン1語に固定し、**裸の「場合」を禁止語**にする。第0段のスクリプトがこれを検査する。

| パターン | 種別名 | 固定する日本語 | 検査キーワード |
| --- | --- | --- | --- |
| Ubiquitous | 常時 | （キーワードなし） | 他の4語を含まないこと |
| State-driven | 状態 | 「〜である間、」 | `間、` |
| Event-driven | 契機 | 「〜したとき、」 | `とき、` |
| Optional feature | 構成 | 「〜を備える構成では、」 | `構成では` |
| Unwanted behaviour | 逸脱 | 「〜が発生したならば、」 | `ならば、` |
| Complex | 複合 | 「〜である間、〜したとき、」 | `間、` と `とき、` の両方 |

読点まで含めて検査するのは、節の境界を機械的に見つけるため。「7年間 保持」のような語中の「間」を誤検出しない。

**この表は `scripts/check-spec.py` がパターンを導出する規則そのものである。** 仕様ファイルにパターンを宣言する欄はない。表を変えるときはスクリプトと同時に変え、`--selftest` を走らせる。

節の順序も原典どおり固定する。**前提 → 契機 → 主体 → 応答。** 日本語は語順が自由なので、これは意識して守る必要がある。

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
   → 主体がシステムでない。様相がない。「承認後」は契機の語ではないので
      パターンが導出できない。
```

**逸脱（If/Then）**

```
✅ [承認者] が 30日 以上 応答しない ことが 発生したならば、[経費精算システム] は
   [申請] を [従業員] に 差戻し しなければならない

❌ 承認が滞留した場合は適切に対応する
   → 滞留の閾値がない。「適切に」の判定者が決まらない。
```

**キーワードを1文に混ぜる**

パターンは宣言せず規則文から導出するので（`references/spec-format.md`）、宣言と文の不一致は起こらない。代わりに**どのパターンにも対応しないキーワードの組合せ**が誤りになる。

```
❌ [申請] が 出されたとき、壊れたならば、[申請] を 破棄 しなければならない
   → 「とき、」（契機）と「ならば、」（逸脱）が同居し、EARS のどのパターンにも
      対応しない。正常系と異常系が1文に入っている合図。

✅ [申請] が 出されたとき、[経費精算システム] は [申請] を 受付 しなければならない
✅ [申請] が 壊れたならば、[経費精算システム] は [申請] を 破棄 しなければならない
```

**複合が許すのは「間、」＋「とき、」だけ**（EARS の complex requirement が While + When のみを認めるため）。他の組合せは規則を分ける。

## 誤用しやすい判断

- **状態か契機か迷ったら、終わりがあるかを見る。** 状態には終わりがあり、そのあいだ規則は成立し続ける。契機は一瞬で、応答は1回。「ログイン中である間」は状態、「ログインしたとき」は契機。
- **逸脱と契機の違いは望ましさ。** 同じ事象でも、正常系なら契機、異常系なら逸脱。分けるのは、異常系の規則が漏れやすく、まとめると数えられなくなるため。
- **構成は製品構成の話に限る。** 実行時の条件（設定値、権限、フラグ）は状態であって構成ではない。構成はビルドや契約で決まり、実行中に変わらないもの。
- **複合を多用しない。** 前提と契機の両方が必要な規則は本来少ない。多いなら語彙の粒度が粗く、1つの規則に2つの規則が入っている疑いがある。

## Practical Use

- 規則を書く前にパターンを宣言し、それから文を書く。文を書いてからパターンを当てにいくと、文の都合でパターンが決まる。
- どのパターンにも収まらない規則は、EARS の不足ではなく **elementary でない**ことがほとんど。`references/orm-fact-types.md` を読んで事実に分解する。
- EARS は網羅性を保証しない。パターンに沿った規則が揃っていても、規則の集合として穴があることは検査されない。そこは決定表（プローブA）が見る。

## Sources

- Alistair Mavin, EARS 公式ガイド https://alistairmavin.com/ears/
- Mavin, Wilkinson, Harwood, Novak "Easy Approach to Requirements Syntax (EARS)", RE'09（IEEE International Requirements Engineering Conference 2009）https://ccy05327.github.io/SDD/08-PDF/Easy%20Approach%20to%20Requirements%20Syntax%20(EARS).pdf
- Easy Approach to Requirements Syntax（Wikipedia、パターン一覧の確認用）https://en.wikipedia.org/wiki/Easy_Approach_to_Requirements_Syntax

Revalidation trigger: 日本語の固定形を変えるとき（スクリプトの検査キーワードと同時に変える）。EARS に新しいパターンが公式に追加されたとき。
