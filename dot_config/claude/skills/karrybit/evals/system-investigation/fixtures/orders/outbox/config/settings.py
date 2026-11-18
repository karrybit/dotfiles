import os

DB_PATH = os.environ.get("ORDERS_DB_PATH", "orders.db")
MAIL_API_URL = os.environ.get("MAIL_API_URL", "http://mail.internal/send")
ORDER_QUEUE_URL = os.environ.get("ORDER_QUEUE_URL", "http://queue.internal/order-events")
