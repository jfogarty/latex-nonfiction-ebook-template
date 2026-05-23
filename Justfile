# LaTeX Nonfiction Book Template — build recipes (2026)
set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

print_dir := "build/print"
ebook_dir := "build/ebook"
web_dir := "build/web"
web_dist := "web/dist"

default:
    @just --list

# Remove build artifacts
clean:
    rm -rf {{print_dir}} {{ebook_dir}} {{web_dir}} {{web_dist}}
    latexmk -C book.tex eBook.tex book_html.tex 2>/dev/null || true
    rm -f *.aux *.bbl *.bcf *.blg *.fdb_latexmk *.fls *.log *.out *.run.xml *.synctex.gz *.toc *.idx *.ind *.ilg *.ent *.los *.lof *.lot *.4ct *.4tc *.tmp *.xref *.html

# Print PDF via LuaLaTeX + latexmk + biber
print:
    mkdir -p {{print_dir}}
    latexmk -lualatex -outdir={{print_dir}} -interaction=nonstopmode -f book.tex
    @test -f {{print_dir}}/book.pdf && echo "[PASS] {{print_dir}}/book.pdf"

# EPUB via tex4ebook (pdfLaTeX + make4ht)
ebook:
    mkdir -p {{ebook_dir}}
    tex4ebook --format epub3 -d {{ebook_dir}} -c eBook.cfg eBook.tex || true
    @if [ -f {{ebook_dir}}/eBook.epub ]; then echo "[PASS] {{ebook_dir}}/eBook.epub"; \
    elif [ -f eBook.epub ]; then mv eBook.epub {{ebook_dir}}/ && echo "[PASS] {{ebook_dir}}/eBook.epub"; \
    else echo "[FAIL] eBook.epub not found" && exit 1; fi

# Web HTML via lwarp
web:
    mkdir -p {{web_dir}} {{web_dist}}
    cp book_html.tex {{web_dir}}/
    lualatex -shell-escape -output-directory={{web_dir}} -interaction=nonstopmode -halt-on-error=0 book_html.tex
    lualatex -shell-escape -output-directory={{web_dir}} -interaction=nonstopmode -halt-on-error=0 book_html.tex
    cd {{web_dir}} && lwarpmk html1 book_html || true
    cp -f {{web_dir}}/book_html.html {{web_dist}}/index.html
    cp -f {{web_dir}}/lwarp.css {{web_dist}}/ 2>/dev/null || true
    @test -f {{web_dist}}/index.html && echo "[PASS] {{web_dist}}/index.html"

# Build all formats
all: print ebook web

# Run EPUBCheck + smoke checks
validate: print ebook
    ./bin/epubcheck {{ebook_dir}}/eBook.epub
    @test -f {{print_dir}}/book.pdf

# Open print PDF (macOS)
preview:
    open {{print_dir}}/book.pdf 2>/dev/null || xdg-open {{print_dir}}/book.pdf 2>/dev/null || echo "Preview: {{print_dir}}/book.pdf"

# Check toolchain prerequisites
doctor:
    @echo "=== Toolchain ==="
    @for cmd in just latexmk lualatex pdflatex biber make4ht makeindex; do \
        printf "  %-12s " "$cmd"; command -v "$cmd" >/dev/null && echo OK || echo MISSING; \
    done
    @echo "=== Optional ==="
    @for cmd in docker epubcheck chktex lwarpmk; do \
        printf "  %-12s " "$cmd"; command -v "$cmd" >/dev/null && echo OK || echo optional; \
    done
    @kpsewhich libertinus.sty >/dev/null && echo "  libertinus    OK" || echo "  libertinus    MISSING"
    @kpsewhich biblatex.sty >/dev/null && echo "  biblatex      OK" || echo "  biblatex      MISSING"
