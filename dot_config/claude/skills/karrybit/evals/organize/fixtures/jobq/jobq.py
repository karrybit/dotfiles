"""An in-process job queue with retries."""

from collections import deque
from dataclasses import dataclass, field

MAX_ATTEMPTS = 3
BASE_DELAY = 2.0


@dataclass
class Job:
    kind: str
    payload: dict
    state: str = "queued"  # queued -> running -> done | queued | dead
    attempts: int = 0
    not_before: float = 0.0
    error: str = ""


@dataclass
class Queue:
    ready: deque = field(default_factory=deque)
    dead: list = field(default_factory=list)

    def enqueue(self, kind, payload):
        job = Job(kind, payload)
        self.ready.append(job)
        return job

    def take(self, now):
        """Return the first queued job whose delay has passed, or None."""
        for job in self.ready:
            if job.not_before <= now:
                self.ready.remove(job)
                return job
        return None


class Worker:
    def __init__(self, queue, handlers, clock=lambda: 0.0):
        self.queue = queue
        self.handlers = handlers
        self.clock = clock

    def run_once(self):
        """Run one ready job. Return the job, or None when none is ready."""
        now = self.clock()
        job = self.queue.take(now)
        if job is None:
            return None
        handler = self.handlers.get(job.kind)
        if handler is None:
            job.state = "dead"
            job.error = "no handler"
            self.queue.dead.append(job)
            return job
        job.state = "running"
        job.attempts += 1
        try:
            handler(job.payload)
        except Exception as exc:
            job.error = repr(exc)
            if job.attempts < MAX_ATTEMPTS:
                job.state = "queued"
                job.not_before = now + BASE_DELAY * 2 ** (job.attempts - 1)
                self.queue.ready.append(job)
            else:
                job.state = "dead"
                self.queue.dead.append(job)
            return job
        job.state = "done"
        return job
