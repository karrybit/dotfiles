STATUSES = ["pending", "paid", "shipped", "cancelled", "expired"]


def cancel_order(conn, order_id):
    row = conn.execute("SELECT status FROM orders WHERE id = ?", (order_id,)).fetchone()
    if row["status"] in ("shipped", "cancelled", "expired"):
        raise ValueError("cannot cancel")
    conn.execute("UPDATE orders SET status = 'cancelled' WHERE id = ?", (order_id,))
