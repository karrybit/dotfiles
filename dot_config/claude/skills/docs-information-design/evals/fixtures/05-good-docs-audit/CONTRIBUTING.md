# Contributing

```
make test
make lint
```

Both must pass before review. Tests that send real ICMP packets are skipped unless `PINGMON_NET_TESTS=1` is set, because CI runners do not allow raw sockets.
