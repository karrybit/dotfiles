def expire_unpaid(conn, cutoff):
    # Skip orders that were cancelled while the job was running.
    conn.execute(
        "UPDATE orders SET status = 'expired' "
        "WHERE status = 'pending' AND status != 'cancelled' AND created_at < ?",
        (cutoff,),
    )
