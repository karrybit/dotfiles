# Operations

## Dead-letter queue

Events that exhaust their retries are written to `dead_letter.dir` as one JSON file per event. Replay them with `relayd replay <file>`.

## Reloading

`relayd` re-reads its configuration on `SIGHUP`. Routes in flight finish with the old configuration.
