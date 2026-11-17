"""Settings read from the environment. CI sets EXPORT_BUCKET=audit-csv-export-ci."""

import os


def export_bucket():
    return os.environ["EXPORT_BUCKET"]
