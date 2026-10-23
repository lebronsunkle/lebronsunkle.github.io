#!/usr/bin/env bash
# Drive + Evidence: screenshot one page of the served site at an exact CSS width.
# Usage: shoot.sh <path> <width> <height> <out.png> [section-id]
#   shoot.sh /  390  844 .fredrin/tmp/verify-app/home-390.png
#   shoot.sh / 1440  900 .fredrin/tmp/verify-app/work-1440.png work
#
# Headless Chrome clamps its window to at least 500 px wide, so the page renders inside a
# fixed-size iframe on a wrapper page and the PNG is cropped to that iframe. The home page
# strips #hash and pins itself to the top for about a second after load, so a section is
# reached by scrolling the iframe after that, never by putting #id in the URL. Scroll-reveal
# (.rv) does not fire under headless virtual time, so the shot forces .rv content visible.
set -euo pipefail

[ $# -ge 4 ] || { sed -n '3,5p' "$0"; exit 2; }
path="$1" width="$2" height="$3" out="$4" section="${5:-}"

root="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
state="$root/.fredrin/tmp/verify-app"
[ -f "$state/server.port" ] || { echo "shoot: server not running; run serve.sh first" >&2; exit 1; }
base="http://127.0.0.1:$(cat "$state/server.port")"

chrome="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
[ -x "$chrome" ] || chrome="$(command -v google-chrome || command -v chromium || true)"
[ -n "$chrome" ] || { echo "shoot: Chrome not found; set CHROME=/path/to/chrome" >&2; exit 1; }

code="$(curl -s -o "$state/last.html" -w '%{http_code}' "$base$path")"
[ "$code" = 200 ] || { echo "shoot: GET $path -> $code" >&2; exit 1; }
if [ -n "$section" ] && ! grep -q "id=\"$section\"" "$state/last.html"; then
  echo "shoot: no element id=\"$section\" on $path" >&2; exit 1
fi

# The wrapper is served from the same origin so it can reach into the iframe and scroll it.
# The iframe is centered because sips crops from the center (it ignores --cropOffset).
mkdir -p "$state/wrap" "$(dirname "$out")"
name="$(basename "$out" .png)"
cat >"$state/wrap/$name.html" <<HTML
<!doctype html><meta charset="utf-8">
<body style="margin:0;background:#fff">
<iframe id="f" src="$path" style="border:0;display:block;margin:0 auto;width:${width}px;height:${height}px"></iframe>
<script>
var f=document.getElementById('f'),section="$section";
f.onload=function(){setTimeout(function(){
  var d=f.contentDocument,w=f.contentWindow,s=d.createElement('style');
  s.textContent='.rv{opacity:1!important;transform:none!important;transition:none!important}';
  d.head.appendChild(s);
  if(!section)return;
  d.documentElement.style.scrollBehavior='auto';
  w.scrollTo(0,d.getElementById(section).getBoundingClientRect().top+w.scrollY);
},1500)};
</script>
HTML

win=$(( width < 500 ? 500 : width ))
"$chrome" --headless=new --disable-gpu --hide-scrollbars --no-first-run \
  --user-data-dir="$state/chrome-profile" --force-device-scale-factor=1 \
  --window-size="$win,$height" --virtual-time-budget=5000 \
  --screenshot="$state/wrap/$name.png" "$base/.fredrin/tmp/verify-app/wrap/$name.html" >/dev/null 2>&1
sips -c "$height" "$width" --cropOffset 0 0 "$state/wrap/$name.png" --out "$out" >/dev/null
echo "shoot: $path${section:+ #$section} at ${width}x${height} -> $out"
