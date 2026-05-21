# LaTeX Nonfiction Book/eBook Template

[![Build](https://github.com/robertoreale/latex-nonfiction-ebook-template/actions/workflows/build.yml/badge.svg)](https://github.com/robertoreale/latex-nonfiction-ebook-template/actions/workflows/build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![DOI](https://img.shields.io/badge/DOI-10.0000%2Fplaceholder-blue)](CITATION.cff)

A template for technical nonfiction books: **print PDF** (LuaLaTeX), **EPUB3** (make4ht), and **web** (lwarp) from shared LaTeX sources.

For independent self-publishers and small presses — not the big-four trade publishing workflow.

## Quick start

```bash
# Docker (recommended)
docker compose run --rm book just all

# Native
just doctor
just print    # → build/print/book.pdf
just ebook    # → build/ebook/eBook.epub
just web      # → web/dist/index.html
```

See [INSTALL.md](INSTALL.md) and [docs/building.md](docs/building.md).

## Why this exists

Modern books ship in multiple formats. This template keeps one set of chapter files under `tex/` and builds:

| Root file | Output | Engine |
|-----------|--------|--------|
| `book.tex` | Print / POD PDF | LuaLaTeX + biber |
| `eBook.tex` | EPUB3 | make4ht / tex4ebook |
| `book_html.tex` | Static web | lwarp |

## Structure

- `BookParameters.tex` — title, author, ISBN, spine math
- `tex/zzInit.tex` — shared packages and macros
- `tex/bib/book.bib` — bibliography (biblatex + biber)
- `Justfile` — build entry point (replaces legacy `bin/makebook`)

## Book contents

1. **Front matter** — half title, title page, copyright, TOC, preface
2. **Main matter** — introduction + body chapters
3. **Back matter** — endnotes, bibliography, authors cited, index, abbreviations

Many sections are optional via `\Boolean{...}` toggles in `book.tex` / `eBook.tex`.

## Documentation

- [Configuration](docs/configuration.md) — `BookParameters.tex` and booleans
- [Building](docs/building.md) — `just` targets, Docker, CI
- [Publishing](docs/publishing.md) — KDP, EPUB stores, GitHub Pages
- [CHANGES_2026.md](CHANGES_2026.md) — 2026 modernization log

## Legacy

`bin/makebook` is **deprecated** — use `just print` / `just ebook`. Cover tooling (`bin/makecover`, `bin/installcover`) remains for optional cover projects.

## License

MIT — see [LICENSE](LICENSE). Original template by [John Fogarty](https://github.com/jfogarty/latex-nonfiction-ebook-template).
