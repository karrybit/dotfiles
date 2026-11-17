from dataclasses import dataclass

from app.errors import PermissionDenied


@dataclass(frozen=True)
class Session:
    user_id: str
    tenant_id: str
    role: str


def authorize_tenant_access(session, tenant_id):
    """Raise PermissionDenied unless the session acts on its own tenant as owner or admin."""
    if session.tenant_id != tenant_id or session.role not in ("owner", "admin"):
        raise PermissionDenied(tenant_id)
