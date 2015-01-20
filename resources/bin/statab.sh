#! /bin/bash
# Wrapper for Stata batch-mode which:
#  -issues an informative error msg and appropriate (possibly non-zero) return code
#  -allows an implicit -do- when called with just a do file
# Requirements: set $STATABATCH (e.g. 'stata-mp -b')

# updated from Phil Schumm's version at https://gist.github.com/pschumm/b967dfc7f723507ac4be

args=$#  # number of args
    

# Figure out where the log will be
cmd=""
if [ "$1" = "do" ] && [ "$args" -gt 1 ]
then
    log="`basename "$2" .do`.log"
    # mimic Stata's behavior (stata -b do "foo bar.do" -> foo.log)
    log=${log/% */.log}
# Stata requires explicit -do- command, but we relax this to permit just the
# name of a single do-file
elif [ "$args" -eq 1 ] && [ "${1##*.}" = "do" ] && [ "$1" != "do" ]
then
    cmd="do"
    log="`basename "$1" .do`.log"
    log=${log/% */.log}
else
    log="stata.log"    
fi

# in batch mode, normally nothing sent to stdout
# but plugins can and some generate lots of comments
$STATABATCH $cmd "$@" 2>&1 | tail -100 > $log.extra
rc=$?

# delete $log.extra if empty
if ! [ -s $log.extra ]
then rm $log.extra
fi

#Return the real error by checking the log
if [ $rc != "0" ]
then
    exit $rc
else
    # use --max-count to avoid matching final line ("end of do-file") when
    # do-file terminates with error
    if egrep --before-context=1 --max-count=1 "^r\([0-9]+\);$" "$log"
    then
        exit 1
    fi
fi
