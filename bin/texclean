#!/bin/bash
# Clean up trash files for a LaTeX .tex file.
# ----------------------------------------------------------------------------
# LaTeX eBook utility tools
# -----------------------------------------------------------------------------
# John Fogarty - https://github.com/jfogarty - johnhenryfogarty@gmail.com
# -----------------------------------------------------------------------------

declare fullScriptName=$_
declare scriptName=$(basename $0)

declare doAll=0
declare trialRun=0
declare verbose=0
declare quiet=0
declare logindex=1
declare rv

#------------------------------------------------------------------------
# Terminate the script with a failure message.
function fail()
{
    local msg=$1
    echo "[$scriptName] *** Failed: $msg"
    exit 666
}

function requireFile()
{
	local fileType=$1
	local fileName=$2
    if [[ ! -e "$fileName" ]]; then
        fail "$fileType input file '$fileName' does not exist"
    fi
}

function checkDir()
{
	local dirName=$1
	local fileName=$2
    if [[ -e "$dirName" ]]; then
        local toFile="$dirName/$fileName"
        if ! [[ -e "$toFile" ]]; then
            echo "*** Suspicious target directory. Clear it yourself first."
            fail "$toFile should exist."
        fi
    fi
}

#------------------------------------------------------------------------
# Run a command and exit if any error code is returned.
function run()
{
    if [[ $trialRun != 0 ]]; then
        echo "--Run:[$@]"
    else
       if [[ $verbose == 1 ]]; then
           echo "- $@"
       fi
       eval "$@"
       local status=$?
       if [[ $status -ne 0 ]]; then
           echo "[$scriptName] *** Error with [$1]" >&2
           exit $status
       fi
       return $status
    fi
}

#------------------------------------------------------------------------
# Remove a specified extension from a filename if its present.
# Return resulting file in rv.
function removeExtension()
{
    local fileName=$1
    local extName=$2
    if [[ "${fileName%.*}.$extName" == "$fileName" ]]; then
        fileName=${fileName%.*}
    fi
    if [[ "${fileName%.*}." == "$fileName" ]]; then
        fileName=${fileName%.*}
    fi
    rv="$fileName"
}

#------------------------------------------------------------------------
# Strip : and = from argument text
function dirArg()
{
    local dirName=$1
    if [[ ${dirName:0:1} == ":" ]] ; then
        dirName=${dirName:1}
    fi
    if [[ "${dirName:0:1}" == "=" ]] ; then
        dirName=${dirName:1}
    fi
    rv="$dirName"
}

#------------------------------------------------------------------------
# Copy files to the target directory conversion (after clearing it)
function copyIfExists()
{
    local theFile=$1
    local theDest=$2
    if [[ -e "$theFile" ]]; then
        run "cp \"$theFile\" \"$theDest\""
    fi
}

#------------------------------------------------------------------------
# Delete a file if it exists
function delIfExists()
{
    local theFile=$1
    if [[ -e "$theFile" ]]; then
        run "rm \"$theFile\""
    fi
}

#------------------------------------------------------------------------
# Selectively delete book files from the directory
function cleanDir()
{
    local bookName=$1
    local -a exts=(
       "4ct" "4dx" "4ix" "4tc" "ain"  "aux" "aux.blg"   "bbl" "bcf" "blg"
       "css" "dvi" "ent" "enx" "html" "idv" "idx" "ilg" "ind" "lg"
       "lof" "log" "los" "lot" "ncx"  "old" "out" "rtf" "run.xml" 
       "synctex.gz" 
       "tmp" "toc" "xref" "xwm")
    if [[ -e "$bookName.tex" ]]; then
      for i in "${exts[@]}"; do
          delIfExists "$bookName.$i"
      done       
    fi
    run "rm -f \"${bookName}ch*.html\""
    run "rm -f \"${bookName}li*.html\""
    run "rm -f \"${bookName}0x.png\""
    delIfExists "idxmake.dvi"
    delIfExists "idxmake.log"
    delIfExists "texput.log"
    delIfExists "BookParameters.old"
}

#------------------------------------------------------------------------
function scriptUsage()
{
    echo "Usage: $scriptName [texfilename]"
    echo "Clean up intermediate and trash files for a LaTeX .tex file."
    echo ""
    echo "-a             clean for all .tex files in the directory."
    echo "-t             trial run -- commands are shown but not executed."
    echo "-q             quiet output during command execution."
    echo "-v             verbose output during command execution."
    echo ""
    echo "All the various intermediate files created during LaTex processing"
    echo "of a file are deleted."
    echo ""	
    exit 1
}

#------------------------------------------------------------------------
function main()
{
    logindex=1 #Start the log numbering over each run.
    if [[ x"$1" == x ]]; then
        scriptUsage 
    fi
    for texFile in "$@"; do
        removeExtension "$texFile" "tex"; local bookName="$rv"
        requireFile "LaTex"  "$bookName.tex"
        if [[ $verbose == 1 ]]; then
            echo "- Cleaning LaTex files for Tex:$bookName.tex"
        fi
        cleanDir "$bookName"
    done
    if [[ $quiet == 0 ]]; then 
        echo "- Done."
    fi
    exit 0
}

OPTIND=1 # Reset in case getopts has been used previously in the shell.
while getopts "h?vqta" opt; do
    case "$opt" in
        h|\?)
            scriptUsage
            exit 0
            ;;
        a)  doAll=1
            ;;            
        v)  verbose=1
            ;;
        q)  quiet=1
            ;;
        t)  trialRun=1
            ;;
    esac
done
shift $((OPTIND-1))
[ "$1" = "--" ] && shift
if [[ $doAll -eq 1 ]]; then
    # When -a selected, make a list of all .tex files and clean all of them.
    shopt -s nullglob
    list=(*.tex)
    main "${list[@]}"
else
    main "$@"
fi

# - End of bash script.

