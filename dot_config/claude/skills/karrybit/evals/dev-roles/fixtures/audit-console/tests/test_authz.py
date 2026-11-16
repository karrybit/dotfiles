import unittest

from app.authz import PermissionDenied, Session, authorize_tenant_access


class AuthorizeTenantAccessTest(unittest.TestCase):
    def test_owner_of_tenant_passes(self):
        authorize_tenant_access(Session("u1", "t1", "owner"), "t1")

    def test_other_tenant_is_denied(self):
        with self.assertRaises(PermissionDenied):
            authorize_tenant_access(Session("u1", "t1", "owner"), "t2")

    def test_member_is_denied(self):
        with self.assertRaises(PermissionDenied):
            authorize_tenant_access(Session("u1", "t1", "member"), "t1")


if __name__ == "__main__":
    unittest.main()
