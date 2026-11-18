import os
import tempfile
import unittest

from app import cli, export


class ReportTest(unittest.TestCase):
    def test_cli_writes_csv(self):
        with tempfile.TemporaryDirectory() as d:
            p = os.path.join(d, "r.csv")
            cli.main([[1, "a"], [2, "b"]], p)
            self.assertEqual(open(p).read(), "1,a\n2,b")

    def test_export_returns_length(self):
        with tempfile.TemporaryDirectory() as d:
            p = os.path.join(d, "r.csv")
            self.assertEqual(export.export_daily([[1, "a"]], p), 3)


if __name__ == "__main__":
    unittest.main()
