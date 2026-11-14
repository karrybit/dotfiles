# Configure

Back: [Install](02-install.md)

Create `relayd.yaml` with one route:

```yaml
routes:
  - from: /hooks/github
    to: http://host.docker.internal:3000/github
```

The `to` URL must be reachable from inside the container; `localhost` will not work.

Next: [First run](04-first-run.md)
