# latexmkrc — LuaLaTeX + biber (2026 template)
$pdf_mode = 4;           # LuaLaTeX
$bibtex_use = 2;         # biber
$recorder = 1;
$bibtex = 'biber %O %B';
$makeindex = 'makeindex %O -o %D %S';
$max_repeat = 5;

# Default output directory (overridden by Justfile -outdir)
$out_dir = 'build/print';

# Clean extra biblatex/tex4ht artifacts
$clean_ext = 'bbl bcf blg run.xml 4ct 4tc idv lg tmp xref html css';

# Ensure synctex for preview
$lualatex = 'lualatex -synctex=1 %O %S';
