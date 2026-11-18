from decimal import Decimal, ROUND_DOWN


def calc_total(items, discount_rate=Decimal("0")):
    """items: [(unit_price_yen, quantity)]"""
    subtotal = sum(Decimal(price) * qty for price, qty in items)
    discounted = subtotal * (Decimal("1") - discount_rate)
    return int(discounted.quantize(Decimal("1"), rounding=ROUND_DOWN))
