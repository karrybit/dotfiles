"""Client for the asynchronous job platform.

A run moves QUEUED -> RUNNING -> SUCCEEDED or FAILED. The platform retries
nothing on its own; a submit with the same idempotency_key returns the
existing run instead of starting a second one.
"""

STATES = ("QUEUED", "RUNNING", "SUCCEEDED", "FAILED")


class JobClient:
    def __init__(self, transport):
        self._t = transport

    def submit(self, job_name, params, idempotency_key):
        return self._t.post("/runs", {"job": job_name, "params": params, "idempotency_key": idempotency_key})["run_id"]

    def get(self, run_id):
        run = self._t.get(f"/runs/{run_id}")
        return {"state": run["state"], "params": run["params"], "job": run["job"]}
