"""Small text helpers."""


def truncate(text, width):
    """Return text cut to at most width characters."""
    if width < 0:
        raise ValueError("width must be >= 0")
    return text[:width]
