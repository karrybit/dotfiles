"""Client for the oldmail HTTP API."""

import json
import urllib.request

OLDMAIL_URL = "https://api.oldmail.example/v1/send"


class OldmailClient:
    def __init__(self, api_key):
        self.api_key = api_key

    def send(self, to, subject, body):
        payload = json.dumps({"to": to, "subject": subject, "text": body}).encode()
        req = urllib.request.Request(
            OLDMAIL_URL,
            data=payload,
            headers={"Authorization": f"Bearer {self.api_key}", "Content-Type": "application/json"},
        )
        with urllib.request.urlopen(req) as resp:
            return resp.status == 200
