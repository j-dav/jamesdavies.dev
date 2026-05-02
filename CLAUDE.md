# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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

`npm run a11y:check` builds the site then audits `/`, `/work/`, `/projects/`, and `/blog/` with axe-core. Set `CHROME_PATH` if Chrome is not auto-detected; use `A11Y_BROWSER=firefox` to switch browsers.

## Architecture

Static personal portfolio built with [Eleventy 3](https://www.11ty.dev/), deployed to Cloudflare Pages. Output goes to `dist/`. No client-side JavaScript, no CSS framework.

**Templates:** Nunjucks (`.njk`). All pages inherit from `src/_layouts/base.njk`; the CV has its own `src/_layouts/cv.njk`. Shared partials live in `src/_includes/`.

**Data:** `src/_data/site.json` holds site-wide metadata defaults. `src/_data/work.json` and `src/_data/projects.json` drive the Work and Projects pages — these are the files to edit when updating content.

**Static assets:** `public/` is copied directly to the `dist/` root. `src/styles/global.css` is the only stylesheet.

**Docs:** `docs/` contains reference documents (CV copy, project descriptions) used as source material for site content. `agents.md` at the repo root contains project conventions for AI agents — read it for delivery and style guidance.

## Conventions

- British English in all user-facing copy, comments, and documentation.
- One visible `<h1>` per page template.
- Every page sets `title` and `description` in its front matter.
- Active nav items use `aria-current="page"`.
- Biome enforces: tabs for JS, 2-space indent for CSS/JSON, single quotes, trailing commas.
