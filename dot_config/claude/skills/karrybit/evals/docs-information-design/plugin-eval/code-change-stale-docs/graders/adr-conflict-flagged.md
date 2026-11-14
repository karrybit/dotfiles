---
type: llm
---
Facts about the repository: ADR 0003 (docs/adr/0003-database-url-env.md) records the decision to read the database URL from `SHIPIT_DB_URL`. The code change in CHANGES.diff makes shipit read `DATABASE_URL` instead, so the change contradicts that recorded decision.
PASS if the response tells the user that ADR 0003's decision is superseded by, or conflicts with, the change, or says that it marked ADR 0003 as superseded.
FAIL if the response does not mention ADR 0003's relation to the change, or says only that the ADR was updated to the new variable without noting that its decision was superseded.
