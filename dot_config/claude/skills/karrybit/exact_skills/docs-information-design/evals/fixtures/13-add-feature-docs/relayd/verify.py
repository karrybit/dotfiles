import hashlib
import hmac


def verify(route, headers, body):
    """Reject the request unless its HMAC signature matches.

    Enabled per route by `verify.secret_env`. During rotation both
    `verify.secret_env` and `verify.previous_secret_env` are accepted.
    """
    cfg = route.get("verify")
    if not cfg:
        return True
    header = cfg.get("header", "X-Hub-Signature-256")
    sent = headers.get(header, "").removeprefix("sha256=")
    for env in (cfg["secret_env"], cfg.get("previous_secret_env")):
        secret = route.env(env) if env else None
        if secret and hmac.compare_digest(
            hmac.new(secret.encode(), body, hashlib.sha256).hexdigest(), sent
        ):
            return True
    return False  # caller responds 401 and does not forward or retry
