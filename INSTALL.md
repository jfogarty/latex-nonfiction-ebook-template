# Installation

## Quick start (recommended)

1. Install [Docker](https://docs.docker.com/get-docker/).
2. Clone this repository.
3. Build all formats:

```bash
git clone https://github.com/robertoreale/latex-nonfiction-ebook-template.git
cd latex-nonfiction-ebook-template
docker compose run --rm book just all
```

Outputs:

| Target | Command | Output |
|--------|---------|--------|
| Print PDF | `just print` | `build/print/book.pdf` |
| EPUB | `just ebook` | `build/ebook/eBook.epub` |
| Web | `just web` | `web/dist/index.html` |

Validate EPUB:

```bash
./bin/epubcheck build/ebook/eBook.epub
```

## Native install (advanced)

Install a full TeX Live 2025+ distribution plus:

- `just` — command runner
- `biber`, `make4ht`, `latexmk`, `lualatex`
- `epubcheck` 5.x (`brew install epubcheck`)
- Optional: `lwarp` (included in TeX Live full)

See the [Dockerfile](Dockerfile) for the canonical package list used in CI.

## Legacy scripts

`bin/makebook` remains as a deprecated bridge to `just print` / `just ebook`. Prefer `just` for all new workflows.

`bin/makebwimages` still uses GIMP for batch greyscale conversion — run manually when preparing print images.

## GitHub Pages

Enable **GitHub Pages** → **Source: GitHub Actions** in repository settings. The `.github/workflows/pages.yml` workflow deploys `web/dist/` on push to `main`.
