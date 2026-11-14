# Configuration reference

relayd reads `/etc/relayd.yaml`.

| Key | Type | Default | Meaning |
| --- | --- | --- | --- |
| `routes[].from` | path | required | Incoming path |
| `routes[].to` | URL | required | Destination URL |
| `routes[].retries` | int | `5` | Delivery attempts before dead-lettering |
| `dead_letter.dir` | path | `/var/lib/relayd/dlq` | Where failed events are written |

For a first setup, see [Getting started](getting-started/index.md).
