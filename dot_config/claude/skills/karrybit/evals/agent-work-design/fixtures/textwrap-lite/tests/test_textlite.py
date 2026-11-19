import unittest

from textlite import truncate


class TruncateTest(unittest.TestCase):
    def test_short_text_unchanged(self):
        self.assertEqual(truncate("hi", 5), "hi")

    def test_cut(self):
        self.assertEqual(truncate("hello world", 5), "hello")


if __name__ == "__main__":
    unittest.main()
