#!/bin/bash
# Sets the TotalPageCount from PdfLaTeX log in BookParameters.tex.
# ----------------------------------------------------------------------------
# LaTeX eBook utility tools
# -----------------------------------------------------------------------------
# John Fogarty - https://github.com/jfogarty - johnhenryfogarty@gmail.com
# -----------------------------------------------------------------------------

declare fullScriptName=$_
declare scriptName=$(basename $0)

# Scripts calls other scripts in the same directory by simple name.
declare absScriptFile=$(readlink -f "$0")
declare absScriptPath=$(dirname "$absScriptFile")
PATH=$absScriptPath:$PATH

declare parametersName
declare totalPageCount

declare trialRun=0
declare verbose=0
declare quiet=0
declare rv

#------------------------------------------------------------------------
# echo text if not quiet
function qecho()
{
    if [[ $quiet -eq 0 ]]; then
        echo "$@"
    fi
}

# echo text if in verbose mode.
function vecho()
{
    if [[ $verbose -eq 1 ]]; then
        echo "$@"
    fi
}

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
function evalrv()
{
    #rv=`$cmd`  # Odd perl issues. Output to tmp file instead.
    if [[ $trialRun != 0 ]]; then
        echo "--EvalRV:[$@]"
        rv=""
    else        
        eval $1 > x.tmp 
        rv=`cat x.tmp`
        rm x.tmp
    fi
}

function getTotalPageCount()
{
    #LOG FILE: Output written on book.pdf (112 pages, 2297932 bytes).
    #perl -0ne '"print "[$1]\n" if /Output written on book.pdf \((.*) pages,}/' logfile.log
    local logFileName=$1
    local cmd='perl -0ne '"'"'print "$1\n" if /Output written on book.pdf \((.*) pages,/'
    cmd+="' < $logFileName.log"
    evalrv "$cmd"
}

#------------------------------------------------------------------------
function doGetTotalPageCount()
{
    local logFileName=$1
    getTotalPageCount "$logFileName"
    totalPageCount="$rv"
    if [[ -z "$totalPageCount" ]]; then
        fail "Output page count not found in '$logFileName.log'"
    fi
    if [[ $verbose -eq 1 ]]; then
        vecho "- Total Page Count in $logFileName is [$totalPageCount]."
    else
        qecho "- Total Page Count for printed book is [$totalPageCount]."
    fi
}

#------------------------------------------------------------------------
function scriptUsage()
{
    echo "Usage: $scriptName [options] [PdfLatex Log file name]"
    echo "Set the TotalPageCount in a BookParameters.tex LaTeX file from a log."
    echo ""
    echo "Options:"
    echo "  -t    trial run: commands are shown but not executed"
    echo "  -q    quiet output during command execution"
    echo "  -v    verbose output during command execution"
    echo "  -v    verbose output during command execution"
    echo "  -f=[file]  file name [defaults to BookParameters.tex]"
    echo ""
    echo "This makes a change to TotalPageCount{value} line in the BookParameters.tex"
    echo "file by scanning the PdfLaTeX log file and finding the page count in it."
    echo ""
    exit 1
}

#------------------------------------------------------------------------
function main()
{
    if [[ -z "$1" ]]; then
        scriptUsage 
    fi
    removeExtension "$1" "log"
    local logFileName="$rv"
    requireFile "PdfLaTex final output log" "$logFileName.log"

    removeExtension "$parametersName" "tex"; 
    parametersName="$rv"
    requireFile "LaTex Book Parameters" "$parametersName.tex"

    doGetTotalPageCount "$logFileName"
    run "setBookParameter '-f$parametersName' TotalPageCount $totalPageCount"
    exit 0
}

parametersName="BookParameters"
OPTIND=1 # Reset in case getopts has been used previously in the shell.
while getopts "h?vqtf:" opt; do
    case "$opt" in
        h|\?)
            scriptUsage
            exit 0
            ;;
        v)  verbose=1
            ;;
        q)  quiet=1
            ;;
        t)  trialRun=1
            ;;
        f)  dirArg "$OPTARG"; parametersName="$rv"
            ;;            
    esac
done
shift $((OPTIND-1))
[ "$1" = "--" ] && shift
main "$@"

# - End of bash script.

