import unittest

from app.authz import Session
from app.errors import PermissionDenied
from app.exports import start_export
from app.store import ExportStore


class StartExportTest(unittest.TestCase):
    def test_owner_starts_an_export(self):
        store = ExportStore()
        export = start_export(store, Session("u1", "t1", "owner"), "t1")
        self.assertEqual(store.get(export.export_id), export)
        self.assertEqual(export.state, "RUNNING")

    def test_member_is_denied(self):
        with self.assertRaises(PermissionDenied):
            start_export(ExportStore(), Session("u1", "t1", "member"), "t1")


if __name__ == "__main__":
    unittest.main()
