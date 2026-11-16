"""Audit log list API."""

from datetime import timedelta

from app.authz import authorize_tenant_access

MAX_RANGE = timedelta(days=7)


class InvalidArgument(Exception):
    pass


def list_audit_logs(db, session, tenant_id, start, end):
    """Return the tenant's audit logs with start <= occurred_at < end, oldest first."""
    authorize_tenant_access(session, tenant_id)
    if end <= start:
        raise InvalidArgument("end must be after start")
    if end - start > MAX_RANGE:
        raise InvalidArgument("range longer than 7 days")
    return db.query(
        "SELECT event_id, occurred_at, actor, action, payload FROM audit_logs"
        " WHERE tenant_id = ? AND occurred_at >= ? AND occurred_at < ?"
        " ORDER BY occurred_at, event_id",
        (tenant_id, start, end),
    )
