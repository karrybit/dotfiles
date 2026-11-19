import unittest

from src.notify import sender


class FakeClient:
    def __init__(self):
        self.sent = []

    def send(self, to, subject, body):
        self.sent.append((to, subject, body))
        return True


class SendTest(unittest.TestCase):
    def test_welcome(self):
        client = FakeClient()
        self.assertTrue(sender.send(client, "welcome", "a@example.com", {"name": "A"}))
        self.assertEqual(client.sent[0][1], "Welcome to the shop")


if __name__ == "__main__":
    unittest.main()
