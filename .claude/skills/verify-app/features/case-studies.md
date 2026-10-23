# Case studies

**Where:** `index.html`, five `section.cs` blocks: `#sniper` (Domain auction sniper),
`#nameway` (Nameway.com), `#yoon` (YOON Fest), `#desk` (Label manager agents and the Deep Steppe
Desk), `#autodm` (Auto DM). Then `section#also` ("Smaller jobs, same habits.", `article.mini`
cards). Each case study has `.cs-head` (number and badge), `h2`, meta line, `.chips` stat tiles,
body copy, `figure` screenshots from `img/`, and sometimes a `.lesson` callout.

**Drive:**
```sh
for s in sniper nameway yoon desk autodm also; do
  bash $S/shoot.sh / 1440 900 $E/$s-1440.png $s
  bash $S/shoot.sh /  390 844 $E/$s-390.png $s
done
```

**Check:** stat tiles are a 2x2 grid at 390, figures fit the width, no em or en dashes in copy
(`bash $S/doctor.sh`).
