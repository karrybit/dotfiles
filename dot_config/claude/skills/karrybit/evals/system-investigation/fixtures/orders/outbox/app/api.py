from app import orders


def handle_post_orders(conn, request):
    body = request["json"]
    if not body.get("items"):
        return 400, {"error": "items required"}
    order_id = orders.create_order(conn, body["email"], body["items"])
    return 202, {"id": order_id, "status": "pending"}
