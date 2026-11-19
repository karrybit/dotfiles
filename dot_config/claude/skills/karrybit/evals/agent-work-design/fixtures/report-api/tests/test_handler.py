import unittest

from src.reports import handler


class FakeDB:
    def query(self, sql, args):
        return [("2026-01-01", "east", 100)]


class HandleTest(unittest.TestCase):
    def test_json(self):
        status, headers, body = handler.handle(FakeDB(), {"start": "2026-01-01", "end": "2026-01-31"})
        self.assertEqual(status, 200)
        self.assertIn("east", body)


if __name__ == "__main__":
    unittest.main()
