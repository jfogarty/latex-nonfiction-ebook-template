# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased] - 2026-05-21

### Added

- `just`-based build system (`Justfile`, `latexmkrc`) with `print`, `ebook`, `web`, `all`, `validate`, `doctor` targets
- Docker + devcontainer reproducible TeX Live environment
- GitHub Actions CI (build, pages, release, lint)
- LuaLaTeX primary engine with pdfLaTeX fallback (`USELUATEX`)
- `biblatex` + `biber` replacing BibTeX
- EPUB3 pipeline (`build.lua`, `epub.css`, EPUBCheck 5)
- Web target via `lwarp` (`book_html.tex`, `tex/zzWeb.tex`, GitHub Pages workflow)
- Repo hygiene: `CITATION.cff`, `CONTRIBUTING.md`, issue/PR templates, Dependabot
- `CHANGES_2026.md` change-control log

### Changed

- Modernized `book.tex`, `eBook.tex`, `tex/zzInit.tex`, `BookParameters.tex`
- Replaced `\let\footnote=\endnote` with `enotez`
- Trimmed `README.md`; moved reference material to `docs/`
- Slimmed `INSTALL.md` to Docker-first instructions

### Removed

- `rebuild.bash` (orphan)
- Legacy `idxmake.4ht`, `tex4ht.env` moved to `legacy/`

### Deprecated

- `bin/makebook` — use `just print` / `just ebook`

## [Legacy] - 2017

Initial template release (CreateSpace-era POD + tex4ebook EPUB/MOBI).
