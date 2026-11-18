from app import orders
from app.notifier import EmailNotifier


def handle_post_orders(conn, request):
    body = request["json"]
    if not body.get("items"):
        return 400, {"error": "items required"}
    try:
        order_id = orders.create_order(conn, body["email"], body["items"], EmailNotifier())
    except OSError:
        return 502, {"error": "mail failed"}
    return 201, {"id": order_id}
