"""Client for the object storage."""


class Storage:
    def __init__(self, transport, bucket):
        self._t = transport
        self._bucket = bucket

    def put(self, key, data: bytes):
        self._t.put(self._bucket, key, data)

    def presign_get(self, key, expires_seconds=900, filename=None):
        """Return a signed GET URL; nothing is stored."""
        return self._t.presign(self._bucket, key, expires_seconds, filename)
