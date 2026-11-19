"""Read report rows."""


def load_rows(db, start, end):
    return db.query(
        "SELECT day, region, amount FROM sales WHERE day BETWEEN ? AND ? ORDER BY day, region",
        (start, end),
    )
