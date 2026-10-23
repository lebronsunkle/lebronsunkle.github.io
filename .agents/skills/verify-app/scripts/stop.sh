#!/usr/bin/env bash
# Cleanup: kill only the server serve.sh started. Evidence in .fredrin/tmp/verify-app/ is kept.
set -euo pipefail

root="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
state="$root/.fredrin/tmp/verify-app"

if [ ! -f "$state/server.pid" ]; then
  echo "verify-app: no server recorded; nothing to stop"
  exit 0
fi
pid="$(cat "$state/server.pid")"
if kill -0 "$pid" 2>/dev/null && ps -o command= -p "$pid" | grep -qE 'http\.server|serve'; then
  kill "$pid"
  echo "verify-app: stopped server pid $pid"
else
  echo "verify-app: pid $pid is not a running server we started; leaving it alone"
fi
rm -f "$state/server.pid" "$state/server.port"
