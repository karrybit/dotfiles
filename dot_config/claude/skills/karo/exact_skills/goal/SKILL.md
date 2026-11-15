---
name: goal
description: 'オーナーが渡した goal を Agent に委任して、goal ごとに別の Agent のセッションの /goal を動かす手順。完了の条件は karrybit:goal に書かせる。オーナーが /karo:goal を打ったとき、「goal: 〇〇」の形で完了まで続けてほしい作業を渡したときに、karrybit:goal の代わりに使う（この skill が karrybit:goal を呼ぶ）。'
---

# goal を Agent に渡す

- goal は、完了の条件を満たすまで Agent が自律でターンを続ける作業。
- Claude Code の `/goal` は、条件を満たすまでそのセッションをふさぎ、1 セッションに 1 つしか持てない（https://code.claude.com/docs/en/goal.md）。
- そのため、AGENTS.md の「委任・レビュー・Checkin・Checkout」のとおり、1 つの goal を 1 つの Agent に渡し、その Agent のセッションで `/goal` を動かす。

## 手順

1. `karrybit:goal` skill を Skill tool で呼び、オーナーの依頼の原文を渡して、その手順を最後まで進める。返った goal ごとに、完了の条件は 2 の `--goal` とブリーフの受け入れ条件に、行き詰まりの扱いはブリーフの制約に使う。止めた goal は、その goal の委任を止めて、確かめることを AskUserQuestion でオーナーに尋ねる（ほかの goal は進めてよい）。
   完了条件: 委任する goal のすべてに、`karrybit:goal` が返した完了の条件と行き詰まりの扱いがあり、止めた goal のすべてをオーナーに尋ねている。
2. goal ごとに、`karo:delegate` skill の「新しいタスクを委任する」の手順で委任する。手順との違いは次の 3 つ。
   - タスク ID は goal ごとに 1 つ作る。
   - ブリーフの受け入れ条件は、1 の完了の条件にする。
   - `agent-ctl start` のすぐあとに `--goal "<完了の条件>"` を付ける（例: `<scripts>/agent-ctl start --goal "<完了の条件>" <タスクID> <ブリーフ> <場所>`。`<scripts>` と受け付ける条件の形は `karo:delegate` skill の冒頭と `karrybit:herdr-agent` の「起動する」にある）。

   完了条件: どの goal も、`start` の JSON の `goal` が `sent` で、`status` が `working`。
3. `goal` が `not_sent` なら（ブリーフで承認のダイアログが出たときなど）、`karrybit:herdr-agent` の「止まった Agent に答える」で、AGENTS.md の「Herdr の操作」のとおり CoS が答えるかオーナーに尋ねる。答えを送って Agent が `blocked` でなくなったら、`<scripts>/agent-ctl send --goal "<完了の条件>" <タスクID>` を単独で送る。
   完了条件: どの goal も、`send` の JSON の `goal` が `sent` か、画面の内容を AskUserQuestion でオーナーに尋ねている。
4. どの Agent も、`karo:delegate` skill の「終わるのを待つ」で待つ。終わったら `karo:review` skill に進む。
   完了条件: どの Agent も、background の agent-report が走っているか、`karo:review` skill に進んでいる。
