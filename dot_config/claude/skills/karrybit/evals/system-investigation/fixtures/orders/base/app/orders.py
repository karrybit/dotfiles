from app.pricing import calc_total


def create_order(conn, customer_email, items, notifier):
    total = calc_total(items)
    with conn:
        cur = conn.execute(
            "INSERT INTO orders (customer_email, total, status) VALUES (?, ?, 'confirmed')",
            (customer_email, total),
        )
    order_id = cur.lastrowid
    notifier.send_confirmation(customer_email, order_id)
    return order_id
