# Building

## Commands

```bash
just doctor     # verify toolchain
just clean      # remove artifacts
just print      # LuaLaTeX PDF
just ebook      # EPUB3 via make4ht
just web        # HTML via lwarp
just all        # all three
just validate   # print + ebook + epubcheck
```

## Output locations

| Format | Path |
|--------|------|
| Print PDF | `build/print/book.pdf` |
| EPUB | `build/ebook/eBook.epub` |
| Web | `web/dist/index.html` |

## Docker

```bash
docker compose build
docker compose run --rm book just all
docker compose run --rm book ./bin/epubcheck build/ebook/eBook.epub
```

## CI

GitHub Actions (`.github/workflows/build.yml`) runs `just print`, `just ebook`, and `just web` in the Docker image on every push.

## Troubleshooting

1. Run `just clean` then rebuild.
2. Ensure `biber` runs (biblatex): check `build/print/book.bbl` exists.
3. For EPUB failures, inspect `test-results/build/ebook-*.log.txt`.
4. For missing fonts under LuaLaTeX, set `\Boolean{USELUATEX}{false}` temporarily.
