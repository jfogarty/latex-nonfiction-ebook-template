#!/bin/bash
# Set a \Boolean parameter in a LaTeX .tex file.
# ----------------------------------------------------------------------------
# LaTeX eBook utility tools
# -----------------------------------------------------------------------------
# John Fogarty - https://github.com/jfogarty - johnhenryfogarty@gmail.com
# -----------------------------------------------------------------------------

declare fullScriptName=$_
declare scriptName=$(basename $0)

declare bookName
declare trialRun=0
declare verbose=0
declare quiet=0
declare finalForm=0

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

function getTexParam()
{
    #perl -0ne '"print "[$1]\n" if /\\Boolean{RAWHTML}\s*{(.*)}/' eBook.tex
    local pname=$1
    local cmd='perl -0ne '"'"'print "$1\n" if /\\Boolean{'"$pname"'}\s*{(.*)}/'
    cmd+="' < $bookName.tex"
    evalrv "$cmd"
}

# Set a /Boolean parameter from the book.tex
function setTexParam()
{
    #perl -0ne '$b="RAWHTML";$v="XYZZY";s/(.*\\Boolean{$b}\s*{)(.*)(}.*)/\1$v\3/ ; print $_' eBook.tex > eBook.2
    local pname=$1
    local newValue=$2

    #perl -0ne '$b="RAWHTML";$v="XYZZY";
    local cmd='perl -0ne '"'"'$b="'"$pname"'";$v="'"$newValue"'";'

    #s/(.*\\Boolean{$b}\s*{)(.*)(}.*)/\1$v\3/
    cmd+='s/(.*\\Boolean{$b}\s*{)(.*)(}.*)/\1$v\3/'

    # ; print $_' eBook.tex > eBook.2
    cmd+="; print $_' $bookName.tex > $bookName.tmp"
    evalrv "$cmd"
    if [[ $trialRun == 0 ]]; then
        requireFile "Converted file" "$bookName.tmp"
    fi    
    run "mv \"$bookName.tex\" \"$bookName.old\""
    run "mv \"$bookName.tmp\" \"$bookName.tex\""
}

#------------------------------------------------------------------------
function doSetParam()
{
    local paramName="$1"
    local newValue="$2"
    getTexParam "$paramName"
    local currentValue="$rv"
    vecho "- Current value is [$currentValue]"
    if [[ $trialRun == 0 ]]; then    
        if [[ -z "$currentValue" ]]; then
            fail "$paramName is not in $bookName.tex"
        fi
        if [[ "$currentValue" == "$newValue" ]]; then
            vecho "- $paramName is already set to \"$newValue\" in $bookName.tex"
            exit 0
        fi
    fi
    vecho "--Set $paramName to \"$newValue\" in $bookName.tex as $bookName.tmp"
    setTexParam "$paramName" "$newValue"
}

#------------------------------------------------------------------------
function scriptUsage()
{
    echo "Usage: $scriptName [texfilename] [paramName] [value]"
    echo "Change a boolean value in a .tex file"
    echo ""
    echo "-t    trial run -- commands are shown but not executed."
    echo "-q    quiet output during command execution."
    echo "-v    verbose output during command execution."
    echo ""
    echo "This makes a change to a \Boolean {name} {value} line in a LaTeX"
    echo "file. If the boolean doesn't exist then an error is returned."
    echo ""	
    exit 1
}

#------------------------------------------------------------------------
function main()
{
    if [[ -z "$1" ]]; then
        scriptUsage 
    fi
    removeExtension "$1" "tex"; 
    bookName="$rv"
    local paramName="$2"
    local newValue="$3"
    requireFile "LaTex" "$bookName.tex"
    vecho "- Set $paramName to $newValue in $bookName.tex"
    doSetParam "$paramName" "$newValue"
    vecho "- Done."
    exit 0
}

OPTIND=1 # Reset in case getopts has been used previously in the shell.
while getopts "h?vqt" opt; do
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
    esac
done
shift $((OPTIND-1))
[ "$1" = "--" ] && shift
main "$@"

# - End of bash script.

