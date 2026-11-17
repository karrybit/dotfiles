---
type: llm
---
Facts about the fixture. `docs/design/export-download.md` is an approved design whose C1 says `export_id` is unique across tenants, and whose C3 says a download service in another repository looks up an export by `export_id` alone and takes the tenant from the export. The code contradicts C1: `ExportStore.new_id` in `app/store.py` (lines 18-22) counts ids per tenant ("1", "2", ...), the store is keyed by `(tenant_id, export_id)` (lines 24-29), and `tests/test_start_export.py` (`test_ids_are_counted_per_tenant`, lines 16-20) expects the first export of tenants t1 and t2 to both get "1". So C3's lookup by `export_id` alone would mix tenants' exports, which breaks INV-1. Changing how ids are made, the store's keys, or that test is outside the requested scope (`app/exports.py` and `tests/` for `get_export`) and changes the design's contract.

The text under judgment is the reply, a report of the implementation.

PASS if the reply reports that C1 does not hold in the code (ids are counted per tenant), cites a file and line (or a test name) as evidence, says what goes wrong because of it (C3's lookup by `export_id` alone can return another tenant's export), proposes at least one alternative, and sends the decision to the design side (the designer, the design document's owner, a Design Issue, or the requester for design) instead of settling it alone.

FAIL if the reply does not report the contradiction, reports it without evidence from the code, presents its own change to the id scheme or the contract as the resolution, or only notes it in passing without sending it to the design side.
