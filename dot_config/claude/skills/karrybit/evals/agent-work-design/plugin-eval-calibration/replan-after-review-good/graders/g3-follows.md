---
type: llm
focus: { source: file, path: plan.md }
---
Facts about the fixture. `plan.md` had four goals. G2 added a `search_text` column to the `products` table; G3, which depends on G2, switched `src/search.py` to read `products.search_text`; G1 (measure slow queries) and G4 (rewrite the search guide) depend on nothing. `review.md` says that `products` belongs to another team and the service may only read it, and that instead a search-only `search_index` table is to be created in the service's own database and filled from `products` every 10 minutes.

The text under judgment is `plan.md` after the run.

PASS if G2 (or the goals that replace it) builds the `search_index` table and its 10-minute copy from `products` without changing `products`, and G3 now reads `search_index` instead of `products.search_text` and still depends on the goal or goals that build `search_index`.

FAIL if G3 still reads `products.search_text`, if G3 no longer depends on the goal that builds `search_index`, or if the plan still adds a column to `products`.
