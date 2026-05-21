# Publishing

This template targets independent self-publishers using:

- **Print:** Amazon KDP (formerly CreateSpace), IngramSpark
- **eBooks:** EPUB3 for Apple Books, Kobo, etc.
- **Web:** GitHub Pages preview via lwarp

## Print (KDP / Ingram)

1. Build final PDF: `\Boolean{FINALFORM}{true}` in `book.tex`, then `just print`.
2. Update `\TotalPageCount` in `BookParameters.tex` from the log file.
3. Upload `build/print/book.pdf` to your POD vendor.

## EPUB

1. `just ebook && ./bin/epubcheck build/ebook/eBook.epub`
2. Fix any EPUBCheck errors before store submission.
3. Optional: `./bin/ace-validate build/ebook/eBook.epub` for accessibility report.

## ISBN and identifiers

Purchase ISBN blocks from [MyIdentifiers](https://www.myidentifiers.com/) or your country's agency. Set `\PrintISBN` and `\EbookISBN` in `BookParameters.tex`.

## Deferred (not in 2026 pass)

- Per-store `bin/distribute` helper
- `book.yaml` metadata renderer
- PDF/UA tagging (`tagpdf`, `pdfx`)

See [CHANGES_2026.md](../CHANGES_2026.md) for the full deferred list.
