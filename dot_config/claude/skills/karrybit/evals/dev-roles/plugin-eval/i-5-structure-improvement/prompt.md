---
max_turns: 60
timeout_seconds: 1800
allowed_tools: [Read, Glob, Grep, Skill, Agent, Bash, Write, Edit]
plugins: ["../../../..", "../../../../vendor/mattpocock-skills"]
tags: [implementation]
---

このリポジトリのレポートの出力の構造を直してほしい。振る舞いは変えない。

- 目的: 呼び出し側が、レポートの出力を 1 回の呼び出しで行えるようにする。
- 関わる要求:
  - AC-1: `app/cli.py` の `main` と `app/export.py` の `export_daily` が書くファイルの中身と戻り値は、変更の前と同じ。
- 設計の制約: なし
- 今回の範囲: 触ってよいのは `app/` と `tests/` だけ。
- 確かめる条件: `python3 -m unittest discover -s tests -t .` が通り、呼び出し側が `ReportService`・`Formatter`・`Writer` を組み立てずに済む。

commit はせず、変更は作業ツリーに残して。終わったら、何をしてどう確かめたかを報告して。

この仕事は karrybit:implementer の Agent に頼み、返ってきた報告を手を加えずにそのまま最後の返事にして。その Agent を使えなければ、自分で行って同じように報告して。
