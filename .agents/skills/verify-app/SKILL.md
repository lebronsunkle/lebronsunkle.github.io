---
name: verify-app
description: Serve the lebronsunkle.github.io portfolio locally and verify a change in a real browser, with screenshots at 1440 px and 390 px. Use after editing any page (index.html, about/index.html, img/), before finishing a ticket that touches the site, or when asked to run, preview or screenshot the site.
---

# verify-app: lebronsunkle.github.io

Static GitHub Pages site served at the domain root. One self-contained HTML file per page
(inline `<style>` and `<script>`), no build step, no packages. Conventions live in Project
Context: `.fredrin/memory/concepts/invariants/site-conventions.md`. The short version: copy the
`:root` tokens from `index.html`, no frameworks, no em or en dashes in copy, root-relative links.

Scripts are beside this file in `scripts/`. All state and evidence go to
`.fredrin/tmp/verify-app/` (git-ignored). Run everything from the repo root.

```sh
S=.claude/skills/verify-app/scripts
E=.fredrin/tmp/verify-app
```

## 1. Launch

```sh
bash .fredrin/setup.sh      # once per worktree; checks python3/npx, curl, Chrome
bash $S/serve.sh            # or: bash $S/serve.sh 8080 to force a port
```

`serve.sh` serves the repo root with `python3 -m http.server` on a free 127.0.0.1 port (falls
back to `npx serve` if python3 is missing), records the port in `$E/server.port` and the PID in
`$E/server.pid`, and returns only after `/` answers 200. If a server it started is still alive
it reuses it. Nothing to seed: the site has no data.

**Ready** means:

```sh
curl -s -o /dev/null -w '%{http_code}\n' http://localhost:$(cat $E/server.port)/   # 200
```

## 2. Doctor (read-only)

```sh
bash $S/doctor.sh                    # every .html page in the repo
bash $S/doctor.sh about/index.html   # one page
```

Reports the server's status on `/` (if running), then per page: tags balance, and no em or en
dash (raw or as `&mdash;`/`&ndash;`) in visible copy. Exit 0 means all clean. It never starts,
stops or edits anything.

## 3. Drive

The real routes:

| Route | What it is |
|---|---|
| `/` | home: hero, then sections `about`, `work`, `sniper`, `nameway`, `yoon`, `desk`, `autodm`, `also`, `contact` |
| `/about/` | About page, once LEBR-OVJBQI ships it |
| `/Adam-Flores-Case-Studies.pdf` | downloadable PDF (check with curl for 200) |
| `/img/*` | images used by the case studies |

Screenshot with `shoot.sh <path> <width> <height> <out.png> [section-id]`:

```sh
bash $S/shoot.sh /  1440 900 $E/home-1440.png
bash $S/shoot.sh /   390 844 $E/home-390.png
bash $S/shoot.sh /  1440 900 $E/work-1440.png work      # scrolled to #work
bash $S/shoot.sh /   390 844 $E/contact-390.png contact
bash $S/shoot.sh /about/ 390 844 $E/about-390.png
```

Traps this script already handles, so do not work around them by hand:

- **Headless Chrome clamps the window to at least 500 px wide.** A plain
  `--window-size=390,844` renders at 500. `shoot.sh` renders the page inside a centered
  iframe of the exact width and crops to it (sips crops from the center).
- **`/#work` does not scroll to work.** The home page strips the hash and pins itself to the
  top after load. Pass the section id as the 5th argument; `shoot.sh` scrolls the iframe
  after the pin settles (1.5 s).
- **Scroll-reveal content (`.rv`) stays invisible under headless virtual time.** `shoot.sh`
  forces `.rv` visible, so screenshots show layout and content, not the reveal animation. If a
  change touches the reveal itself, check it in a real browser (Fredrin's built-in browser:
  `fredrin browser --help`).

Always shoot both 1440 and 390 for any page you change, and look at every PNG (Read the file):
check the pill bar, fonts (serif italics and Caveat notes load from Google Fonts, so offline
shots fall back to system fonts), no horizontal overflow at 390, and no clipped text.

## 4. Evidence

Everything lands in `$E/`: the PNGs you name, `server.log`, and `last.html` (the HTML of the
last page shot). Quote the curl status line and doctor output in your summary. Upload
screenshots only when the ticket asks for evidence artifacts.

## 5. Cleanup

```sh
bash $S/stop.sh
```

Kills only the PID `serve.sh` recorded (and only if it is still an http server process), then
removes the pid/port files. Screenshots and logs in `$E/` are kept.

## Feature map

One file per top feature in `features/`, each with where it lives, how to drive it and what to
check:

- `features/hero-and-nav.md`: pill bar nav, hero, LA clock, CTAs
- `features/work-grid.md`: "Selected work" card grid (`#work`)
- `features/case-studies.md`: the five long-form case studies (`#sniper` to `#autodm`) and `#also`
- `features/contact.md`: `#contact`, mailto pill, PDF download
- `features/about-page.md`: `/about/` (planned, LEBR-OVJBQI)
