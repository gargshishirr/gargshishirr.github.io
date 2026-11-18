# gargshishirr.github.io — guide

Shishir's GitHub Pages site. It hosts the built web versions of a few apps and sends the bare address to the
portfolio. The apps' source code lives in their own repositories.

## What's here

| Address | What it is |
|---|---|
| [gargshishirr.github.io](https://gargshishirr.github.io/) | Sends you to the [portfolio](https://gargshishirr.github.io/PortfolioWebsite/) |
| [/kharcha/](https://gargshishirr.github.io/kharcha/) | **Kharcha**, the expense tracker, in the browser |
| [/kharcha/connect-bot/](https://gargshishirr.github.io/kharcha/connect-bot/) | Where links from the Kharcha WhatsApp bot open |
| [/kharcha-privacy.html](https://gargshishirr.github.io/kharcha-privacy.html) | Kharcha's privacy page (linked from Google's sign-in screen) |
| [/tic-tac-toe/](https://gargshishirr.github.io/tic-tac-toe/) | **Tic Tac Toe**, with sound effects |

The portfolio, MedRecords and Pathfinder have their own repositories and appear under
`gargshishirr.github.io/<repository name>/`.

## How to update Kharcha

After changing Kharcha (in `~/kharcha`, on the `main` branch):

```bash
cd ~/gargshishirr.github.io
bash update-kharcha.sh
```

It builds the web version, copies it into `kharcha/` and pushes. The site updates about a minute later.

## How to update Tic Tac Toe

Copy `index.html`, `style.css`, `script.js` and the sound files from the tic-tac-toe repository into
`tic-tac-toe/`, then commit and push. Leave out `music.mp3`: its licence is unknown, so the online copy has
no background music.

## How to maintain

- Nothing here needs updating on its own. Re-run `update-kharcha.sh` whenever Kharcha changes.
- Keep `404.html`: Kharcha is a single-page app, and this page sends a reload on one of its screens back to
  the app.
- GitHub Pages settings: repository → Settings → Pages, source "Deploy from a branch", `main`, `/ (root)`.

## Security & privacy

- These are static pages: no server, no accounts, no cookies, no tracking, and nothing secret in the repo.
- Kharcha keeps each visitor's expenses in that visitor's own browser. Nothing is sent here.
- Connection links from the Kharcha bot carry the bot's key after the `#`. That part never reaches GitHub, and
  the page removes it from the address bar straight away.

## Troubleshooting

- **The site didn't update.** Wait a minute, then reload with ⌘⇧R. Check the repository's Actions tab
  ("pages build and deployment") for a failed run.
- **`update-kharcha.sh` says `app.config.js already exists`.** A build was interrupted. Delete
  `~/kharcha/app.config.js`, then run the script again.
- **A Kharcha screen shows "Page not found" after a reload.** `404.html` must stay in the repository root.
