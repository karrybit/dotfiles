from dataclasses import dataclass


@dataclass
class Export:
    export_id: str
    tenant_id: str
    state: str  # RUNNING, SUCCEEDED, or FAILED


class ExportStore:
    """Holds every tenant's exports, keyed by (tenant_id, export_id)."""

    def __init__(self):
        self._exports = {}
        self._last_id = {}

    def new_id(self, tenant_id):
        """Return the tenant's next export_id: "1", "2", ... counted per tenant."""
        n = self._last_id.get(tenant_id, 0) + 1
        self._last_id[tenant_id] = n
        return str(n)

    def add(self, export):
        self._exports[(export.tenant_id, export.export_id)] = export

    def get(self, tenant_id, export_id):
        """Return the tenant's export, or None when there is none."""
        return self._exports.get((tenant_id, export_id))
