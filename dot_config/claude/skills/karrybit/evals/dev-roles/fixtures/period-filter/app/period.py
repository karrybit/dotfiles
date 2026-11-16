def rows_in_period(rows, start, end):
    """Return the rows from start to end, both ends included, oldest first."""
    picked = [row for row in rows if start <= row["occurred_at"] <= end]
    return sorted(picked, key=lambda row: row["occurred_at"])
