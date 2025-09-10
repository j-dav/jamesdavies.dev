# jamesdavies.dev

Rebuilt using [Eleventy](https://www.11ty.dev/).

## Development

Install dependencies:

```
npm install
```

Start a local dev server (http://localhost:3000):

```
npm run dev
```

Build the production site (outputs to `_site`):

```
npm run build
```

## Structure

```
eleventy.config.js       # Eleventy configuration
src/_layouts/            # Nunjucks base layout
src/_includes/           # Partials (navbar, etc.)
src/*.njk                # Top-level pages
public/assets            # Static assets (copied through)
src/styles/global.css    # Global styles
```

## TODO / Next Steps

- Add collections for blog posts (Markdown in `src/blog/`)
- Add project/work data via JSON/YAML in `src/_data/`
- Add RSS feed
- Configure meta tags & SEO

---

License: MIT (add a LICENSE file if needed)