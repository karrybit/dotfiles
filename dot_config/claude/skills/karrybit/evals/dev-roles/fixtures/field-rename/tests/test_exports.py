import unittest

from app.exports import export_summary


class ExportSummaryTest(unittest.TestCase):
    def test_keys(self):
        export = {"id": "e1", "status": "done", "created_at": "2026-11-01T00:00:00Z", "rows": 10}
        self.assertEqual(
            export_summary(export),
            {"id": "e1", "status": "done", "created_at": "2026-11-01T00:00:00Z"},
        )


if __name__ == "__main__":
    unittest.main()
