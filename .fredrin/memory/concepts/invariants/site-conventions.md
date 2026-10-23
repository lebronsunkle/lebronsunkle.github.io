---
title: Site conventions
type: invariants
summary: Rules every page of the lebronsunkle.github.io portfolio must follow, and what breaks when one does not.
---

# Site conventions

The repo is Adam Flores's portfolio, a static GitHub Pages site served at the domain root
(`https://lebronsunkle.github.io/`). GitHub Pages serves the files as they are committed.

## Rules

- **One self-contained HTML file per page.** A page is `index.html` in its own folder
  (`/index.html`, `/about/index.html`), with its CSS in an inline `<style>` and its JS in an
  inline `<script>`. There are no shared stylesheets or script files to keep in sync.
- **No build step, no frameworks, no package manager.** No `package.json`, bundler, CSS
  framework, or JS library. Vanilla HTML, CSS and JS only. `.fredrin/setup.sh` installs nothing.
- **Design tokens live in `:root` of `index.html`.** A new page copies that `:root` block
  verbatim rather than inventing values:
  - colors: `--bg #F6F2EA` (cream page), `--paper #FFFDF9`, `--ink #141416`, `--body #3A3833`,
    `--muted #76706A`, `--rule #E5DED2`, accents `--blue #4B3BFF`, `--orange #FF5B14`,
    `--lime #D4F25A`, `--pink #FFB4D9`
  - fonts (Google Fonts, one `<link>` in `<head>`): `--sans` Inter, `--display` Inter Tight,
    `--serif` Instrument Serif (italic accents), `--hand` Caveat (handwritten notes),
    `--mono` JetBrains Mono
  - layout: `.wrap` is `max-width:1120px` with `28px` side padding; `.read` is `720px`
  - the top nav is the fixed pill bar `header.bar` (mark, section links, LA clock, "Let's talk"
    pill); below `860px` the links and clock hide and only the mark and pill remain
- **No em dashes or en dashes in site copy.** Use commas, colons, periods or "to". This
  includes `&mdash;` / `&ndash;` entities. `doctor.sh` in the verify-app skill flags them.
- **Root-relative links are safe** (`/`, `/about/`, `/img/x.jpg`) because the site is served at
  the domain root. Links from a subpage to a home section use `/#work`, `/#contact`, and so on.
- **The only external requests are Google Fonts.** Images live in `img/`; the case study PDF is
  `Adam-Flores-Case-Studies.pdf` at the root.

## Behaviors on the home page to know about

- Its inline script strips any `#hash` from the address and pins the page to the top until
  the visitor scrolls or taps, so loading `/#work` does **not** land on the work section.
  In-page nav links scroll with JS instead of changing the URL.
- Elements with class `.rv` start hidden and are revealed by an IntersectionObserver as they
  scroll in (`prefers-reduced-motion` shows them immediately).
- Sections on the home page by id: `top` (main), `about`, `work`, `sniper`, `nameway`, `yoon`,
  `desk`, `autodm`, `also`, `contact`.

## Verifying

Use the project skill `.claude/skills/verify-app/SKILL.md` (mirrored for Codex at
`.agents/skills/verify-app/SKILL.md`): serve locally, run the doctor, screenshot at 1440 px and
390 px.
