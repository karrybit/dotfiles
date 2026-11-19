---
type: llm
---
Facts about the run. The user wants three changes to `report-api`, one per agent, as parallel as possible, and asked for an assignment, an order, and merge points without delegating yet. (a) adds `format=csv` to `GET /reports`; (b) adds paging with `limit` and `cursor` to `GET /reports`. In the repository both (a) and (b) must change the same functions `parse_query` and `handle` in `src/reports/handler.py` and the same `/reports` parameter list in `openapi.yaml`, the public contract that client teams generate code from. (c) only creates a new file `docs/guide.en.md`, a translation of `docs/guide.ja.md`.

The response is the final message to the user.

PASS if the design does not let (a) and (b) edit `handler.py` and `openapi.yaml` at the same time without coordination: it either runs (a) and (b) one after the other, or first settles the shared part (the `/reports` query parameters in `openapi.yaml`, or the parameter parsing in `handler.py`) in one step owned by one agent before the two split. It also names where (a) and (b) are merged and who integrates or checks them together.

FAIL if (a) and (b) start in parallel, each editing `handler.py` or `openapi.yaml`, with only separate branches or worktrees and no ordering or contract-first step; or if the design names no merge point or no one who integrates (a) and (b).
