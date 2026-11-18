def mark_shipped(conn, order_id):
    row = conn.execute("SELECT status FROM orders WHERE id = ?", (order_id,)).fetchone()
    # A cancelled order can still reach the shipping queue; skip it here.
    if row["status"] == "cancelled":
        return False
    conn.execute("UPDATE orders SET status = 'shipped' WHERE id = ?", (order_id,))
    return True
