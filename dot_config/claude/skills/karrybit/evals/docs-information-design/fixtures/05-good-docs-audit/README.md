# pingmon

pingmon probes a list of hosts with ICMP and exposes the results as Prometheus metrics.

## Run

```
make build
sudo ./bin/pingmon --targets targets.txt
```

ICMP needs raw sockets, hence `sudo`. To run unprivileged, grant the capability once: `sudo setcap cap_net_raw+ep bin/pingmon`.

`targets.txt` lists one host name or IP per line; lines starting with `#` are ignored.

| Flag | Default | Meaning |
| --- | --- | --- |
| `--targets` | `targets.txt` | Host list file |
| `--interval` | `30s` | Probe interval |
| `--listen` | `:9101` | Address for `/metrics` |

## Metrics

- `pingmon_up{target}`: `1` if the last probe got a reply, else `0`
- `pingmon_rtt_seconds{target}`: round-trip time of the last successful probe

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Design decisions are recorded in [docs/adr](docs/adr).
