import json
import time

RELAY_INTERVAL_SECONDS = 5


def relay_once(conn, queue):
    rows = conn.execute(
        "SELECT id, event_type, payload FROM outbox WHERE sent_at IS NULL ORDER BY id"
    ).fetchall()
    for row in rows:
        queue.send({"event_id": row["id"], "type": row["event_type"], **json.loads(row["payload"])})
        with conn:
            conn.execute("UPDATE outbox SET sent_at = datetime('now') WHERE id = ?", (row["id"],))
    return len(rows)


def run(conn, queue):
    while True:
        relay_once(conn, queue)
        time.sleep(RELAY_INTERVAL_SECONDS)
