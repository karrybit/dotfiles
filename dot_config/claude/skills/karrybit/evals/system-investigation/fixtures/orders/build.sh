#!/bin/bash
# Builds the orders repository in the current directory with its history:
# the base service, the move to an outbox (ADR-0002), batched sends, and an
# unexplained change of the relay interval. docs/architecture.md is never
# updated after the base commit.
set -eu
src=$(cd "$(dirname "$0")" && pwd)
commit() {
  git add -A
  GIT_AUTHOR_DATE="$2" GIT_COMMITTER_DATE="$2" \
    git -c user.name="$3" -c user.email="$4@example.invalid" commit -q -F - <<<"$1"
}
git init -q
cp -R "$src/base/." .
printf '__pycache__/\n' > .gitignore
commit "feat: accept orders and send the confirmation mail" "2026-01-20T10:00:00+09:00" "Aki Sato" aki
cp -R "$src/outbox/." .
commit "fix: start order processing from an outbox written with the order (ADR-0002)

Sending the mail after the commit lost every confirmation while the mail
API was down on 2026-03-04. The order and its order.created event now
commit together; a relay sends the event to the queue and the worker
confirms the order and sends the mail." "2026-03-10T15:30:00+09:00" "Ren Ito" ren
cp -R "$src/batch/." .
commit "perf: send outbox rows to the queue in batches of 50

One request per row hit the queue API's limit of 100 requests per second
during the 2026-04-28 sale and the outbox backed up for 25 minutes. The
batch endpoint takes up to 50 messages per request." "2026-05-02T11:00:00+09:00" "Ren Ito" ren
sed -i.bak 's/RELAY_INTERVAL_SECONDS = 5/RELAY_INTERVAL_SECONDS = 7/' app/relay.py
rm app/relay.py.bak
commit "chore: tune relay interval" "2026-06-15T18:20:00+09:00" "Kai Mori" kai
