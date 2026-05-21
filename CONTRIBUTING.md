# Contributing

Thanks for improving the LaTeX nonfiction book template.

## Build entry point

Use **`just`** (not legacy `bin/makebook`):

```bash
just doctor    # check toolchain
just print     # LuaLaTeX PDF → build/print/book.pdf
just ebook     # EPUB3 → build/ebook/eBook.epub
just web       # lwarp HTML → web/dist/
just all       # all formats
just validate  # print + ebook + epubcheck
```

Docker (recommended):

```bash
docker compose run --rm book just all
```

## Boolean parameters

Book options use `\Boolean{NAME}{true|false}` in `book.tex` / `eBook.tex`, defined in `BookParameters.tex`. Modern code may prefer `\newtoggle` from `etoolbox`; both patterns coexist for backward compatibility.

Key booleans added in 2026:

| Boolean | Default | Purpose |
|---------|---------|---------|
| `USELUATEX` | true | LuaLaTeX engine (false → pdfLaTeX fallback) |
| `ACCESSIBLE` | true | Accessibility metadata in EPUB |
| `USESIUNITX` | true | Load `siunitx` for units |
| `LEGACYTOC` | false | Use legacy `shorttoc` summary TOC |

## Pull requests

1. Branch from `master` or `modernize/2026`.
2. Run `just all` and `./bin/epubcheck build/ebook/eBook.epub`.
3. Capture logs under `test-results/` if fixing build issues.
4. Update docs when behavior changes.

## Code of conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
