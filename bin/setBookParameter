#!/bin/bash
# Set a named value in a LaTeX BookParameters.tex file.
# ----------------------------------------------------------------------------
# LaTeX eBook utility tools
# -----------------------------------------------------------------------------
# John Fogarty - https://github.com/jfogarty - johnhenryfogarty@gmail.com
# -----------------------------------------------------------------------------

declare fullScriptName=$_
declare scriptName=$(basename $0)

declare parametersName
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
        run "rm '$theFile'"
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

function getBookParam()
{
    local pname=$1
    local cmd='perl -0ne '"'"'print "$1\n" if /\\'"$pname"'{(.*)}/'
    local cmd+="' < $parametersName.tex"
    evalrv "$cmd"
}

# Set a /Boolean parameter from the book.tex
function setDefParam()
{
    #perl -0ne '$b="RAWHTML";$v="XYZZY";s/(.*\\$b\s*{)(.*)(}.*)/\1$v\3/ ; print $_' BookParameters.tex > BookParameters.tmp
    local pname=$1
    local newValue=$2

    #perl -0ne '$b="RAWHTML";$v="XYZZY";
    local cmd='perl -0ne '"'"'$b="'"$pname"'";$v="'"$newValue"'";'

    #s/(.*\\$b\s*{)(.*)(}.*)/\1$v\3/g
    cmd+='s/(.*\\$b\s*{)(.*)(}.*)/\1$v\3/'

    # ; print $_' eBook.tex > eBook.2
    cmd+="; print $_' $parametersName.tex > $parametersName.tmp"
    evalrv "$cmd"
    if [[ $trialRun == 0 ]]; then
        requireFile "Converted file" "$parametersName.tmp"
    fi    
    run "mv \"$parametersName.tex\" \"$parametersName.old\""
    run "mv \"$parametersName.tmp\" \"$parametersName.tex\""
}

#------------------------------------------------------------------------
function doSetDefParam()
{
    local paramName="$1"
    local newValue="$2"
    getBookParam "$paramName"
    local currentValue="$rv"
    vecho "- The value of '$paramName' is [$currentValue]"
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
    setDefParam "$paramName" "$newValue"
}

#------------------------------------------------------------------------
function scriptUsage()
{
    echo "Usage: $scriptName [paramName] [value]"
    echo "Change a parameter value in a BookParameters.tex LaTeX file."
    echo ""
    echo "Options:"
    echo "  -t    trial run: commands are shown but not executed"
    echo "  -q    quiet output during command execution"
    echo "  -v    verbose output during command execution"
    echo "  -f=[file]  file name [defaults to BookParameters.tex]"
    echo ""
    echo "This makes a change to a \name{value} line in a LaTeX file"
    echo "If the name doesn't exist then an error is returned."
    echo ""
    echo "Omit the [value] to just display the specified parameter."
    echo ""	
    exit 1
}

#------------------------------------------------------------------------
function main()
{
    if [[ -z "$1" ]]; then
        scriptUsage 
    fi
    removeExtension "$parametersName" "tex"; 
    parametersName="$rv"
    local paramName="$1"
    local newValue="$2"
    requireFile "LaTex Book Parameters" "$parametersName.tex"
    if [[ -z "$newValue" ]]; then
        getBookParam "$paramName"
        if [[ $verbose -eq 0 ]]; then
            echo "$rv"
        else
            echo "$paramName{$rv}"
        fi
    else
        vecho "- Set $paramName to $newValue in $parametersName.tex"
        doSetDefParam "$paramName" "$newValue"
        vecho "- Done."
    fi
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

