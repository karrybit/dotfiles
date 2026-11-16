"""Make URL slugs from titles."""

import re


def slugify(title: str) -> str:
    """Lowercase ASCII words joined by '-'."""
    words = re.findall(r"[a-z]+", title.lower())
    return "-".join(words)
