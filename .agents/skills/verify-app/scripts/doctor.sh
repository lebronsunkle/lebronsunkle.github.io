#!/usr/bin/env bash
# Doctor: read-only health check. Never starts, stops or edits anything.
# Usage: doctor.sh [page.html ...]   (default: every tracked or new .html page in the repo)
# Checks: the running server (if any) answers 200 on /, each page parses with balanced
# tags, and no em or en dash appears in visible copy.
set -uo pipefail

root="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
state="$root/.fredrin/tmp/verify-app"
fail=0

if [ -f "$state/server.port" ]; then
  port="$(cat "$state/server.port")"
  code="$(curl -s -o /dev/null -w '%{http_code}' "http://127.0.0.1:$port/")"
  echo "server: GET http://127.0.0.1:$port/ -> $code"
  [ "$code" = 200 ] || fail=1
else
  echo "server: not running (run serve.sh to check it)"
fi

if [ $# -eq 0 ]; then
  set -- $(cd "$root" && git ls-files --cached --others --exclude-standard -- '*.html')
fi

for page in "$@"; do
  python3 - "$root/$page" "$page" <<'PY' || fail=1
import sys, html.parser
path, name = sys.argv[1], sys.argv[2]
VOID = {"area","base","br","col","embed","hr","img","input","link","meta","source","track","wbr",
        "path","circle","rect","line","polyline","polygon","ellipse","stop","use"}
OPTIONAL_END = {"p","li"}
class P(html.parser.HTMLParser):
    def __init__(s):
        super().__init__(convert_charrefs=False); s.stack=[]; s.errs=[]; s.text=[]; s.raw=0
    def handle_starttag(s, t, a):
        if t in ("script","style"): s.raw += 1
        if t not in VOID: s.stack.append((t, s.getpos()[0]))
    def handle_endtag(s, t):
        if t in ("script","style"): s.raw -= 1
        if t in VOID: return
        if not any(x[0] == t for x in s.stack):
            s.errs.append(f"stray </{t}> line {s.getpos()[0]}"); return
        while s.stack[-1][0] != t:
            o = s.stack.pop()
            if o[0] not in OPTIONAL_END: s.errs.append(f"<{o[0]}> line {o[1]} closed implicitly by </{t}>")
        s.stack.pop()
    def handle_data(s, d):
        if not s.raw: s.text.append((s.getpos()[0], d))
    def handle_entityref(s, n):
        if not s.raw and n in ("mdash","ndash"): s.text.append((s.getpos()[0], "\u2014"))
    def handle_charref(s, n):
        if not s.raw and n.lower() in ("8212","8211","x2014","x2013"): s.text.append((s.getpos()[0], "\u2014"))
p = P(); p.feed(open(path, encoding="utf-8").read()); p.close()
for t, l in p.stack:
    if t not in OPTIONAL_END: p.errs.append(f"<{t}> line {l} never closed")
dashes = sorted({l for l, d in p.text if "\u2014" in d or "\u2013" in d})
ok = not p.errs and not dashes
print(f"{name}: {'ok' if ok else 'FAIL'}")
for e in p.errs[:10]: print("  parse:", e)
for l in dashes: print(f"  copy: em/en dash on line {l}")
sys.exit(0 if ok else 1)
PY
done

exit $fail
