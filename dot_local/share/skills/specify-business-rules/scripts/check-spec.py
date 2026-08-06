#!/usr/bin/env python3
"""業務規則仕様の第0段チェック。

references/spec-format.md の固定形式に対し、機械的に判定できる違反だけを見る。
意味の検査（例外条件の重なり、一語二義）はここでは扱わない。標準ライブラリのみ。

使い方:
    python3 check-spec.py 仕様.md [仕様2.md ...]
    python3 check-spec.py --strict 仕様.md    # 警告も失敗にする
"""

import argparse
import re
import sys
from collections import defaultdict

SECTIONS = ("語彙", "規則", "未決定")

PATTERNS = {
    "常時": (),
    "状態": ("間、",),
    "契機": ("とき、",),
    "構成": ("構成では",),
    "逸脱": ("ならば、",),
    "複合": ("間、", "とき、"),
}
ALL_KEYWORDS = ("間、", "とき、", "構成では", "ならば、")

# パターンは宣言させず、規則文のキーワードから導出する。宣言欄を置くと同じ情報を
# 2箇所に書かせ、照合しかしていない（欄そのものが情報を持たない）。導出できない
# キーワードの組合せは EARS のどのパターンにも対応しないため、それをエラーにする
# ほうが、宣言との不一致を見るより強い検査になる。
DERIVE = {frozenset(kws): name for name, kws in PATTERNS.items()}

MODALITIES = ("しなければならない", "してはならない", "してよい", "である")

CLASSES = ("未決定", "書き忘れ", "意図的自由")

RULE_ID = re.compile(r"^BR-[A-Z][A-Z-]*-\d{3,}$")
UNDECIDED_ID = re.compile(r"^UD-\d{3,}$")
TERM_REF = re.compile(r"\[([^\[\]]+)\]")
FIELD = re.compile(r"^-\s*([^:：]+)\s*[:：]\s*(.*)$")

BANNED = [
    (re.compile(r"場合"), "「場合」は契機・逸脱・構成のどれにも読めるため禁止。パターンに対応する語を使う"),
    (re.compile(r"等\s*(?:[、。のをはがに]|$)"), "「等」は対象が閉じないため禁止。列挙し切るか事実型を作る"),
    (re.compile(r"など"), "「など」は対象が閉じないため禁止。列挙し切るか事実型を作る"),
    (re.compile(r"その他"), "「その他」は対象が閉じないため禁止"),
    (re.compile(r"適切に"), "「適切に」は判定者が決まらないため禁止。判定条件を書く"),
    (re.compile(r"必要に応じて"), "「必要に応じて」は契機が決まらないため禁止。契機を書く"),
    (re.compile(r"可能な限り"), "「可能な限り」は義務の水準が決まらないため禁止"),
    (re.compile(r"十分に"), "「十分に」は水準が決まらないため禁止。数値か条件を書く"),
    # 「直ちに」「速やかに」「遅滞なく」は禁止しない。法制執務で即時性の順序が
    # 定まった法令用語であり、とくに「遅滞なく」は「合理的理由があればその遅れは
    # 許される程度の速さ」を意味する。出典の規程がこの語を使っているときに数値へ
    # 置き換えると、明確化ではなく意味の改変になる。scan-prose.py が原文層で
    # legal-term として報告し、出典の有無を人が判断する。
    (
        re.compile(r"原則として|基本的に"),
        "暗黙の例外を示している。例外を別の規則として書き、その規則の「例外元」にこの規則を指定する",
    ),
]

PLACEHOLDER_OWNER = re.compile(r"^(未定|TBD|tbd|不明|-|—|？|\?)$")


ALLOW = re.compile(r"^(E\d{3}|W\d{3})\s+(.+)$")


class Entry:
    def __init__(self, section, heading, path, line):
        self.section = section
        self.heading = heading
        self.path = path
        self.line = line
        self.fields = {}
        self.field_lines = {}
        self.allows = {}       # code -> 理由
        self.bad_allows = []   # 形式不正な「許容」行
        self.allow_lines = {}
        self.suppressed = set()


def parse(paths):
    entries = []
    for path in paths:
        try:
            text = open(path, encoding="utf-8").read()
        except OSError as exc:
            print(f"読み込めない: {exc}", file=sys.stderr)
            sys.exit(2)
        section = None
        entry = None
        for lineno, raw in enumerate(text.splitlines(), 1):
            line = raw.strip()
            if line.startswith("## "):
                section = line[3:].strip()
                entry = None
                continue
            if line.startswith("### "):
                entry = Entry(section, line[4:].strip(), path, lineno)
                entries.append(entry)
                continue
            if entry is None:
                continue
            m = FIELD.match(line)
            if m:
                key = m.group(1).strip()
                val = m.group(2).strip()
                if key == "許容":
                    am = ALLOW.match(val)
                    if am:
                        entry.allows[am.group(1)] = am.group(2).strip()
                        entry.allow_lines[am.group(1)] = lineno
                    else:
                        entry.bad_allows.append((lineno, val))
                    continue
                entry.fields[key] = val
                entry.field_lines[key] = lineno
    return entries


class Report:
    def __init__(self):
        self.errors = []
        self.warnings = []

    def error(self, entry, code, msg, key=None):
        if entry is not None and code in entry.allows:
            entry.suppressed.add(code)
            return
        line = entry.field_lines.get(key, entry.line) if entry else 0
        path = entry.path if entry else ""
        self.errors.append((path, line, code, msg))

    def warn(self, entry, code, msg, key=None):
        if entry is not None and code in entry.allows:
            entry.suppressed.add(code)
            return
        line = entry.field_lines.get(key, entry.line) if entry else 0
        path = entry.path if entry else ""
        self.warnings.append((path, line, code, msg))

    def raw_error(self, entry, line, code, msg):
        self.errors.append((entry.path if entry else "", line, code, msg))


def check(entries, report):
    vocab = {}
    rules = {}
    undecided = []

    for e in entries:
        if e.section == "語彙":
            if e.heading in vocab:
                report.error(e, "E101", f"用語 {e.heading} が重複して定義されている")
            vocab[e.heading] = e
        elif e.section == "規則":
            parts = e.heading.split(None, 1)
            rid = parts[0]
            e.rule_id = rid
            e.rule_name = parts[1] if len(parts) > 1 else ""
            if not RULE_ID.match(rid):
                report.error(e, "E201", f"規則 ID {rid} が BR-<AREA>-<NNN> 形式でない")
            if rid in rules:
                report.error(e, "E202", f"規則 ID {rid} が重複している。ID は再利用しない")
            else:
                rules[rid] = e
            if not e.rule_name:
                report.error(e, "E203", f"{rid} に規則名がない")
        elif e.section == "未決定":
            if not UNDECIDED_ID.match(e.heading):
                report.error(e, "E301", f"未決定 ID {e.heading} が UD-<NNN> 形式でない")
            undecided.append(e)

    referenced = check_vocab(vocab, report)
    referenced |= check_rules(rules, vocab, report)
    check_undecided(undecided, rules, vocab, report)
    check_exception_cycles(rules, report)
    check_allows(entries, report)

    # 規則が1件もない入力は語彙リスト単体（review モードの成果物）なので、
    # 未参照の警告は意味を持たない。
    if rules:
        for term, e in vocab.items():
            if term not in referenced:
                report.warn(e, "W101", f"用語 {term} はどの規則からも参照されていない")

    return rules


def check_vocab(vocab, report):
    referenced = set()
    for term, e in vocab.items():
        kind = e.fields.get("種別")
        if kind is None:
            report.error(e, "E102", f"{term} に「種別」がない")
        elif kind not in ("実体", "値", "事実型"):
            report.error(e, "E103", f"{term} の種別 '{kind}' は 実体|値|事実型 のいずれかでない", "種別")
        if not e.fields.get("定義"):
            report.error(e, "E104", f"{term} に「定義」がない")
        if kind == "事実型" and not e.fields.get("事実型"):
            report.error(e, "E105", f"{term} は種別が事実型だが「事実型」行がない")

        # 事実型の読み下しも語彙を参照する。未定義の語を含みうるので検査し、
        # 参照済みとして数える（規則からしか参照を数えないと役割語が未参照に見える）。
        verbal = e.fields.get("事実型")
        if verbal:
            for ref in TERM_REF.findall(verbal):
                referenced.add(ref)
                if ref not in vocab:
                    report.error(
                        e, "E106", f"{term} の事実型が参照する用語 [{ref}] が語彙にない", "事実型"
                    )
    return referenced


def unbracketed_terms(text, vocab):
    """角括弧の外に現れた語彙用語を返す。長い用語を先に消して部分一致の重複を避ける。"""
    bare = TERM_REF.sub(lambda m: "\x00" * (len(m.group(0))), text)
    found = []
    for term in sorted(vocab, key=len, reverse=True):
        idx = bare.find(term)
        if idx >= 0:
            found.append(term)
            bare = bare[:idx] + "\x00" * len(term) + bare[idx + len(term):]
    return found


def check_rules(rules, vocab, report):
    referenced = set()
    for rid, e in rules.items():
        text = e.fields.get("規則")
        source = e.fields.get("例外元")

        if source is None:
            report.error(e, "E206", f"{rid} に「例外元」がない。例外でないなら「なし」と書く")
        if not e.fields.get("出典"):
            report.warn(
                e,
                "W103",
                f"{rid} に「出典」がない。原文から正規化したものなら所在を書く"
                f"（新規に起草したものなら無視してよい）",
            )
        if not text:
            report.error(e, "E207", f"{rid} に「規則」がない")
            continue

        for term in TERM_REF.findall(text):
            referenced.add(term)
            if term not in vocab:
                report.error(e, "E208", f"{rid} が参照する用語 [{term}] が語彙にない", "規則")

        present = frozenset(kw for kw in ALL_KEYWORDS if kw in text)
        e.pattern = DERIVE.get(present)
        if e.pattern is None:
            combo = " + ".join(f"「{k}」" for k in sorted(present))
            report.error(
                e,
                "E209",
                f"{rid} のキーワードの組合せ {combo} は EARS のどのパターンにも対応しない。"
                f"1文に1パターンにするか、規則を分ける（複合は「間、」と「とき、」のみ）",
                "規則",
            )

        stripped = text.rstrip("。 ")
        if not stripped.endswith(MODALITIES):
            report.error(
                e,
                "E211",
                f"{rid} の規則文が様相で終わっていない。{' / '.join(MODALITIES)} のいずれかで終える",
                "規則",
            )

        for regex, msg in BANNED:
            if regex.search(text):
                report.error(e, "E212", f"{rid}: {msg}", "規則")

        for term in unbracketed_terms(text, vocab):
            report.warn(
                e, "W102", f"{rid}: 語彙にある「{term}」が角括弧なしで使われている", "規則"
            )

    for rid, e in rules.items():
        source = e.fields.get("例外元")
        if source and source != "なし" and source not in rules:
            report.error(e, "E213", f"{rid} の例外元 {source} が存在しない", "例外元")

    return referenced


def check_undecided(undecided, rules, vocab, report):
    for e in undecided:
        cls = e.fields.get("分類")
        if cls is None:
            report.error(e, "E302", f"{e.heading} に「分類」がない")
        elif cls not in CLASSES:
            report.error(
                e, "E303", f"{e.heading} の分類 '{cls}' は {' | '.join(CLASSES)} のいずれかでない", "分類"
            )
        owner = e.fields.get("オーナー", "")
        if not owner:
            report.error(e, "E304", f"{e.heading} に「オーナー」がない")
        elif PLACEHOLDER_OWNER.match(owner):
            report.error(
                e, "E305", f"{e.heading} のオーナーが '{owner}' で実質空。決める人を名前か役割で書く", "オーナー"
            )
        if not e.fields.get("内容"):
            report.error(e, "E306", f"{e.heading} に「内容」がない")
        target = e.fields.get("対象")
        if not target:
            report.error(e, "E307", f"{e.heading} に「対象」がない")
        elif target.startswith("語彙:") or target.startswith("語彙："):
            term = target.split(":", 1)[-1].split("：", 1)[-1].strip()
            if term not in vocab:
                report.error(e, "E308", f"{e.heading} の対象 語彙:{term} が語彙にない", "対象")
        elif target not in rules:
            report.error(e, "E309", f"{e.heading} の対象 {target} が存在しない", "対象")


def check_allows(entries, report):
    """抑制は理由を必須にする。理由のない抑制は穴だが、理由付きは記録された判断である。"""
    for e in entries:
        for lineno, val in e.bad_allows:
            report.raw_error(
                e,
                lineno,
                "E217",
                f"「許容: {val}」の形式が不正。`許容: <コード> <理由>` と書く（例 `許容: E212 出典の文言をそのまま用いる`）。"
                f"理由なしの抑制は認めない",
            )
        for code in e.allows:
            if code not in e.suppressed:
                report.warnings.append(
                    (
                        e.path,
                        e.allow_lines[code],
                        "W104",
                        f"許容 {code} は何も抑制していない。指摘が解消済みなら行を削除する",
                    )
                )


def check_exception_cycles(rules, report):
    color = defaultdict(int)

    def walk(rid, path):
        if color[rid] == 2:
            return
        if color[rid] == 1:
            cycle = " -> ".join(path[path.index(rid):] + [rid])
            report.error(rules[rid], "E214", f"例外元が循環している: {cycle}", "例外元")
            return
        color[rid] = 1
        src = rules[rid].fields.get("例外元")
        if src and src != "なし" and src in rules:
            walk(src, path + [rid])
        color[rid] = 2

    for rid in rules:
        if color[rid] == 0:
            walk(rid, [])


def check_coverage(rules, report):
    """例外元を持つ規則が、根まで辿れることの確認。根が複数あるのは正常。"""
    roots = [r for r, e in rules.items() if e.fields.get("例外元") in (None, "なし")]
    if rules and not roots:
        report.errors.append(("", 0, "E215", "原則となる規則（例外元: なし）が1つもない"))


SELFTEST_VOCAB = """# t

## 語彙

### 申請

- 種別: 実体
- 定義: x
"""

SELFTEST_CASES = [
    # (例外元, 規則文, 追加行, 期待コード)
    ("なし", "[申請] を 保存 しなければならない", [], []),
    ("なし", "[申請] が 有効 である間、[申請] を 保存 しなければならない", [], []),
    ("なし", "[申請] が 出されたとき、[申請] を 保存 しなければならない", [], []),
    ("なし", "[申請] を備える構成では、[申請] を 保存 しなければならない", [], []),
    ("なし", "[申請] が 壊れたならば、[申請] を 破棄 しなければならない", [], []),
    ("なし", "[申請] が 有効 である間、出されたとき、保存 しなければならない", [], []),
    ("なし", "[申請] を 保存 してはならない", [], []),
    ("なし", "[申請] は 1件 である", [], []),
    # 導出できないキーワードの組合せ
    ("なし", "[申請] が 出されたとき、壊れたならば、破棄 しなければならない", [], ["E209"]),
    ("なし", "[申請] を備える構成では、有効 である間、保存 しなければならない", [], ["E209"]),
    # 個別の検査
    ("なし", "[申請] が出された場合、保存 しなければならない", [], ["E212"]),
    ("なし", "[申請] を 保存する", [], ["E211"]),
    ("BR-X-999", "[申請] を 保存 しなければならない", [], ["E213"]),
    ("なし", "[未定義] を 保存 しなければならない", [], ["E208"]),
    ("なし", "原則として [申請] を 保存 しなければならない", [], ["E212"]),
    ("なし", "[申請] 等 を 保存 しなければならない", [], ["E212"]),
    ("なし", "[申請] を 適切に 保存 しなければならない", [], ["E212"]),
    ("なし", "申請 を 保存 しなければならない", [], ["W102"]),
    # 抑制
    (
        "なし",
        "[申請] が出された場合、保存 しなければならない",
        ["- 許容: E212 出典の規程の文言をそのまま用いる"],
        [],
    ),
    ("なし", "[申請] を 保存 しなければならない", ["- 許容: E212"], ["E217"]),
    ("なし", "[申請] を 保存 しなければならない", ["- 許容: なんとなく"], ["E217"]),
    ("なし", "[申請] を 保存 しなければならない", ["- 許容: E212 もう解消済み"], ["W104"]),
]


def selftest():
    import tempfile
    import os

    failures = 0
    for i, (source, text, extra, expected) in enumerate(SELFTEST_CASES):
        extra_lines = ("\n".join(extra) + "\n") if extra else ""
        doc = SELFTEST_VOCAB + (
            f"\n## 規則\n\n### BR-T-010 t{i}\n\n"
            f"- 例外元: {source}\n- 出典: テスト\n- 規則: {text}\n{extra_lines}"
        )
        with tempfile.NamedTemporaryFile(
            "w", suffix=".md", delete=False, encoding="utf-8"
        ) as fh:
            fh.write(doc)
            path = fh.name
        try:
            report = Report()
            check(parse([path]), report)
            got = sorted({c for _, _, c, _ in report.errors + report.warnings} - {"W101"})
        finally:
            os.unlink(path)
        want = sorted(set(expected))
        if got != want:
            failures += 1
            print(f"FAIL case {i} ({pattern}): 期待 {want} / 実際 {got}")
            print(f"     規則: {text}")
    total = len(SELFTEST_CASES)
    print(f"\nselftest: {total - failures}/{total} 通過")
    return 1 if failures else 0


def main():
    ap = argparse.ArgumentParser(description="業務規則仕様の第0段チェック")
    ap.add_argument("paths", nargs="*", help="仕様ファイル")
    ap.add_argument("--strict", action="store_true", help="警告も失敗として扱う")
    ap.add_argument("--selftest", action="store_true", help="検査規則そのものを自己検証する")
    args = ap.parse_args()

    if args.selftest:
        return selftest()
    if not args.paths:
        ap.error("仕様ファイルを指定する（または --selftest）")

    report = Report()
    entries = parse(args.paths)
    if not entries:
        print("見出し（### ）が1つも見つからない。references/spec-format.md の形式を確認する", file=sys.stderr)
        return 2

    rules = check(entries, report)
    check_coverage(rules, report)

    for path, line, code, msg in sorted(report.errors):
        loc = f"{path}:{line}" if path else "-"
        print(f"{loc}: ERROR {code} {msg}")
    for path, line, code, msg in sorted(report.warnings):
        loc = f"{path}:{line}" if path else "-"
        print(f"{loc}: WARN  {code} {msg}")

    ne, nw = len(report.errors), len(report.warnings)
    if rules:
        counts = defaultdict(int)
        for e in rules.values():
            counts[getattr(e, "pattern", None) or "判別不能"] += 1
        dist = " / ".join(f"{k} {v}" for k, v in sorted(counts.items()))
        print(f"\n導出したパターン: {dist}")
    print(f"規則 {len(rules)}件 / エラー {ne}件 / 警告 {nw}件")
    if ne or (args.strict and nw):
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
