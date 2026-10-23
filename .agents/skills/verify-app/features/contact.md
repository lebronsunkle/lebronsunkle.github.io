# Contact and PDF

**Where:** `index.html`, `section.end#contact`: marquee ("Let's talk / Get in touch / Hablemos"),
the "Thanks for reading." heading, `.links` rows (email, LinkedIn, GitHub, case studies PDF),
and the `.fine` footer line. The PDF is `Adam-Flores-Case-Studies.pdf` at the repo root, also
linked from the hero CTA; the mailto is `adam@deepsteppe.com`.

**Drive:**
```sh
bash $S/shoot.sh / 1440 900 $E/contact-1440.png contact
bash $S/shoot.sh /  390 844 $E/contact-390.png contact
curl -s -o /dev/null -w '%{http_code}\n' http://localhost:$(cat $E/server.port)/Adam-Flores-Case-Studies.pdf   # 200
```

**Check:** all four link rows render with arrows, the PDF answers 200. The home page links the
PDF relatively (`Adam-Flores-Case-Studies.pdf`); a subpage must use `/Adam-Flores-Case-Studies.pdf`.
