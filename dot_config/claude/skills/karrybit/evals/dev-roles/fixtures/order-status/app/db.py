SCHEMA = """
CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    status TEXT NOT NULL,          -- pending, paid, shipped, cancelled, expired
    payment_id TEXT,
    created_at TEXT NOT NULL
);
"""
