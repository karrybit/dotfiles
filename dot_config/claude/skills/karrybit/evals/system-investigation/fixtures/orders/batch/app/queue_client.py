import json
import urllib.request

from config import settings


class QueueClient:
    def __init__(self, url=settings.ORDER_QUEUE_URL):
        self.url = url

    def send_batch(self, messages):
        req = urllib.request.Request(
            self.url + "/messages:batch", data=json.dumps(messages).encode(), method="POST"
        )
        with urllib.request.urlopen(req, timeout=5) as resp:
            return resp.status
