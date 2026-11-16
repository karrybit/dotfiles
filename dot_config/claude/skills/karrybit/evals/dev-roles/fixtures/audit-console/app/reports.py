"""Monthly usage report: built by a job, delivered by a signed URL."""

import uuid

from app.authz import authorize_tenant_access

JOB = "usage-report"


class NotFound(Exception):
    pass


def start_report(jobs, session, tenant_id, month):
    authorize_tenant_access(session, tenant_id)
    report_id = str(uuid.uuid4())
    run_id = jobs.submit(JOB, {"tenant_id": tenant_id, "month": month, "report_id": report_id}, report_id)
    return {"report_id": report_id, "run_id": run_id}


def report_url(jobs, storage, session, tenant_id, run_id):
    authorize_tenant_access(session, tenant_id)
    run = jobs.get(run_id)
    if run["job"] != JOB or run["params"]["tenant_id"] != tenant_id:
        raise NotFound(run_id)
    if run["state"] != "SUCCEEDED":
        raise NotFound(run_id)
    key = f"{tenant_id}/{run['params']['report_id']}/report.csv"
    return storage.presign_get(key, filename="report.csv")
