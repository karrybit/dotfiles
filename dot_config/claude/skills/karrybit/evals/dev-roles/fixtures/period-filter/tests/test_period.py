import unittest
from datetime import datetime, timezone

from app.period import rows_in_period


def at(day, hour=0):
    return datetime(2026, 11, day, hour, tzinfo=timezone.utc)


ROWS = [
    {"event_id": "e1", "occurred_at": at(10)},
    {"event_id": "e2", "occurred_at": at(10, 12)},
    {"event_id": "e3", "occurred_at": at(11)},
    {"event_id": "e0", "occurred_at": at(9, 23)},
]


class RowsInPeriodTest(unittest.TestCase):
    def test_rows_in_one_day(self):
        picked = rows_in_period(ROWS, at(10), at(11))
        self.assertEqual([row["event_id"] for row in picked], ["e1", "e2"])

    def test_oldest_first(self):
        picked = rows_in_period(ROWS, at(9), at(10, 13))
        self.assertEqual([row["event_id"] for row in picked], ["e0", "e1", "e2"])


if __name__ == "__main__":
    unittest.main()
