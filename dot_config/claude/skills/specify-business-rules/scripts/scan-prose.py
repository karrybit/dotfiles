#!/usr/bin/env python3
"""形式を要求しない曖昧さスキャン。

ユーザーストーリー、ユースケース、チケット、議事録など、**書き方が統一されて
いない既存文書**にそのまま当てる。固定形式を前提にしない。

check-spec.py との違い:
  check-spec.py  正規化層（固定形式）に対する門番。エラーで止める。
  scan-prose.py  原文層に対する報告。止めない。ヒットは正常。

「場合」はここでは検出しない。原文の日本語として自然な語であり、禁止が意味を
持つのは正規化層（規則文はパターンが一意に決まらなければならない）だけである。
同じ語でも層によって価値が違う。

使い方:
    python3 scan-prose.py ストーリー*.md
    python3 scan-prose.py --ref-pattern 'US-\\d+' docs/*.md
    python3 scan-prose.py --only hidden-exception,blank ストーリー.md
    python3 scan-prose.py --tsv ストーリー*.md > findings.tsv
    python3 scan-prose.py --selftest
"""

import argparse
import re
import sys
from collections import defaultdict

CATEGORIES = {
    "hidden-exception": (
        "隠れた例外",
        "原則を名指しせずに例外の存在を示している。原則と例外を別の規則として書き分ける",
        [
            "原則として", "原則的に", "基本的に", "通常は", "通常、",
            "一般的に", "一般に", "たいていは", "多くの場合", "例外的に",
        ],
    ),
    "vague": (
        "曖昧語",
        "判定者・水準・条件が決まらない",
        [
            "適切に", "適宜", "必要に応じて", "可能な限り", "十分に", "柔軟に",
            "随時", "なるべく", "できるだけ", "極力", "など", "その他",
            r"等\s*(?:[、。のをはがに]|$)",
        ],
    ),
    "legal-term": (
        "法令用語",
        "定義された意味を持つ語。出典があるならそのまま保つ。出典がないなら期限を書く",
        ["直ちに", "速やかに", "遅滞なく"],
    ),
    "blank": (
        "未帰属の空欄",
        "未決定・書き忘れ・意図的自由のどれか。分類とオーナーを付ける",
        [
            "TBD", "TODO", "FIXME", "未定", "未確定", "要確認", "要検討",
            "要相談", "検討中", "調整中", r"（仮）", r"\(仮\)", r"[?？]{2,}",
            r"\bx{3,}\b", r"\bX{3,}\b",
        ],
    ),
    "delegation": (
        "外部への委譲",
        "参照先が名指しされていない。単独で読めない",
        [
            "別途", "別紙", "所定の", "規定の", "前述の", "後述の",
            "上記の通り", "上記のとおり", "下記の通り", "下記のとおり",
        ],
    ),
    "quantity": (
        "数量の曖昧",
        "件数・量が数値で決まらない",
        ["複数", "多数", "大量", "少数", "若干", "多量"],
    ),
}


def compile_patterns():
    out = {}
    for key, (label, why, pats) in CATEGORIES.items():
        compiled = []
        for p in pats:
            # 素の語は literal、正規表現メタを含むものはそのまま使う
            rx = p if re.search(r"[\\\[\](){}|+*?]", p) else re.escape(p)
            compiled.append((p, re.compile(rx)))
        out[key] = (label, why, compiled)
    return out


def scan(paths, categories, ref_pattern):
    findings = []
    ref_seen = defaultdict(list)
    ref_defined = set()
    compiled = compile_patterns()
    ref_rx = re.compile(ref_pattern) if ref_pattern else None

    for path in paths:
        try:
            lines = open(path, encoding="utf-8").read().splitlines()
        except OSError as exc:
            print(f"読み込めない: {exc}", file=sys.stderr)
            sys.exit(2)
        in_code = False
        for lineno, raw in enumerate(lines, 1):
            if raw.lstrip().startswith("```"):
                in_code = not in_code
                continue
            if in_code:
                continue
            for key in categories:
                label, why, pats = compiled[key]
                for src, rx in pats:
                    for m in rx.finditer(raw):
                        findings.append((path, lineno, key, label, m.group(0), raw.strip()))
                        break
            if ref_rx:
                is_heading = raw.lstrip().startswith("#")
                for m in ref_rx.finditer(raw):
                    rid = m.group(0)
                    if is_heading:
                        ref_defined.add(rid)
                    else:
                        ref_seen[rid].append((path, lineno))

    unresolved = []
    if ref_rx:
        for rid, places in sorted(ref_seen.items()):
            if rid not in ref_defined:
                path, lineno = places[0]
                unresolved.append((path, lineno, rid, len(places)))
    return findings, unresolved


def report(findings, unresolved, tsv):
    if tsv:
        print("path\tline\tcategory\tmatch\tcontext")
        for path, lineno, key, _, match, ctx in findings:
            print(f"{path}\t{lineno}\t{key}\t{match}\t{ctx}")
        for path, lineno, rid, n in unresolved:
            print(f"{path}\t{lineno}\tunresolved-ref\t{rid}\t参照{n}件・定義なし")
        return

    by_cat = defaultdict(list)
    for f in findings:
        by_cat[f[2]].append(f)

    order = [k for k in CATEGORIES if k in by_cat]
    for key in order:
        label, why, _ = CATEGORIES[key]
        items = by_cat[key]
        print(f"\n## {label} ({key}) — {len(items)}件")
        print(f"   {why}")
        for path, lineno, _, _, match, ctx in items:
            snippet = ctx if len(ctx) <= 70 else ctx[:69] + "…"
            print(f"   {path}:{lineno}  「{match}」  {snippet}")

    if unresolved:
        print(f"\n## 未解決の参照 (unresolved-ref) — {len(unresolved)}件")
        print("   参照されているが、見出しとして定義されていない")
        for path, lineno, rid, n in unresolved:
            print(f"   {path}:{lineno}  {rid}  (参照{n}件)")

    total = len(findings) + len(unresolved)
    print(f"\n合計 {total}件")
    if total:
        print("ヒットは正常。ここは指摘候補であって欠陥の確定ではない。")
        print("次: normalization.md の割り当て表で正規化し、プローブA/Bを走らせる。")


SELFTEST = [
    ("原則として上長が承認する", "hidden-exception"),
    ("必要に応じて経理が確認する", "vague"),
    ("申請は等、保存する", "vague"),
    ("遅滞なく通知する", "legal-term"),
    ("承認者はTBD", "blank"),
    ("上限額は未定", "blank"),
    ("閾値は？？", "blank"),
    ("別途定める手続きに従う", "delegation"),
    ("所定の様式で申請する", "delegation"),
    ("複数の承認者が確認する", "quantity"),
    ("申請が却下された場合、通知する", None),
    ("10,000円以下は自動承認する", None),
]


def selftest():
    failures = 0
    for i, (text, want) in enumerate(SELFTEST):
        import tempfile
        import os

        with tempfile.NamedTemporaryFile(
            "w", suffix=".md", delete=False, encoding="utf-8"
        ) as fh:
            fh.write(text + "\n")
            path = fh.name
        try:
            findings, _ = scan([path], list(CATEGORIES), None)
        finally:
            os.unlink(path)
        got = sorted({f[2] for f in findings})
        ok = (got == [want]) if want else (got == [])
        if not ok:
            failures += 1
            print(f"FAIL case {i}: 期待 {[want] if want else []} / 実際 {got}")
            print(f"     {text}")
    total = len(SELFTEST)
    print(f"\nselftest: {total - failures}/{total} 通過")
    return 1 if failures else 0


def main():
    ap = argparse.ArgumentParser(
        description="形式を要求しない曖昧さスキャン（既存のストーリー／ユースケース文書向け）"
    )
    ap.add_argument("paths", nargs="*", help="対象ファイル")
    ap.add_argument("--only", help=f"カテゴリを絞る（カンマ区切り）: {','.join(CATEGORIES)}")
    ap.add_argument("--ref-pattern", help=r"ID 参照の正規表現（例 'US-\d+'）")
    ap.add_argument("--tsv", action="store_true", help="TSV で出力する")
    ap.add_argument("--selftest", action="store_true", help="検出規則そのものを自己検証する")
    args = ap.parse_args()

    if args.selftest:
        return selftest()
    if not args.paths:
        ap.error("対象ファイルを指定する（または --selftest）")

    categories = list(CATEGORIES)
    if args.only:
        categories = [c.strip() for c in args.only.split(",")]
        unknown = [c for c in categories if c not in CATEGORIES]
        if unknown:
            ap.error(f"不明なカテゴリ: {', '.join(unknown)}")

    findings, unresolved = scan(args.paths, categories, args.ref_pattern)
    report(findings, unresolved, args.tsv)
    return 0


if __name__ == "__main__":
    sys.exit(main())
