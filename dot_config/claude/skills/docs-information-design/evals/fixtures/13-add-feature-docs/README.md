# relayd

relayd forwards webhooks from third-party services to internal HTTP endpoints, with retries and a dead-letter queue.

relayd does not authenticate incoming requests. Put it behind a gateway that checks signatures if your senders support them.

- [Configuration reference](docs/configuration.md)
- [Operations](docs/operations.md)
