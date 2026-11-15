# jobq

A small in-process job queue. Producers enqueue jobs; a worker takes one job
at a time and runs the handler registered for its kind.

## Usage

```python
from jobq import Queue, Worker

q = Queue()
w = Worker(q, {"email": send_email})
q.enqueue("email", {"to": "user@example.invalid"})
w.run_once()
```

## Failures

When a handler raises, the job goes back to the queue and is retried after a
delay. A job is retried up to 5 times; after that it is marked `dead` and
stays in `Queue.dead` for inspection.

A job whose kind has no registered handler is marked `dead` at once.
