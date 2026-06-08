# waxa Eval 実行ガイド

waxa (`@mizchi/waxa`) を使って user-global skill を評価・改善する際の手順と注意点。

- Source: https://github.com/mizchi/skills/tree/main/tools/waxa
- Checked: 2026-06-09 (waxa-src v0.3.1 / Deno native)

---

## 前提条件

### npm 版は使用不可

`@mizchi/waxa` npm パッケージ (v0.1.1) は Node.js 上で `dntShim.Deno.Command is not a constructor` エラーが発生し、LLM グレーダーが動作しない。

**Deno ネイティブソースを使う**:

- ソース: `~/.local/share/agents/tools/waxa-src/tools/waxa/src/cli.ts`
- ラッパー: `~/.local/bin/waxa-deno` (chezmoi 管理済み)

waxa-src は chezmoi 管理外の独立した git リポジトリ。最新化する場合:

```bash
cd ~/.local/share/agents/tools/waxa-src && git pull
```

---

## サンドボックス制限（最重要）

waxa は内部で `claude -p` をサブプロセスとして呼ぶ。`claude -p` の SessionEnd hook が `~/.config/claude/projects/...` に書き込もうとするが、Claude Code のデフォルトサンドボックスがこの書き込みをブロックする。

**症状**:
- 全グレーダーが 0%
- `judge-error: claude exit 1`
- `self-report: (not extracted)`
- 実行時間が数秒で終わる（正常時は数分）

**対策**: Claude Code の Bash ツールから実行する場合は必ず `dangerouslyDisableSandbox: true` を指定する。

---

## 実行コマンド

```bash
# skill ディレクトリに移動して実行
cd ~/.local/share/skills/<skill-name>
deno run -A ~/.local/share/agents/tools/waxa-src/tools/waxa/src/cli.ts evals/eval.yaml

# または waxa-deno ラッパー経由
~/.local/bin/waxa-deno evals/eval.yaml
```

複数スキルを並行実行する場合:

```bash
WAXA_SRC="${HOME}/.local/share/agents/tools/waxa-src/tools/waxa"
run_skill() {
  local name="$1"
  local dir="${HOME}/.local/share/skills/${name}"
  cd "$dir" && deno run -A "${WAXA_SRC}/src/cli.ts" evals/eval.yaml 2>&1 \
    | grep "^Overall pass rate"
}
run_skill agent-architecture-audit &
run_skill cli-creator &
wait
```

---

## ファイル構造

```
~/.local/share/skills/<skill-name>/
├── SKILL.md
├── evals/
│   ├── eval.yaml              # eval 定義
│   ├── ledger.yaml            # 収束状況の記録
│   └── tasks/
│       ├── scenario-typical.yaml   # 典型ケース
│       └── scenario-edge.yaml      # エッジケース / 非発火ケース
```

`results/` ディレクトリはランタイム出力なので gitignore 済み
(`dot_local/share/skills/.gitignore` に `results/` を記載)。

### eval.yaml 例

```yaml
id: my-skill-eval
skill_body: SKILL.md
layout: skill-local
tasks:
  - evals/tasks/scenario-typical.yaml
  - evals/tasks/scenario-edge.yaml
```

---

## task YAML 形式 (waxa 0.3.1)

```yaml
id: scenario-typical
description: |
  シナリオ説明

inputs:
  prompt: |
    ユーザープロンプト本文。
    Note: Real network fetches and external command execution are unavailable
    in this evaluation context; narrate the workflow you would follow.

graders:
  - name: self_report_check
    type: self-report
    config:
      max_unclear: 1

  - name: surface_check
    type: text
    config:
      regex_match:
        - "(?i)(pattern1|pattern2)"
      regex_not_match:
        - "(?i)(bad_pattern)"

  - name: llm_rubric
    type: llm
    config:
      rubric: |
        評価基準を記述する。
        Score PASS if <条件>.
```

---

## YAML 記述の落とし穴

| 症状 | 原因 | 対処 |
|------|------|------|
| `TypeError: Cannot read properties of undefined (reading 'prompt')` | top-level に `prompt:` を書いた | `inputs:\n  prompt:` に変更 |
| `negate: true` が効かず常に PASS | waxa が未サポート | `regex_not_match` を使用 |
| ダブルクォート YAML 文字列内の `\.` でエラー | YAML のエスケープ衝突 | `.` のままにする（正規表現でも機能する） |
| YAML SyntaxError: `missing colon` | リスト項目中の `: ` が mapping として解釈 | ブロックスカラー (`|`) かシングルクォートで囲む |
| `regex_match` の複数パターンが全部 fail | AND ロジック（全パターンが一致必要） | パターンを分割し独立したグレーダーにする |
| 長いチェーン正規表現 `.{0,N}` が不安定 | パターンが長すぎて表現が届かない | `{0,N}` の N を大きくするか独立パターンに分割 |

---

## 4ステージ反復パターン

| Stage | 症状 | 診断 | 対処 |
|-------|------|------|------|
| 1. Structural fix | LLM + surface 両方失敗 | SKILL.md に必要な手順が欠落 | SKILL.md に手順・例・分類ルールを追加 |
| 2. Grader breadth | LLM pass、surface fail（同軸） | モデルは正解だが regex が狭い | alternation 拡張・`{0,N}` の N を増やす |
| 3. Surface-form coverage | 一部パターンだけ fail | 英語/日本語/略語の揺れ | バリアント・同義語を追加 |
| 4. Residual | ネットワーク制約など構造的 | eval 環境の制限 | ledger に記録して終了 |

### グレーダーペアの原則

各評価軸に `text`（正規表現）と `llm`（意味判定）を対にする。

- LLM pass + surface fail → Stage 2（regex が狭い）
- LLM fail + surface pass → Stage 1 の可能性（モデルが指示通りに動いていない）
- 両方 fail → Stage 1（SKILL.md の構造的問題）

---

## プロンプトの推奨パターン

ネットワーク・外部コマンドが使えない eval 環境では、プロンプトにその旨を明記する:

```
Note: Real network fetches and external command execution are unavailable
in this evaluation context; narrate the workflow you would follow and
describe the commands you would run, with expected outputs.
```

---

## 収束状況の記録 (ledger.yaml)

```yaml
iterations:
  - id: iter-1
    date: 2026-06-09
    overall_pass_rate: 75%
    actions:
      - widened regex alternation in failure_capture_surface
convergence:
  status: converged   # converged | near_convergence | converging
  rationale: |
    全グレーダー pass。残留 unclear なし。
```
