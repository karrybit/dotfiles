# Runbook: database failover

## About this runbook

This runbook describes how to fail over the database. Failover is the process of switching from the primary database to the replica. This runbook explains the failover procedure step by step.

## When to use

Use this runbook when the primary is unreachable for more than 5 minutes and `pg_isready` fails from both app hosts. For planned maintenance, use the switchover runbook instead.

## Procedure

1. Announce in `#incident` that failover is starting.
2. Check replication lag on the replica: `psql -h db-replica -c "select now() - pg_last_xact_replay_timestamp();"`. Note the value in the incident channel; it is the window of possibly lost writes.
3. Fence the old primary so it cannot accept writes: `ssh db-primary sudo systemctl stop postgresql` — or, if the host is unreachable, detach its network interface in the cloud console.
   > **Do not continue until the old primary is fenced.** If it comes back while the replica is promoted, both accept writes (split brain) and the data must be reconciled by hand.
4. Promote the replica: `ssh db-replica sudo -u postgres pg_ctl promote -D /var/lib/postgresql/16/main`.
5. Point the apps at the new primary: `./ops/set-db-host.sh db-replica`, then restart them with `./ops/restart-apps.sh`.
6. Confirm writes succeed: `curl -fsS https://api.example.com/healthz/write`.
7. If promotion fails and you need to retry from step 4, first re-check that the old primary is still fenced.
   > **Do not continue until the old primary is fenced.** A host restarted by the cloud provider's auto-recovery comes back with PostgreSQL running.
8. Announce completion in `#incident` with the replication lag noted in step 2.

## Summary

To summarize: announce, check lag, fence the old primary, promote the replica, repoint the apps, confirm writes, and announce completion. Failover switches from the primary database to the replica.

## After the incident

Rebuild the old primary as a new replica with `./ops/rebuild-replica.sh db-primary`. Do not simply restart it.
