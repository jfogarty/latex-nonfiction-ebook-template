# CHANGES_2026 — Template Modernization Change Control

**Branch:** `modernize/2026`  
**Date:** 2026-05-21  
**Status:** Implementation complete (Phase 0–8); commit gate deferred (Phase 9)

## Summary

Modernized the 2017 LaTeX nonfiction book/eBook template to 2026 standards: `just` build system, Docker/devcontainer, GitHub Actions, LuaLaTeX+biber print path, tex4ebook EPUB3, lwarp web seed, and repo hygiene files.

## Phase Map (commit gate — not yet committed)

| Phase | Planned commit type | Key files | Validation evidence |
|-------|---------------------|-----------|---------------------|
| 0 | `chore: preflight baseline and branch` | `state.md`, `test-results/baseline/` | `test-results/baseline/baseline-pdflatex-20260521-120347.log.txt` |
| 1 | `feat: just-based build system and Docker` | `Justfile`, `latexmkrc`, `Dockerfile`, `docker-compose.yml`, `.devcontainer/`, `.editorconfig`, `.gitignore`, `.gitattributes` | `test-results/build/docker-build.log.txt` |
| 2 | `ci: GitHub repo hygiene and workflows` | `.github/workflows/*`, `CITATION.cff`, `CONTRIBUTING.md`, `CHANGELOG.md`, lint configs | `.github/workflows/build.yml` (YAML present) |
| 3 | `feat: LaTeX modernization LuaLaTeX biblatex enotez` | `book.tex`, `eBook.tex`, `tex/zzInit.tex`, `BookParameters.tex`, `tex/zzAbbr.tex`, `tex/introduction.tex` | `test-results/build/print-iter8.log.txt` |
| 4 | `feat: EPUB3 tex4ebook pipeline` | `eBook.cfg`, `epub.css`, `build.lua`, `bin/epubcheck`, `bin/ace-validate` | `test-results/epubcheck/epubcheck-final-run.log.txt` |
| 5 | `feat: lwarp web target seed` | `book_html.tex`, `tex/zzWeb.tex`, `web/_config.yml` | `test-results/build/web-final-run.log.txt` (PDF only; HTML pending) |
| 6 | `chore: repository housekeeping` | `legacy/`, slim `INSTALL.md`, `README.md`, `docs/` | File moves verified |
| 7 | `test: validation loop artifacts` | `test-results/build/*`, `test-results/epubcheck/*` | See `test-results/MODERNIZATION_PROOF.md` |
| 8 | `docs: change control and proof report` | `CHANGES_2026.md`, `test-results/MODERNIZATION_PROOF.md`, `CHANGELOG.md` | This file |

## Validation Results (2026-05-21)

| Target | Result | Artifact |
|--------|--------|----------|
| Print PDF | **PASS** | `build/print/book.pdf` (43 pages, ~888 KB) |
| EPUB | **PARTIAL** | `build/ebook/eBook.epub` (~823 KB); EPUBCheck: 2 errors |
| Web HTML | **FAIL** | `build/web/book_html.pdf` only; lwarp HTML conversion incomplete |
| Docker | **PASS** | Image `latex-book-test:latest` built |

## Not Yet Done (Phase 2 follow-up)

- EPUBCheck zero-error convergence (remaining `eBookch2.xhtml` anchor nesting from tex4ht index/cross-links)
- Full lwarp HTML output to `web/dist/index.html`
- `nameauth` / richer Authors Cited appendix (deferred: `NOAUTHORS=true` on EPUB)
- `book.yaml` metadata renderer, single-source `main.tex`, `bib2gls`, `tagpdf`/`pdfx`, themes, per-store distribution
- GitHub Pages enablement (repo setting)

## Technical Decisions Applied

- Preserved `book.tex` and `eBook.tex` as separate roots
- LuaLaTeX primary (`USELUATEX`); pdfLaTeX/tex4ht for EPUB
- Dropped `\let\footnote=\endnote`; `enotez` (print) / `endnotes` (EPUB)
- `biblatex`+`biber` replacing BibTeX
- EPUBCheck 5 via Homebrew / `bin/epubcheck`
- acro v3 migration (`tag` property, `include={}` lists)
