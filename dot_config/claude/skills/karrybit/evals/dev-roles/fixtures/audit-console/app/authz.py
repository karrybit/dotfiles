"""Authorization for tenant-facing APIs."""

from dataclasses import dataclass

ADMIN_ROLES = ("owner", "admin")


class PermissionDenied(Exception):
    pass


@dataclass(frozen=True)
class Session:
    user_id: str
    tenant_id: str  # the tenant the user is signed in to
    role: str


def authorize_tenant_access(session: Session, tenant_id: str, roles=ADMIN_ROLES) -> None:
    """Raise PermissionDenied unless the session acts on tenant_id with one of roles.

    Every tenant-facing API calls this first, before reading any tenant data.
    """
    if session.tenant_id != tenant_id:
        raise PermissionDenied("tenant mismatch")
    if session.role not in roles:
        raise PermissionDenied("role not allowed")
