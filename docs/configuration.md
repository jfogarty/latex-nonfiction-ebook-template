# Configuration

Book metadata and layout parameters live in `BookParameters.tex`. Build toggles live in `book.tex` (print) and `eBook.tex` (EPUB/HTML).

## BookParameters.tex

Edit title, author, ISBN, publisher, page count, and cover dimensions here. All root `.tex` files `\input{BookParameters.tex}`.

Key fields:

- `\TheMainTitle`, `\TheSubTitle`, `\TheAuthor`
- `\PrintISBN`, `\EbookISBN`
- `\TotalPageCount` — update after final PDF page count is known (affects spine width)

## Boolean parameters

Use `\Boolean{NAME}{true|false}` in root files:

| Boolean | Default (print) | Purpose |
|---------|-----------------|---------|
| `USELUATEX` | true | LuaLaTeX engine |
| `FINALFORM` | false | Draft vs final (missing images allowed when false) |
| `NOINDEX` | false | Skip index generation |
| `NOAUTHORS` | false | Skip Authors Cited section |
| `LEGACYTOC` | false | Use legacy `shorttoc` summary TOC |
| `IMAGEMATH` | false (print) | Render equations as PNG images (eBook default: true) |

See [CONTRIBUTING.md](../CONTRIBUTING.md) for the full list.

## KDP / Ingram spine

Paper thickness constants in `BookParameters.tex` default to KDP white 50 lb. Uncomment alternatives for Ingram or Blurb stocks.
