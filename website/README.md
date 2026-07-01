# TaskWarrior Mobile — Project Website

A self-contained [Hugo](https://gohugo.io) static site for the TaskWarrior Mobile
app: landing page, downloads (with an auto-updated **nightly build log**), and a
documentation section. It has **no external theme** — all layouts live in
`layouts/`, so it builds from the single Hugo binary with no submodules or network
fetches.

## Local development

Requires Hugo **extended** (pinned to the version in
[`.github/workflows/deploy-website.yml`](../.github/workflows/deploy-website.yml)):

```bash
# from this directory
hugo server            # live-reload dev server at http://localhost:1313
hugo --minify          # production build into ./public
```

## Layout

```
website/
├── hugo.toml                     # site config (baseURL, menus, params)
├── content/                      # Markdown pages (_index, downloads, docs)
├── layouts/                      # self-contained templates (no theme)
│   ├── _default/                 # baseof / single / list
│   ├── index.html                # homepage
│   └── shortcodes/
│       └── nightly-builds.html   # renders data/nightly_builds.json
├── data/
│   └── nightly_builds.json       # build log (populated by CI; ships empty)
└── static/
    ├── css/style.css
    └── CNAME                     # custom domain
```

## Nightly build log

[`scripts/update_build_log.py`](../scripts/update_build_log.py) prepends an entry
`{ts, sha, msg, status, artifact, build}` to `data/nightly_builds.json` (keeping the
90 most recent). The `{{</* nightly-builds */>}}` shortcode on the downloads page
renders it. The file ships as `[]`; CI fills it in.

## CI

- **`build-nightly.yml`** — daily at 02:00 UTC (and on demand): builds the signed
  nightly APK, records the result via `update_build_log.py`, and commits the updated
  log to `main`.
- **`deploy-website.yml`** — on any push touching `website/**` (including the nightly
  log commit): builds the site with Hugo and deploys it to GitHub Pages.
- `nightlydepolyci.yml` now ignores `website/**` and `scripts/**` so a build-log
  commit does not trigger a redundant APK rebuild.

## One-time infrastructure setup (needs repo-admin / DNS access)

These cannot be done from code and must be configured by a maintainer:

1. **Enable GitHub Pages** → repo *Settings → Pages → Build and deployment →
   Source: **GitHub Actions***.
2. **Custom domain / DNS** — point `taskwarrior.ccextractor.org` at GitHub Pages
   with a `CNAME` DNS record to `<org-or-user>.github.io`. The site already ships a
   `static/CNAME`, so Pages will pick up the domain on first deploy.
3. **Branch protection** — if `main` is protected, allow `github-actions[bot]` to
   push the nightly build-log commit (or point that commit at an unprotected branch).
4. The nightly signing secrets (`NIGHTLY_KEYSTORE_B64`, `NIGHTLY_PROPERTIES_B64`) are
   the same ones the existing F-Droid workflow already uses.

> **Note on the deploy target.** The proposal described renaming the `fdroid-repo`
> branch to `public-site` and serving from a branch. This implementation instead uses
> the modern **GitHub Actions Pages deployment** (`actions/deploy-pages`), which keeps
> the site source in `website/` on `main` and needs no dedicated deploy branch — fewer
> moving parts and no history juggling. The F-Droid APK repo on `fdroid-repo` is
> untouched.
