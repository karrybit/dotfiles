import argparse
import os


def load():
    p = argparse.ArgumentParser(prog="shipit")
    p.add_argument("--region", required=True, help="deployment region, e.g. ap-northeast-1")
    p.add_argument("--dry-run", action="store_true")
    args = p.parse_args()
    db_url = os.environ["DATABASE_URL"]
    return args, db_url
