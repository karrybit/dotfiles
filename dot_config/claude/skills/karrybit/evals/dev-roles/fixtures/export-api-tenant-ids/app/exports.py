from app.authz import authorize_tenant_access
from app.store import Export


def start_export(store, session, tenant_id):
    authorize_tenant_access(session, tenant_id)
    export = Export(export_id=store.new_id(tenant_id), tenant_id=tenant_id, state="RUNNING")
    store.add(export)
    return export
