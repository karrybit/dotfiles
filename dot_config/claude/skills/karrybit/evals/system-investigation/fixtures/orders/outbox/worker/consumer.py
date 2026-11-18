def handle_message(conn, message, notifier):
    event_id = message["event_id"]
    with conn:
        seen = conn.execute(
            "SELECT 1 FROM processed_events WHERE event_id = ?", (event_id,)
        ).fetchone()
        if seen:
            return "duplicate"
        order = conn.execute(
            "SELECT id, customer_email FROM orders WHERE id = ?", (message["order_id"],)
        ).fetchone()
        conn.execute("UPDATE orders SET status = 'confirmed' WHERE id = ?", (order["id"],))
        conn.execute("INSERT INTO processed_events (event_id) VALUES (?)", (event_id,))
    notifier.send_confirmation(order["customer_email"], order["id"])
    return "confirmed"
