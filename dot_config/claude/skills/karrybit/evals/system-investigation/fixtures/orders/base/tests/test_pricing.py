import unittest
from decimal import Decimal

from app.pricing import calc_total


class CalcTotalTest(unittest.TestCase):
    def test_discount_drops_fraction(self):
        self.assertEqual(calc_total([(999, 1)], Decimal("0.1")), 899)


if __name__ == "__main__":
    unittest.main()
