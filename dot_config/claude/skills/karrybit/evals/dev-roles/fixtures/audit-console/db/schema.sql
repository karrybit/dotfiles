CREATE TABLE tenants (
  tenant_id   TEXT PRIMARY KEY,
  name        TEXT NOT NULL
);

CREATE TABLE memberships (
  tenant_id   TEXT NOT NULL REFERENCES tenants (tenant_id),
  user_id     TEXT NOT NULL,
  role        TEXT NOT NULL CHECK (role IN ('owner', 'admin', 'member')),
  PRIMARY KEY (tenant_id, user_id)
);

CREATE TABLE audit_logs (
  event_id    TEXT PRIMARY KEY,
  tenant_id   TEXT NOT NULL REFERENCES tenants (tenant_id),
  occurred_at TIMESTAMP NOT NULL,
  actor       TEXT NOT NULL,
  action      TEXT NOT NULL,
  payload     TEXT NOT NULL
);

CREATE INDEX audit_logs_tenant_time ON audit_logs (tenant_id, occurred_at);
