# Hero and pill bar nav

**Where:** `index.html`, `header.bar` (CSS under `/* ---------- top bar ---------- */`) and
`section.hero` inside `main#top`.

**What a visitor gets:** a fixed, rounded "pill bar" with the `Adam Flores` mark, section links
(About, Work, Case studies, More, Contact), a Los Angeles clock (`#time`, ticks every 30 s) and a
black "Let's talk" mailto pill. The hero has the animated color mesh, the "Hi, I'm Adam Flores"
chip with the open-to-roles line, the H1 with the hand-drawn underline, the lede, two CTAs
("Read the case studies", "Download PDF") and two Caveat handwritten notes.

**Drive:**
```sh
bash $S/shoot.sh / 1440 900 $E/home-1440.png
bash $S/shoot.sh /  390 844 $E/home-390.png
```

**Check:** at 1440 all five nav links and the clock show; at 390 (below 860 px) only the mark
and the pill show, the open-to-roles text hides (below 620 px), the handwritten notes hide, and
the CTAs stack. Nav links scroll in-page without changing the URL.
