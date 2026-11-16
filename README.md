# gargshishirr.github.io

Shishir Garg's GitHub Pages site. How to update and maintain it: **[GUIDE.md](GUIDE.md)**.

| Address | What it is |
|---|---|
| [gargshishirr.github.io](https://gargshishirr.github.io/) | Takes you to the [portfolio](https://gargshishirr.github.io/PortfolioWebsite/) |
| [/kharcha/](https://gargshishirr.github.io/kharcha/) | **Kharcha**, the expense tracker, in the browser. Your expenses stay in your own browser. |
| [/tic-tac-toe/](https://gargshishirr.github.io/tic-tac-toe/) | **Tic Tac Toe**, with sound effects |

This repository holds only the built websites; the apps' source code is in their own private repositories.

## Updating Kharcha

After changing Kharcha, run `bash update-kharcha.sh` here. It builds the web version from `~/kharcha` (Node.js and
Kharcha's dependencies installed) and pushes it; the site updates about a minute later.

Kharcha is a single-page app, so `404.html` sends a reload on one of its screens back to the app.
