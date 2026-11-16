import unittest

from slug import slugify


class SlugifyTest(unittest.TestCase):
    def test_words_are_joined(self):
        self.assertEqual(slugify("Hello World"), "hello-world")

    def test_punctuation_is_dropped(self):
        self.assertEqual(slugify("Hello, World!"), "hello-world")


if __name__ == "__main__":
    unittest.main()
