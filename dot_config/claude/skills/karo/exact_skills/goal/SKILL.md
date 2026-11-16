---
name: goal
description: 'オーナーが渡した goal を Agent に委任して、goal ごとに別の Agent のセッションの /goal を動かす手順。完了の条件は karrybit:goal に書かせる。オーナーが /karo:goal を打ったとき、「goal: 〇〇」の形で完了まで続けてほしい作業を渡したときに、karrybit:goal の代わりに使う（この skill が karrybit:goal を呼ぶ）。'
---

# goal を Agent に渡す

- `karo:delegate` skill を Skill tool で呼び、オーナーの依頼の原文を持って、その「goal を渡す」の節の手順を最後まで進める。
