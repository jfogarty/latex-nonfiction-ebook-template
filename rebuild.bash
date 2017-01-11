PATH="/home/john/jf/latex-nonfiction-ebook-template/bin:/home/john/jf/latex-nonfiction-ebook-template/bin:/home/john/ct/book/bin:/home/john/ct/book/bin:/home/john/anaconda2/bin:/usr/lib/jvm/java-7-openjdk-amd64/bin:/home/john/scala/scala-2.11.8/bin:/usr/local/texlive/2016/bin/x86_64-linux:/home/john/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
mkdir -p "./all_book/logs"
mkdir -p "./all_book/tex"
cp book.tex   "./all_book"
cp -R ./tex/*        "./all_book/tex"
cp "setParameters.bash" "./all_book"
rm 'setParameters.bash'
cp "BookParameters.tex" "./all_book"
cd "./all_book"
