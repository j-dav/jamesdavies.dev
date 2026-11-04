# Portfolio site improvements: research findings

Researched 4 November 2026 against primary sources only (Google Search Central, W3C, MDN, web.dev, 11ty.dev, Cloudflare Docs, ogp.me, schema.org). Each claim is followed by the URL that owns it. Local observations about the current repository are marked **[Repo]** and were read from the working tree; no site files were edited.

Scope note: the X (Twitter) card documentation could not be retrieved (developer.x.com returned HTTP 402, docs.x.com returned 404), so nothing below makes claims about `twitter:*` tag semantics beyond what already exists in the repo. Treat that as unverified.

## 1. SEO and metadata

### Canonical URLs
- Google supports `rel="canonical"` link annotations (RFC 6596) in the HTML `<head>` or as an HTTP header, and recommends choosing one method rather than both. https://developers.google.com/search/docs/crawling-indexing/consolidate-duplicate-urls
- Google recommends absolute rather than relative paths in `rel="canonical"`, because relative paths "can cause problems in the long run". https://developers.google.com/search/docs/crawling-indexing/consolidate-duplicate-urls
- A self-referential canonical on the canonical page is recommended. Redirects and `rel="canonical"` are strong signals; sitemap inclusion is a weak one. https://developers.google.com/search/docs/crawling-indexing/consolidate-duplicate-urls
- **[Repo]** `base.njk` already emits an absolute, self-referential canonical built from `site.url + page.url`. This is aligned with the guidance; no change needed beyond making sure `site.url` has no trailing slash.

### Open Graph and Twitter cards
- Open Graph requires four properties on every page: `og:title`, `og:type`, `og:image`, `og:url`. `og:url` is the canonical URL and permanent ID. https://ogp.me/
- `og:description`, `og:locale` (default `en_US`) and `og:site_name` are optional. `og:image:alt` should be included whenever `og:image` is used. https://ogp.me/
- Any page without richer markup should be treated as `og:type` `website`; `profile` is a defined type with `first_name`, `last_name`, `username`. https://ogp.me/
- **[Repo]** All four required tags are present. Missing: `og:image:alt`, `og:locale` (should be `en_GB` for a British site, since the default is `en_US`), `og:site_name`. The `twitter:*` tags exist but their semantics are unverified here (see scope note).

### Meta descriptions
- Google may use the meta description for the snippet when it describes the page better than the page text. Descriptions should be unique per page, summarise the page, and avoid keyword lists. https://developers.google.com/search/docs/appearance/snippet
- **[Repo]** Per CLAUDE.md every page sets `description`; keep them unique.

### Sitemap
- Google accepts XML, RSS/Atom and text sitemaps; files must be UTF-8 with absolute URLs; limit is 50 MB or 50,000 URLs. https://developers.google.com/search/docs/crawling-indexing/sitemaps/build-sitemap
- Google ignores `<priority>` and `<changefreq>`. It uses `<lastmod>` only if consistently and verifiably accurate. https://developers.google.com/search/docs/crawling-indexing/sitemaps/build-sitemap
- A `Sitemap:` line in robots.txt is a supported way to submit one. https://developers.google.com/search/docs/crawling-indexing/sitemaps/build-sitemap
- Eleventy can emit any file type via `permalink` with an extension (for example `/sitemap.xml`). https://www.11ty.dev/docs/permalinks/
- **[Repo]** `src/sitemap.njk` is hand-maintained, lists five URLs, uses `<priority>` (ignored by Google) and has no `<lastmod>`. Generating it from `collections.all` with `page.date`-based `lastmod` would remove drift, but only if dates are genuinely accurate.

### robots.txt
- robots.txt controls crawling, mainly to avoid overloading the site; it is "not a mechanism for keeping a web page out of Google". Use `noindex` or authentication instead. https://developers.google.com/search/docs/crawling-indexing/robots/intro
- **[Repo]** `public/robots.txt` disallows `/drafts/`. Per the above, a disallowed URL can still be indexed if linked elsewhere; if drafts must not appear in search, add `<meta name="robots" content="noindex">` to `draft-base.njk` (a noindex only works if the page is crawlable, so weigh this against the Disallow).

### JSON-LD: Person and WebSite
- schema.org `Person` lists `name`, `jobTitle`, `url`, `sameAs`, `worksFor`, `image`, `description` and `knowsAbout` among its properties. https://schema.org/Person
- Google's `ProfilePage` documentation requires `mainEntity` (a `Person` or `Organization`) and `name`; recommends `dateCreated`, `dateModified`, `description`, `image` (no placeholders), `sameAs`, `alternateName`. https://developers.google.com/search/docs/appearance/structured-data/profile-page
- Google's site-name guidance requires `WebSite` with `name` and `url`, placed only on the home page (root of the domain); `alternateName` is optional. Site names are chosen automatically and are not guaranteed. https://developers.google.com/search/docs/appearance/site-names
- **[Repo]** A `Person` block is emitted on every page. Suggested change: emit `WebSite` on the home page only, and `Person` (ideally wrapped in `ProfilePage` with `dateModified`) on the home or about page, adding `description` and `worksFor`. Do not mark up content that is not visible on the page.

## 2. Accessibility (WCAG 2.2)

### Focus visibility and appearance
- `:focus-visible` lets you restyle the focus indicator without changing when browsers show it; the indicator needs at least 3:1 contrast (SC 1.4.11), and removing focus styles "makes keyboard navigation inaccessible". https://developer.mozilla.org/en-US/docs/Web/CSS/:focus-visible
- SC 1.4.11 Non-text Contrast (AA): UI components and meaningful graphics need at least 3:1 against adjacent colours. https://www.w3.org/TR/WCAG22/#non-text-contrast
- SC 2.4.11 Focus Not Obscured (Minimum) is new in WCAG 2.2 at AA: a focused component must not be entirely hidden by author-created content (relevant to sticky headers). https://www.w3.org/TR/WCAG22/#focus-not-obscured-minimum
- SC 2.4.13 Focus Appearance is AAA in 2.2 (indicator at least a 2 CSS px perimeter, 3:1 change in contrast between focused and unfocused). It is a sensible target even though it is not required. https://www.w3.org/WAI/WCAG22/Understanding/focus-appearance.html
- **[Repo]** `global.css` has 2px `:focus-visible` outlines using `--focus-ring` (`#3b82f6` light, `#93c5fd` dark). Verify `#3b82f6` reaches 3:1 against the actual light background, and check `outline-offset`.

### Contrast
- SC 1.4.3 (AA): 4.5:1 for normal text, 3:1 for large text (18pt, or 14pt bold); ratios must not be rounded up. https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
- **[Repo]** Re-check muted/secondary text tokens in both themes against 4.5:1; `npm run a11y:check` (axe) catches many but not all issues, especially in a class-toggled dark theme.

### Target size
- SC 2.5.8 Target Size (Minimum), AA, new in 2.2: pointer targets at least 24 by 24 CSS px, with exceptions for spacing, inline text links, equivalents and user-agent controls. https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html
- **[Repo]** Footer social icons are 18 px SVGs inside links; confirm the link boxes (including padding) are at least 24 px, or spaced per the exception.

### Landmarks and skip links
- SC 2.4.1 Bypass Blocks (Level A) requires a mechanism to bypass repeated blocks; a link at the top of the page to the main content (G1) is a sufficient technique, and ARIA landmarks (ARIA11) are another. https://www.w3.org/WAI/WCAG22/Understanding/bypass-blocks.html
- The APG recommends putting all content in landmarks, one `main`, `header`/`footer` as banner/contentinfo when scoped to `body`, and unique labels when a landmark role repeats (use `aria-label="Site"`, not "Site navigation"). https://www.w3.org/WAI/ARIA/apg/practices/landmark-regions/
- **[Repo]** Layout has `header`, `main`, `footer` but no skip link. Add `<a class="skip-link" href="#main">` before the header with `id="main"` on `<main>`. Check that `navbar.njk` has a labelled `<nav>`.

### Reduced motion
- `@media (prefers-reduced-motion: reduce)` detects the user's request to minimise non-essential motion; reduced does not have to mean none (swap movement for opacity). https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion
- WCAG 2.3.3 Animation from Interactions (AAA) lists technique C39 (the CSS media query). https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions.html
- **[Repo]** No `prefers-reduced-motion` rule found in `global.css`. If there are any transitions or smooth scrolling, wrap them.

### Dark mode
- `prefers-color-scheme` (Baseline widely available since January 2020) detects the OS or browser theme preference. https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme
- `color-scheme: light dark` on `:root` makes the canvas, scrollbars and form controls follow the active scheme; `<meta name="color-scheme" content="light dark">` placed before CSS helps avoid a flash on load. `light-dark()` can express paired colours. https://developer.mozilla.org/en-US/docs/Web/CSS/color-scheme
- **[Repo]** Theme is class-based, set by an inline script reading `localStorage`, defaulting to `light`; `prefers-color-scheme` appears only in the `theme-color` metas, not in the CSS. Visitors with a dark OS setting therefore get a light site until they toggle. Recommended: default to the system preference in CSS, let the toggle override, add `color-scheme`. This also affects the CSP choice below (the inline script).

## 3. Performance and Core Web Vitals

### Targets
- Core Web Vitals "good" thresholds at the 75th percentile: LCP 2.5 s or less, INP 200 ms or less, CLS 0.1 or less. https://web.dev/articles/vitals

### Fonts
- web.dev advises: use WOFF2, subset with `unicode-range`, reduce the number of web fonts or use system fonts, choose `font-display` deliberately, and use `size-adjust` on fallback fonts to reduce layout shift. Self-hosting helps only with a CDN and HTTP/2, and should be measured. https://web.dev/articles/font-best-practices
- `preload` competes with other resources and ignores `unicode-range`; inlining `@font-face` in the `<head>` is often a better fix. https://web.dev/articles/font-best-practices
- **[Repo]** Two Google Fonts families (Archivo 500/700/900, JetBrains Mono 400/500) load from `fonts.googleapis.com` via a render-blocking stylesheet, with two preconnects. Self-hosting WOFF2 from Cloudflare Pages (which already provides a CDN and Brotli) removes two third-party origins and makes a tight CSP possible. Add a `size-adjust` fallback to limit CLS.

### Images
- `srcset`/`sizes` let the browser pick the most efficient candidate; `<picture>` gives prescriptive control over format and art direction. https://web.dev/learn/images/responsive-images
- For the LCP image: keep it discoverable in the initial HTML, set `fetchpriority="high"` on it (one or two images at most), and never `loading="lazy"` it. https://web.dev/articles/optimize-lcp
- **[Repo]** `public/assets/hero.jpg` is the only image and doubles as the OG image and the Person `image`. Generate AVIF/WebP/JPEG variants for on-page use (see section 4) but keep a JPEG or PNG for `og:image`; social crawlers' format support is not covered by the primary sources reviewed, so that is a precaution rather than a documented requirement.

### Cloudflare Pages `_headers`
- `_headers` is a plain-text file with no extension, in the build output directory (for Eleventy, copied from `public/` via the existing passthrough). Rules are a URL pattern followed by indented `name: value` lines; limit 100 rules, 2,000 characters per line; `! Name` detaches a header. https://developers.cloudflare.com/pages/configuration/headers/
- Headers apply only to static asset responses, not to Pages Functions responses. https://developers.cloudflare.com/pages/configuration/headers/
- The Cloudflare example covers `X-Frame-Options`, `X-Content-Type-Options`, `Referrer-Policy`, `Permissions-Policy` and a CSP. https://developers.cloudflare.com/pages/configuration/headers/
- Pages sends an `ETag` and serves 304s; assets stay cached until the next deployment, and Cloudflare advises against custom caching on custom domains except for hashed, immutable files. Brotli and Gzip are on by default. Early Hints are off by default and enabled via `_headers`. https://developers.cloudflare.com/pages/configuration/serving-pages/
- General HTTP guidance: versioned assets use `Cache-Control: public, max-age=31536000, immutable`; HTML uses `no-cache` with validators. https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching
- **[Repo]** No `_headers` file exists. Because `styles/global.css` is not fingerprinted (`/styles/global.css`), long `immutable` caching is unsafe for it unless the filename gains a hash; leave it on Cloudflare's default ETag behaviour. Self-hosted font files, which rarely change, are the natural candidates for a long-lived rule if given versioned filenames.
- `_redirects` (plain text, `source destination [code]`, default 302) is available for moving URLs; redirects take priority over headers. https://developers.cloudflare.com/pages/configuration/redirects/

### Content Security Policy
- MDN's static-site pattern: hashes rather than nonces; `default-src 'self'`; `object-src 'none'`; `base-uri 'none'`; `form-action 'self'`; `frame-ancestors 'none'`. https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CSP
- `frame-ancestors` is ignored in a `<meta>` CSP, so the policy belongs in an HTTP header (`_headers`); trial with `Content-Security-Policy-Report-Only` first. https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CSP
- Inline `<script>` blocks need a hash; `style=""` attributes fall under `style-src-attr`. https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CSP
- **[Repo]** Blockers for a strict CSP today: the inline theme script and `toggleTheme()` in `base.njk`, and the Google Fonts origins. The inline JSON-LD block is a data block rather than executed script; confirm in report-only mode. Self-hosting fonts and moving the theme script to a hashed or external file would allow `default-src 'self'`. Note that CLAUDE.md states "No client-side JavaScript" while the layout already ships a small script; either a CSS-only dark mode or a documented exception would resolve this.

## 4. Eleventy 3 practice

### Images
- `@11ty/eleventy-img` v7 requires Node 22+ and is ESM; `eleventyImageTransformPlugin` (added in Eleventy 3.0.0) processes every `<img>`/`<picture>` in HTML output. https://www.11ty.dev/docs/plugins/image/
- It sets `widths` and `formats` (for example `avif`, `webp`, `jpeg`), adds `width` and `height` to reduce layout shift, and requires you to provide `sizes` when emitting multiple widths. `loading` and `decoding` are set via `htmlOptions.imgAttributes`. It has memory and disk caches. https://www.11ty.dev/docs/plugins/image/
- **[Repo]** `package.json` pins Node 24.7.0 via Volta, which satisfies Node 22+. The config is CommonJS (`module.exports`); ESM-only plugins need `eleventy.config.mjs` or `"type": "module"`, or a dynamic import, so budget for converting the config.

### Feed
- `@11ty/eleventy-plugin-rss` v3 is ESM-only and requires Eleventy 3.0+. Its virtual-template `feedPlugin` generates Atom (default), RSS or JSON from a collection with `outputPath`, `collection.name`, `collection.limit`, and `metadata` (`base`, `language`, `title`, `subtitle`, `author`). https://www.11ty.dev/docs/plugins/rss/
- The `absoluteUrl` filter is deprecated in favour of the HTML Base plugin's `transformWithHtmlBase`. https://www.11ty.dev/docs/plugins/rss/ and https://www.11ty.dev/docs/plugins/html-base/
- The RSS page does not document the feed autodiscovery `<link rel="alternate">` tag, so it is not asserted here.
- **[Repo]** There is a `/blog/` page and a `src/drafts` folder but no post collection or feed. Worth adding once there is more than one post.

### Data cascade
- Priority, highest to lowest: computed data, template front matter, template data files, directory data files, layout front matter, config API global data, global data files. Layout front matter works as defaults, and arrays/objects deep-merge. https://www.11ty.dev/docs/data-cascade/
- **[Repo]** `src/_data/site.json` is global data and already serves as the fallback. Directory data files (for example for `src/drafts/`, setting `layout` and a noindex flag) would remove repeated front matter.

### 404 page
- Create a `404.html` (or `.njk`/`.md`) template with `permalink: 404.html`; Cloudflare Pages serves it automatically, and Eleventy Dev Server (2.0+) serves it locally. https://www.11ty.dev/docs/quicktips/not-found/
- Without a top-level `404.html`, Cloudflare Pages assumes a single-page app and serves the root for unmatched non-asset paths. https://developers.cloudflare.com/pages/configuration/serving-pages/
- **[Repo]** `src` has no 404 template. This is a concrete, cheap fix.

### HTML validation
- The W3C Nu HTML Checker can be run as a web service or from the command line (`vnu.jar`); see its documentation for usage. https://validator.w3.org/nu/about.html and https://validator.github.io/validator/
- Adding it to `scripts/a11y-check.sh` or a Lefthook step would complement Biome and axe. Exact CLI flags were not verified.

## 5. Prioritised checklist

### High
| Item | Rationale | Source |
|---|---|---|
| Add a `404.html` template with `permalink: 404.html` | Without it Cloudflare Pages assumes an SPA and serves the root for missing paths | https://developers.cloudflare.com/pages/configuration/serving-pages/ ; https://www.11ty.dev/docs/quicktips/not-found/ |
| Add a skip link and `id` on `<main>`; label `<nav>` | Bypass Blocks is Level A | https://www.w3.org/WAI/WCAG22/Understanding/bypass-blocks.html |
| Follow `prefers-color-scheme` by default; add `color-scheme: light dark` and `<meta name="color-scheme">` | Theme is currently light unless toggled; browser UI and form controls should match | https://developer.mozilla.org/en-US/docs/Web/CSS/color-scheme |
| Verify text and focus-ring contrast in both themes (4.5:1 text, 3:1 focus ring) | AA criteria 1.4.3 and 1.4.11 | https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html ; https://developer.mozilla.org/en-US/docs/Web/CSS/:focus-visible |
| Add `public/_headers` with `X-Content-Type-Options`, `Referrer-Policy`, `Permissions-Policy` and framing control | Documented Cloudflare mechanism for baseline security headers on static assets | https://developers.cloudflare.com/pages/configuration/headers/ |
| Self-host subset WOFF2 fonts with deliberate `font-display` and a `size-adjust` fallback | Removes render-blocking third-party CSS and reduces CLS | https://web.dev/articles/font-best-practices |

### Medium
| Item | Rationale | Source |
|---|---|---|
| `WebSite` JSON-LD on the home page only; keep `Person` (optionally in `ProfilePage`) with `description` and `worksFor` | Matches Google's site-name and profile markup requirements | https://developers.google.com/search/docs/appearance/site-names ; https://developers.google.com/search/docs/appearance/structured-data/profile-page |
| Add `og:image:alt`, `og:site_name`, `og:locale` = `en_GB` | ogp.me recommends alt text with images; locale defaults to `en_US` | https://ogp.me/ |
| Generate the sitemap; drop `<priority>`; include `<lastmod>` only if accurate | Google ignores priority and uses lastmod only when reliable | https://developers.google.com/search/docs/crawling-indexing/sitemaps/build-sitemap |
| Add `noindex` to draft layouts rather than relying on robots.txt | robots.txt is not a way to keep pages out of Google | https://developers.google.com/search/docs/crawling-indexing/robots/intro |
| Introduce a CSP via `_headers`, starting Report-Only; move the theme script out of inline | Hash-based strict CSP suits static sites; `frame-ancestors` needs a header | https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CSP |
| Add `@media (prefers-reduced-motion: reduce)` for any transitions or smooth scrolling | Honours a user setting; motion can trigger vestibular discomfort | https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion |
| Check footer icon links meet 24 by 24 px target size | New AA criterion in WCAG 2.2 | https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html |
| Use `eleventyImageTransformPlugin` for page images (AVIF/WebP/JPEG, width/height, `sizes`) | Smaller files and reserved space; never lazy-load the LCP image | https://www.11ty.dev/docs/plugins/image/ ; https://web.dev/articles/optimize-lcp |

### Low
| Item | Rationale | Source |
|---|---|---|
| Add an Atom feed via `feedPlugin` once there are blog posts | Virtual template needs no extra file; requires ESM config | https://www.11ty.dev/docs/plugins/rss/ |
| Use directory data files for drafts (layout, noindex) | Reduces repeated front matter via the data cascade | https://www.11ty.dev/docs/data-cascade/ |
| Run the Nu HTML Checker in CI or a hook | Catches invalid markup that Biome and axe do not | https://validator.w3.org/nu/about.html |
| Ensure focus is never hidden by a sticky header; consider the 2.4.13 AAA indicator size | 2.4.11 is AA; 2.4.13 is an AAA aim | https://www.w3.org/TR/WCAG22/#focus-not-obscured-minimum ; https://www.w3.org/WAI/WCAG22/Understanding/focus-appearance.html |
| Add Early Hints and `_redirects` only if needed | Both supported but unneeded for a five-page site | https://developers.cloudflare.com/pages/configuration/serving-pages/ ; https://developers.cloudflare.com/pages/configuration/redirects/ |
| Fingerprint CSS and fonts if long-lived `immutable` caching is wanted | Long max-age is only safe for versioned URLs | https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching |
