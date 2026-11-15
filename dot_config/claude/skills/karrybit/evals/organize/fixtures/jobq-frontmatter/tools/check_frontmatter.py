"""Check the frontmatter rules in docs/FRONTMATTER.md for one file."""

import sys

AUDIENCES = {"user", "operator", "developer"}


def main(path):
    lines = open(path, encoding="utf-8").read().split("\n")
    if not lines or lines[0] != "---" or "---" not in lines[1:]:
        print(f"{path}: no frontmatter")
        return 1
    end = lines.index("---", 1)
    fields = dict(line.split(": ", 1) for line in lines[1:end] if ": " in line)
    problems = []
    if not fields.get("title"):
        problems.append("missing title")
    if fields.get("audience") not in AUDIENCES:
        problems.append("audience must be one of " + ", ".join(sorted(AUDIENCES)))
    for problem in problems:
        print(f"{path}: {problem}")
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1]))
