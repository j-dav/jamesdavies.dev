# CLAUDE.md

@agents.md

## Commands

```bash
npm run dev          # Dev server at localhost:3000 with live reload
npm run build        # Build to dist/
npm run clean        # Remove dist/
npm run verify       # Lint + format with Biome (also auto-fixes)
npm run format       # Format only with Biome
npm run a11y:check   # Axe accessibility audit (requires Chrome/Chromium)
```

There are no automated tests. Smoke-test the dev server in a browser after changes. The pre-commit hook runs `biome check --write` and `npm run build` automatically via Lefthook.

`npm run a11y:check` builds the site then audits the pages listed in `scripts/a11y-check.sh`. Set `CHROME_PATH` if Chrome is not auto-detected, `CHROMEDRIVER_PATH` if axe's bundled ChromeDriver does not match your Chrome; use `A11Y_BROWSER=firefox` to switch browsers.

## Architecture

Static personal portfolio built with [Eleventy 3](https://www.11ty.dev/), deployed to Cloudflare Pages. Output goes to `dist/`. No client-side JavaScript beyond the small inline theme script in `base.njk`, no CSS framework.

**Templates:** Nunjucks (`.njk`). All pages inherit from `src/_layouts/base.njk`; the CV has its own `src/_layouts/cv.njk`. Shared partials live in `src/_includes/`.

**Data:** `src/_data/site.json` holds site-wide metadata defaults. `src/_data/work.json` and `src/_data/projects.json` drive the Work and Projects pages — these are the files to edit when updating content.

**Static assets:** `public/` is copied directly to the `dist/` root, including `_headers` (Cloudflare Pages response headers). `src/styles/global.css` is the only stylesheet.

**Docs:** `docs/` holds reference documents (CV copy, project descriptions) used as source material for site content; they can lag the site. `src/cv.md` is the live CV.

## Agent skills

### Issue tracker

Issues live in GitHub Issues (`j-dav/jamesdavies.dev`), via the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Domain docs

Single-context: `GLOSSARY.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.
