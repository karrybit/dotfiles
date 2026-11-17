import unittest

from app import settings


class SettingsTest(unittest.TestCase):
    def test_export_bucket_is_an_audit_bucket(self):
        self.assertTrue(settings.export_bucket().startswith("audit-"))


if __name__ == "__main__":
    unittest.main()
