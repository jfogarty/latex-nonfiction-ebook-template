Installation Notes for Latex Book/eBook Template
================================================

Just copy the contents to your directories and use as is. You will need a
complete LaTeX environment, which includes `pdflatex`. This project was
developed on **Linux Mint**. All of the required tools are available for
both **Windows** and Mac **OS X**, but I have not tested it on those platforms.
Some fiddling will no doubt be required. This section describes the tools
that you need on your system and how to get them.

## Prerequisite tools

These tools expect a **bash** commmand line environment as found on most
Linux distributions. Windows and Mac users will may need to do additional
configuration for these.

**perl**, **python**, **java**, **sed**, **stat**, **mkdir**, **rm**, **cp** 
must all be available from the command line and work as expected.

- LaTeX TexLive 2016 : Command line tools to build LaTeX documents
- TeXstudio LaTeX editor : GUI for editing LaTeX documents
- Calibre eBook Manager : GUI for editing and managing ebooks
- ePubCheck : Java based .epub file validity checker
- Pinta : Graphics Editor
- GIMP : GNU Image Manipulation Program
- ebb : MikTeX image bounding box extractor 

#### LaTeX TeXLive 2016

 I **strongly** recommend
that you install [TeX Live 2016](https://www.tug.org/texlive/doc/texlive-en/texlive-en.html).
Almost all of the tools required by this project are already part of the 
TexLive 2016 distribution. If you try to use ad-hoc versions of LaTeX 
and packages, you will spend a very long time debugging your builds.

You will need to make sure that TexLive is in your path (on my system
this is `/usr/local/texlive/2016/bin/x86_64-linux`).

You can check that you have a proper TeXLive install with **tex --version**:

```
  $ which tex # This is a linux command to discover the install path.
      /usr/local/texlive/2016/bin/x86_64-linux/tex
  $ tex --version
      TeX 3.14159265 (TeX Live 2016)
      kpathsea version 6.2.2
      ...

```

#### TeXstudio LaTeX editor

I use [TeXstudio](http://www.texstudio.org/) for interactive editing of all my LaTeX files.
You will find comments in the .tex root files that refer to using TeXstudio to
build the PDF versions interactively.

```
  $ which texstudio # This is a linux command to discover the install path.
      /usr/bin/texstudio
  $ texstudio # This should start the interactive GUI.
      # Select [HELP], Select [About TeXstudio]
          TeXstudio 2.6.6 (hg 4099)
          Using Qt Version 4.8.6, compiled with Qt 4.8.4 D
```

Next, make sure you add the Author Index generator to the build commands so
you can rebuild it within TeXstudio.

```
  $ which authorindex
      /usr/local/texlive/2016/bin/x86_64-linux/authorindex
  $ texstudio 
      Select [Options], Select [Configure TeXstudio], Select [Build]
      In the User Commands section
      Add "user0:Author Index" and the command: "authorindex %"
```

In Configure|Shortcuts, make sure that Menus|Tools|User has an entry of the form:

```
  Menus
      ...
      User
          1:Author Index    Alt-Shift-F1   Alt-Shift-F!
```

#### Calibre eBook Manager

This is the essential tool for editing and managing eBooks. It lets you load
the book, edit metadata and content, and set up a server for connecting to
eReaders such as iPads, iPhones, Kindles, etc. to download books.

Get if from [Calibre download](http://calibre-ebook.com/download).

Verify the install with:

```
  $ which calibre
      /usr/bin/calibre
  $ calibre --version
      calibre (calibre 2.72)
```

#### ePubCheck

You must create fully validated .epub files before attempting to publish
them. This means you must run ePubCheck since it is the same tool the pubisher
will run before accepting your book. *ePubCheck* is a java tool. 

The `./bin/epubcheck` script expects that the jar file for epubcheck is
already located at **$HOME/LaTeX/epubcheck/target/epubcheck.jar**. If you
don't have it, then you can get it via:

```
    git clone https://github.com/IDPF/epubcheck.git
    cd epubcheck
    mvn install    
```
Make sure to read its [README.md](https://github.com/IDPF/epubcheck/blob/master/README.md) file, since this also requires it own set 
of tools such as Maven.

Verify the install with:

```
  $ ./bin/epubcheck -h
      EpubCheck v4.0.2-SNAPSHOT
      ... 
```

#### Pinta Graphics Editor

You will need a good graphics editor for manipulating many images. I mostly
use [Pinta](https://pinta-project.com/pintaproject/pinta/) for simple things
like resizing, format conversion, grayscale. 

Pinta is a GUI only application, although you can start it from the command
line with:

```
    $ which pinta
        /usr/bin/pinta
    $ pinta
```

#### GIMP - GNU Image Manipulation Program

[Gimp](https://www.gimp.org/) is used to convert images from color to
grayscale in `makebook`, and is a much more powerful tool than Pinta
(although it is corresponding more complex, with a significant learning curve).

Verify the install with:

```
    $ which gimp
        /usr/bin/gimp
    $ gimp --version
        GNU Image Manipulation Program version 2.8.10
```

#### ebb - Bounding Box Extractor 

Ebb is used to create .xbb files which describe the size of images when
building LaTeX for HTML. 

```
    $ which ebb
        ebb: /usr/bin/ebb
    $ ebb --version
        This is ebb Version 20160307
```    

## Common Installation and Runtime Issues

#### Undefined control sequence - pgfsys@svg@newline -- Hnewline.fix

When building html, epub, and mobi files, you may encounter a **lot** of
error messages in during the tex4ht conversion. The log file will contain
messages that look like:

```
	! Undefined control sequence.
	\pgfsys@svg@newline ->\Hnewline 
``` 

To fix these I edited my
**/usr/local/texlive/2016/texmf-dist/tex/generic/pgf/systemlayer/pgfsys-tex4ht.def** file. 
At Line 83 in pgfsys-tex4ht.def I changed

```
	\def\pgfsys@svg@newline{\Hnewline}
```
to
```
	% --- jfogarty 8sep2016 Patch for tex4ht
	%\def\pgfsys@svg@newline{\Hnewline}% FROM https://bugzilla.redhat.com/attachment.cgi?id=978709
	\def\pgfsys@svg@newline{{?nl}}
```
Which fixed the huge number of undefined control sequence messages.

#### [Improving Poor Resolution Equations](http://tex.stackexchange.com/questions/43772/latex-xhtml-with-tex4ht-bad-quality-images-of-equations) in EPub Files/HTML

The **tex4ht** program by default converts equations into .png image files,
but at a fairly low resolution. Find your version of tex4ht with:

```
which tex4ht
```

on my system this is `/usr/local/texlive/2016/bin/x86_64-linux/tex4ht`.
The configuration file is called `tex4ht.env` which is in 
`/usr/local/texlive/2016/texmf-dist/tex4ht/base/unix` for my system.
There is also a `win32` version.  

Follow [these instructions](http://tex.stackexchange.com/questions/43772/latex-xhtml-with-tex4ht-bad-quality-images-of-equations) as needed for your system.

I used `dvipng` at a higher resolution which is part of the linux TeXlive
distribution.

### Replacing Poor Resolution Equations With Your Own Images

PdfLaTeX typesetting of math works fine, but htlatex does a poor job 
when aligning maths and often generates bad html to boot. Using images
for equations is now my preferred option. 

It's quite easy to wrapper your equations with the `\BookMath` command
which will look for an image when you are generating HTML or eBooks.  

The workaround is to format for book, and then display the PDF at 400% with
Okular. Then place a selection box around each equation, leaving
about a half character of whitespace top and bottom. 
Make sure to capture the entire text (not page) width (about 1730 pixels).

Save each equation as a `.png` file into the `./images/equations` directory.
This makes a nice size for the image in the ePub PDF file. 

### GIMP Hangs in Makebook 

`makebook` uses GIMP scripting to do conversion of images to grayscale. 
It is strangely senstive to image metadata and will hang whenever it gets
an image it doesn't like. You should manually convert questionable images
to their `imageName_BW.png` or `imageName_BW.jpg` versions using Pinta.

Verify the `ebb` Bounding Box Extractor is installed. 

### Ebb Missing or Fails on Windows

The `ebb` Bounding Box Extractor is part of MiKTeX on Windows. If it doesn't exist then your LaTeX install is messed up. This seems to happen on Windows a lot (which I don't even try to support). This link may help: http://www.fastfixerror.com/whats-ebb-exe-how-to-fix-it-is-it-a-virus.html

### Odd Command Errors

If you have strange things happening with the scripts, its often because some
fundamental command is missing or the path finds some other program of the
same name that does something completely different. Here are the paths for
the required commands on my system. Yours will of course be different, but
it shouldn't be too hard to see if something is fubar.

```
    $ which which
        /usr/bin/which
        
    $ whereis whereis
        whereis: /usr/bin/whereis /usr/bin/X11/whereis /usr/share/man/man1/whereis.1.gz
    $ which whereis
        /usr/bin/whereis

    $ which sed
        /bin/sed
    $ whereis sed
        sed: /bin/sed /usr/share/man/man1/sed.1.gz

    $ which stat
        /bin/stat
    $ whereis stat
        stat: /usr/bin/stat /usr/bin/X11/stat /usr/share/man/man1/stat.1.gz /usr/share/man/man2/stat.2.gz

    $ which mkdir
        /bin/mkdir
    $ whereis mkdir
        mkdir: /bin/mkdir /usr/share/man/man1/mkdir.1.gz /usr/share/man/man2/mkdir.2.gz

    $ which rm
        /bin/rm
    $ whereis rm
        rm: /bin/rm /usr/share/man/man1/rm.1.gz

    $ which cp
        /bin/cp
    $ whereis cp
        cp: /bin/cp /usr/share/man/man1/cp.1.gz
 
    $ which perl
        /usr/bin/perl
    $ whereis perl
        perl: /usr/bin/perl /etc/perl /usr/lib/perl /usr/bin/X11/perl /usr/share/perl /usr/share/man/man1/perl.1.gz

    $ which python
        /usr/bin/python
    $ whereis python
        python: /usr/bin/python3.4m /usr/bin/python3.4 /usr/bin/python /usr/bin/python2.7 /etc/python3.4 /etc/python /etc/python2.7 /usr/lib/python2.6 /usr/lib/python3.4 /usr/lib/python2.7 /usr/bin/X11/python3.4m /usr/bin/X11/python3.4 /usr/bin/X11/python /usr/bin/X11/python2.7 /usr/local/lib/python3.4 /usr/local/lib/python2.7 /usr/include/python3.4m /usr/include/python2.7 /usr/share/python /usr/share/man/man1/python.1.gz

    $ which java
        /usr/lib/jvm/java-7-openjdk-amd64/bin/java
    $ whereis java
        java: /usr/bin/java /usr/bin/X11/java /usr/share/java /usr/share/man/man1/java.1.gz
```
