import os

DATABASE_URL = os.environ.get("DATABASE_URL", "postgresql://localhost/tasks_dev")
REDIS_URL = os.environ["REDIS_URL"]  # required: job queue and rate limiter
SECRET_KEY = os.environ.get("SECRET_KEY", "dev-only-secret")
