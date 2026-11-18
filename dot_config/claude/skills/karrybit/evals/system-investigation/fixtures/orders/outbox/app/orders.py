import json

from app.pricing import calc_total


def create_order(conn, customer_email, items):
    total = calc_total(items)
    with conn:
        cur = conn.execute(
            "INSERT INTO orders (customer_email, total, status) VALUES (?, ?, 'pending')",
            (customer_email, total),
        )
        order_id = cur.lastrowid
        conn.execute(
            "INSERT INTO outbox (event_type, payload) VALUES ('order.created', ?)",
            (json.dumps({"order_id": order_id}),),
        )
    return order_id
