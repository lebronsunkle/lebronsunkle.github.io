#!/usr/bin/env bash
# Launch: serve the repo root on a free localhost port and wait until / returns 200.
# Usage: serve.sh [port]   (default: a free port picked by the OS)
# Writes the port and the server's PID to .fredrin/tmp/verify-app/ so stop.sh kills only this server.
set -euo pipefail

root="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
state="$root/.fredrin/tmp/verify-app"
mkdir -p "$state"

if [ -f "$state/server.pid" ] && kill -0 "$(cat "$state/server.pid")" 2>/dev/null; then
  echo "verify-app: server already running at http://127.0.0.1:$(cat "$state/server.port")/ (pid $(cat "$state/server.pid"))"
  exit 0
fi

port="${1:-$(python3 -c 'import socket;s=socket.socket();s.bind(("127.0.0.1",0));print(s.getsockname()[1])' 2>/dev/null || echo 8765)}"

if command -v python3 >/dev/null 2>&1; then
  nohup python3 -m http.server "$port" --bind 127.0.0.1 --directory "$root" >"$state/server.log" 2>&1 &
elif command -v npx >/dev/null 2>&1; then
  nohup npx --yes serve -l "tcp://127.0.0.1:$port" "$root" >"$state/server.log" 2>&1 &
else
  echo "verify-app: need python3 or npx to serve the site" >&2
  exit 1
fi
pid=$!
echo "$pid" >"$state/server.pid"
echo "$port" >"$state/server.port"

for _ in $(seq 1 50); do
  if [ "$(curl -s -o /dev/null -w '%{http_code}' "http://127.0.0.1:$port/" || true)" = 200 ]; then
    echo "verify-app: serving $root at http://127.0.0.1:$port/ (pid $pid)"
    exit 0
  fi
  sleep 0.2
done

echo "verify-app: server did not answer 200 on port $port; log:" >&2
cat "$state/server.log" >&2
kill "$pid" 2>/dev/null || true
rm -f "$state/server.pid" "$state/server.port"
exit 1
