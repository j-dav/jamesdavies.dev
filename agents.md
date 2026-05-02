## Core preferences

- Prefer modularity.
- Prefer a test-driven development (TDD) approach.
- Prefer British English in user-facing copy, comments, and documentation.
- Prefer robustness over cleverness.
- Prefer clarity and restraint over heavy abstraction.

## Delivery standards

- Make small, readable diffs with clear intent.
- Favour explicit code and predictable control flow over terse tricks.y
- Validate and sanitise inputs defensively.
- Keep assumptions labelled and easy to inspect.
- Maintain mobile usability (no horizontal scroll, sensible tap targets, stacked layouts).
- Keep accessibility in mind (clear labels, visible focus states, usable controls).

## Change process

- Before coding, note the files you intend to change.
- After coding, summarise what changed, why, and what to smoke-test.
- If a requested change conflicts with these rules, call it out explicitly and propose the smallest safe alternative.

## Site conventions

- Keep one visible `h1` per page template.
- Set `title` and `description` in each page front matter.
- Keep site-wide metadata defaults in `src/_data/site.json`.
- Keep active navigation state accessible with `aria-current="page"`.
