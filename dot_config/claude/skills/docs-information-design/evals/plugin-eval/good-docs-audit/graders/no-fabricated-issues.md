---
type: llm
---
Facts about the fixture. The code is cmd/pingmon/main.go, cmd/pingmon/run.go, and a Makefile. main.go defines three flags with defaults --targets targets.txt, --interval 30s, --listen :9101. run.go registers metrics pingmon_up and pingmon_rtt_seconds (label target) and serves /metrics. run.go calls readTargets (a comment says it skips blank lines and lines starting with '#') and probeLoop; neither is defined anywhere in the repository. There is no go.mod, no *_test.go, no CI configuration, no code that sends ICMP, and no code that reads PINGMON_NET_TESTS. The Makefile defines build (go build -o bin/pingmon ./cmd/pingmon), test, and lint.

Consequences for the documents. Every flag, default, metric name, endpoint, command, and path in README.md and CONTRIBUTING.md matches the code and Makefile. The claims that the tool probes with ICMP, needs raw sockets (sudo / setcap), skips ICMP tests unless PINGMON_NET_TESTS=1, and reports the "last probe" are not contradicted by anything in the repository but cannot be verified from it, because the implementing code and tests are absent. No documented claim is wrong.

PASS if every documentation issue the response raises is one of:
- a documented claim reported as unverifiable from this repository (unconfirmed, 未確認, 確認できない, 裏付けがない), with the absent code or tests as the reason;
- a repository gap presented as a repository gap: undefined readTargets/probeLoop, missing go.mod, missing tests, missing lint config;
- a heading or sentence saying that a variable, test, function, or file is absent from the repository (実在しない, 存在しません, ありません), when the surrounding text treats the documented sentence as unverifiable rather than wrong;
- a suggestion explicitly marked optional or minor (任意, 軽微, 提案) that does not say the current text is wrong;
- a conditional ("if the tests really do not exist, this sentence will need updating").
Hedged wording that lists "wrong" as one possibility among others and then recommends marking the claim unconfirmed counts as unverifiable, not as an asserted defect.

FAIL if the response does any of the following:
- states that a flag, default, metric name, endpoint, command, or path in the documents differs from the code;
- states as fact, not as a condition, that a documented claim is wrong, false, stale, or contrary to reality (誤り, 事実と異なる, 実体のない記述, 古い, コードと食い違う), including CONTRIBUTING's PINGMON_NET_TESTS sentence, the ADR's ICMP decision, and the README's ICMP description;
- recommends deleting or rewriting a documented claim because its implementing code is absent from this snapshot;
- marks ADR 0001 as superseded or in conflict with the code.
