# Work grid ("Selected work")

**Where:** `index.html`, `section#work` > `.work`, five `a.wcard` cards (two `.lg` on the
first row, three below), each linking to its case study id.

**What a visitor gets:** "Five things I built and still run." with a screenshot card per
project, a status badge, title, number and year, and a one-line summary.

**Drive:**
```sh
bash $S/shoot.sh / 1440 900 $E/work-1440.png work
bash $S/shoot.sh /  390 844 $E/work-390.png work
```

**Check:** 2 + 3 grid at 1440, single column at 390, images from `img/` load (no broken image
icons), badges sit over the image top left.
