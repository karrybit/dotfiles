# Configuration reference

relayd reads `/etc/relayd.yaml`.

| Key | Type | Default | Meaning |
| --- | --- | --- | --- |
| `routes[].from` | path | required | Incoming path |
| `routes[].to` | URL | required | Destination URL |
| `routes[].retries` | int | `5` | Delivery attempts before dead-lettering |
| `dead_letter.dir` | path | `/var/lib/relayd/dlq` | Where failed events are written |

Example:

```yaml
routes:
  - from: /hooks/github
    to: http://ci.internal/github
    retries: 3
```
