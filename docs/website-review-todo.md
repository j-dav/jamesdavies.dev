# Website Review (2026-02-24)

## Recommendations

1. Improve header link contrast in light mode.
   - Header has a dark background but links inherit dark text, reducing readability.
2. Add semantic page headings (`h1`) on each route.
   - Home, Work, Projects, and Blog currently have no `h1`, which hurts accessibility and SEO.
3. Add page metadata for sharing/search.
   - Include `meta description`, Open Graph/Twitter tags, and canonical URLs in the base layout.
4. Fill out the Blog page with a useful empty state or posts collection.
   - The current page is visually empty and looks incomplete.
5. Improve project/work CTA structure.
   - Add clear primary actions (for example: "View project", "Read CV", "Contact").
6. Add active navigation styles.
   - Highlight the current route in the top nav for orientation.
7. Add basic accessibility checks to CI.
   - Run an automated check (e.g. axe/lighthouse) on build output.

## TODO

- [x] Set explicit header/nav text color and hover/focus states for both light and dark themes.
- [x] Add one `h1` per page template (`index.njk`, `work.njk`, `projects.njk`, `blog.njk`).
- [x] Add site-wide metadata support in `src/_layouts/base.njk`.
- [x] Implement Blog empty state content with links to upcoming posts.
- [x] Add "selected" state styling for nav links.
- [x] Add a "featured project" block to the homepage with one clear outbound CTA.
- [x] Add an accessibility check script and run it in CI.
