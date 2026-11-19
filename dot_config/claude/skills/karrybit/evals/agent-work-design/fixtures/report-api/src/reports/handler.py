"""GET /reports: return sales rows between two days."""

import json

from .store import load_rows


def parse_query(query):
    start = query.get("start")
    end = query.get("end")
    if not start or not end:
        raise ValueError("start and end are required")
    return {"start": start, "end": end}


def serialize(rows):
    return json.dumps([{"day": d, "region": r, "amount": a} for d, r, a in rows])


def handle(db, query):
    params = parse_query(query)
    rows = load_rows(db, params["start"], params["end"])
    return 200, {"Content-Type": "application/json"}, serialize(rows)
