# About page (planned)

**Where:** `about/index.html`, built by LEBR-OVJBQI. Until it ships, `/about/` returns 404.
The home page also has an in-page `section#about` ("A real need, working software, and what
happens after it ships.") reached from the nav's About link; that is a different thing.

**Expected:** a self-contained page reusing the home `:root` tokens, the Google Fonts link and
the `header.bar` pill nav, with root-relative links back to home sections (`/#work`,
`/#contact`).

**Drive:**
```sh
bash $S/doctor.sh about/index.html
bash $S/shoot.sh /about/ 1440 900 $E/about-1440.png
bash $S/shoot.sh /about/  390 844 $E/about-390.png
```

**Check:** the pill bar matches the home page at both widths, no horizontal overflow at 390,
nav links resolve to the home sections, doctor reports ok.
