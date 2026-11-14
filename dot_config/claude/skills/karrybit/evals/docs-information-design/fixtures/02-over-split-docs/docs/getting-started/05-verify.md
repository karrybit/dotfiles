# Verify

Back: [First run](04-first-run.md)

Send a test event:

```
curl -X POST localhost:8080/hooks/github -d '{"zen":"test"}'
```

relayd logs `forwarded route=/hooks/github status=200` when the event reaches your endpoint. If you see `status=502`, recheck the `to` URL from the Configure step.
