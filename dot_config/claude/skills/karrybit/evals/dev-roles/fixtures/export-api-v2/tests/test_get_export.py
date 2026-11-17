import unittest

from app.authz import Session
from app.errors import NotFound, PermissionDenied
from app.exports import get_export, start_export
from app.store import ExportStore

OWNER = Session("u1", "t1", "owner")


class UnreadableStore(ExportStore):
    """A store that fails the test when get_export reads it before authorizing."""

    def get(self, export_id):
        raise AssertionError("get_export read the store before authorizing")


class GetExportTest(unittest.TestCase):
    def test_owner_gets_own_export(self):
        store = ExportStore()
        export = start_export(store, OWNER, "t1")
        self.assertEqual(get_export(store, OWNER, "t1", export.export_id), export)

    def test_missing_export_is_not_found(self):
        with self.assertRaises(NotFound):
            get_export(ExportStore(), OWNER, "t1", "missing")

    def test_other_tenants_export_is_not_found(self):
        store = ExportStore()
        other = start_export(store, Session("u2", "t2", "owner"), "t2")
        with self.assertRaises(NotFound):
            get_export(store, OWNER, "t1", other.export_id)

    def test_other_tenant_id_is_denied_before_reading(self):
        with self.assertRaises(PermissionDenied):
            get_export(UnreadableStore(), OWNER, "t2", "any")

    def test_member_is_denied_before_reading(self):
        with self.assertRaises(PermissionDenied):
            get_export(UnreadableStore(), Session("u3", "t1", "member"), "t1", "any")


if __name__ == "__main__":
    unittest.main()
