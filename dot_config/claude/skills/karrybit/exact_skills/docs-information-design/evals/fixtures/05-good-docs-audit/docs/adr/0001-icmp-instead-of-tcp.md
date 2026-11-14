# 1. Probe with ICMP instead of TCP connect

Status: accepted (2025-03-02)

## Context

We need host reachability for network equipment that exposes no TCP services.

## Decision

Probe with ICMP echo.

## Consequences

- Requires `CAP_NET_RAW` or root.
- Hosts that block ICMP will report `pingmon_up 0` even when reachable. We accept this; such hosts are out of scope.

## Rejected alternatives

- TCP connect to a port: switches and PDUs often have no open port.
