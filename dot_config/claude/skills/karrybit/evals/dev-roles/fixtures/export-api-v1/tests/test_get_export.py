import unittest

from app.authz import Session
from app.errors import NotFound, PermissionDenied
from app.exports import get_export, start_export
from app.store import ExportStore

OWNER = Session("u1", "t1", "owner")


class GetExportTest(unittest.TestCase):
    def test_owner_gets_own_export(self):
        store = ExportStore()
        export = start_export(store, OWNER, "t1")
        self.assertEqual(get_export(store, OWNER, "t1", export.export_id), export)

    def test_missing_export_is_not_found(self):
        with self.assertRaises(NotFound):
            get_export(ExportStore(), OWNER, "t1", "missing")

    def test_other_tenant_is_denied(self):
        store = ExportStore()
        export = start_export(store, Session("u2", "t2", "owner"), "t2")
        with self.assertRaises(PermissionDenied):
            get_export(store, OWNER, "t2", export.export_id)


if __name__ == "__main__":
    unittest.main()
