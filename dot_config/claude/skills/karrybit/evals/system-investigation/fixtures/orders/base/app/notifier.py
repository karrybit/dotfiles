import json
import urllib.request

from config import settings


class EmailNotifier:
    def __init__(self, url=settings.MAIL_API_URL):
        self.url = url

    def send_confirmation(self, email, order_id):
        body = json.dumps({"to": email, "template": "order-confirmed", "order_id": order_id})
        req = urllib.request.Request(self.url, data=body.encode(), method="POST")
        with urllib.request.urlopen(req, timeout=5) as resp:
            return resp.status
