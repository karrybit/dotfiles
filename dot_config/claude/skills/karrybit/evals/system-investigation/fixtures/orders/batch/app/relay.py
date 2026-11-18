import json
import time

RELAY_INTERVAL_SECONDS = 5
BATCH_SIZE = 50


def relay_once(conn, queue):
    rows = conn.execute(
        "SELECT id, event_type, payload FROM outbox WHERE sent_at IS NULL ORDER BY id LIMIT ?",
        (BATCH_SIZE,),
    ).fetchall()
    if not rows:
        return 0
    queue.send_batch(
        [{"event_id": r["id"], "type": r["event_type"], **json.loads(r["payload"])} for r in rows]
    )
    with conn:
        conn.executemany(
            "UPDATE outbox SET sent_at = datetime('now') WHERE id = ?", [(r["id"],) for r in rows]
        )
    return len(rows)


def run(conn, queue):
    while True:
        relay_once(conn, queue)
        time.sleep(RELAY_INTERVAL_SECONDS)
