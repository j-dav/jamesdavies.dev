# jamesdavies.dev

Personal site built with [Eleventy](https://www.11ty.dev/). Deployed to Cloudflare Pages.

## Development

Install dependencies:

```
npm install
```

Start a local dev server (http://localhost:3000):

```
npm run dev
```

Build the production site (outputs to `dist`):

```
npm run build
```

Run accessibility checks (requires Chrome/Chromium):

```
npm run a11y:check
```

Set `CHROME_PATH` if the binary is not auto-detected. To use Firefox instead:

```
A11Y_BROWSER=firefox npm run a11y:check
```

## Structure

```
eleventy.config.js       # Eleventy configuration
src/_layouts/            # Page layouts (base, cv)
src/_includes/           # Partials (navbar)
src/_data/               # Site data (work, projects, site metadata)
src/*.njk                # Top-level pages
src/*.md                 # Markdown pages (cv)
public/                  # Static assets (copied to dist root)
src/styles/global.css    # Global styles
docs/                    # Reference documents (cv, project descriptions)
```
