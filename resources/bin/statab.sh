#! /bin/bash
# Wrapper for Stata batch-mode which:
#  -issues an informative error msg and appropriate (possibly non-zero) return code
#  -allows an implicit -do- when called with just a do file
#  -fixes timezone when run under Cygwin
#  -remove the forced-generated log file
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

#MSVC-compiled programs run under Cygwin can't interpret the TZ
# var correctly so wrongly return UTC/GMT. Solution: unset TZ for this shell
# http://stackoverflow.com/questions/11655003/
if [ "$OS" = "Windows_NT" ]; then
	unset TZ
fi

# in batch mode, normally nothing sent to stdout
# but plugins can and some generate lots of comments
$STATABATCH $cmd "$@" &>/dev/null &

#Move the default external log file so that another can be made
#checks if var is sets vs (set to "" or unset)
if [ -z "$STATATMP" ]; then
	if [ "$OS" = "Windows_NT" ]; then
		#under Cygwin reassigns TEMP so can't get original. Use default.
		STATATMP=$LOCALAPPDATA/Temp
	else
		STATATMP=$TMPDIR
	fi
fi
time_str=$(date +"%Y-%m-%d-%H-%M-%S")
log_base=${log%.*}
log2="${STATATMP}/${log_base}-${time_str}.log"

#On Unix can move right away 
if [ "$OS" != "Windows_NT" ]; then
	#really should poll for file creation, but I might not have guessed the right log file name so want time-out
	sleep 3s
	mv "${log}" "${log2}"
fi

wait
rc=$?

#On Windows have to wait for it to finish as the file is locked
if [ "$OS" == "Windows_NT" ]; then
	mv "${log}" "${log2}"
fi

#Return the real error by checking the log
if [ $rc == "0" ]
then
    # use --max-count to avoid matching final line ("end of do-file") when
    # do-file terminates with error
    if egrep --before-context=1 --max-count=1 "^r\([0-9]+\);$" "$log2"
    then
        rc=1
    fi
fi

#rm "$log2"

exit $rc
