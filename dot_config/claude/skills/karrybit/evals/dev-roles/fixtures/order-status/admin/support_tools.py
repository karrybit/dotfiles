ALLOWED = ["pending", "paid", "shipped", "cancelled", "expired"]


def force_status(conn, order_id, status):
    if status not in ALLOWED:
        raise ValueError(status)
    if status == "shipped":
        row = conn.execute("SELECT status FROM orders WHERE id = ?", (order_id,)).fetchone()
        if row["status"] == "cancelled":
            raise ValueError("cancelled order cannot be shipped")
    conn.execute("UPDATE orders SET status = ? WHERE id = ?", (status, order_id))
