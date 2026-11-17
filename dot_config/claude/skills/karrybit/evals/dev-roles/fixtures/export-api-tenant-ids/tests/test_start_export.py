import unittest

from app.authz import Session
from app.errors import PermissionDenied
from app.exports import start_export
from app.store import ExportStore


class StartExportTest(unittest.TestCase):
    def test_owner_starts_an_export(self):
        store = ExportStore()
        export = start_export(store, Session("u1", "t1", "owner"), "t1")
        self.assertEqual(store.get("t1", export.export_id), export)
        self.assertEqual(export.state, "RUNNING")

    def test_ids_are_counted_per_tenant(self):
        store = ExportStore()
        first_t1 = start_export(store, Session("u1", "t1", "owner"), "t1")
        first_t2 = start_export(store, Session("u2", "t2", "owner"), "t2")
        self.assertEqual((first_t1.export_id, first_t2.export_id), ("1", "1"))

    def test_member_is_denied(self):
        with self.assertRaises(PermissionDenied):
            start_export(ExportStore(), Session("u1", "t1", "member"), "t1")


if __name__ == "__main__":
    unittest.main()
