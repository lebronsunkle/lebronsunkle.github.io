#!/usr/bin/env bash
# Fredrin worktree setup for lebronsunkle.github.io.
# Static GitHub Pages site: no build step, no packages to install. This only
# checks that the tools the verify-app skill needs are present. Safe to re-run.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

[ -f index.html ] || { echo "setup: index.html not found in $root" >&2; exit 1; }

if command -v python3 >/dev/null 2>&1; then
  echo "setup: static server: python3 ($(python3 --version 2>&1))"
elif command -v npx >/dev/null 2>&1; then
  echo "setup: static server: npx serve (python3 not found)"
else
  echo "setup: need python3 or npx to serve the site locally; install one and re-run" >&2
  exit 1
fi

command -v curl >/dev/null 2>&1 || { echo "setup: curl is required" >&2; exit 1; }

chrome="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
if [ -x "$chrome" ] || command -v google-chrome >/dev/null 2>&1 || command -v chromium >/dev/null 2>&1; then
  echo "setup: headless Chrome found (screenshots available)"
else
  echo "setup: warning: Chrome not found; verify-app screenshots will be unavailable (set CHROME=/path/to/chrome)"
fi

mkdir -p .fredrin/tmp

echo "setup: ok. Serve the site with: bash .claude/skills/verify-app/scripts/serve.sh"
