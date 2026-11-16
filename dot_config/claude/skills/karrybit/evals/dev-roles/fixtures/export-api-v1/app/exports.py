import uuid

from app.authz import authorize_tenant_access
from app.errors import NotFound
from app.store import Export


def start_export(store, session, tenant_id):
    authorize_tenant_access(session, tenant_id)
    export = Export(export_id=str(uuid.uuid4()), tenant_id=tenant_id, state="RUNNING")
    store.add(export)
    return export


def get_export(store, session, tenant_id, export_id):
    authorize_tenant_access(session, tenant_id)
    export = store.get(export_id)
    if export is None:
        raise NotFound(export_id)
    return export
