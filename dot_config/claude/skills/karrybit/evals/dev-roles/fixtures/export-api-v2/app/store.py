from dataclasses import dataclass


@dataclass
class Export:
    export_id: str
    tenant_id: str
    state: str  # RUNNING, SUCCEEDED, or FAILED


class ExportStore:
    """Holds every tenant's exports, keyed by export_id."""

    def __init__(self):
        self._exports = {}

    def add(self, export):
        self._exports[export.export_id] = export

    def get(self, export_id):
        """Return the export, or None when there is none."""
        return self._exports.get(export_id)
