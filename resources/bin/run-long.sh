#!/bin/bash
# For long jobs, use nice and email when finished
# Requirements: Run in root/code/
# to start, end, do:
#   nohup run-long.sh script_name "message" > temp/lastrun/run-long.log &
#   killall -9 stata-mp

# Which file
if [ "$1" = "" ]
then
	#list some defaults
    torun=foo
else
    torun=$1
fi

# could put nice in front of this
#nice -n10 statab.sh do $torun.do
statab.sh do code/$torun.do
ret_code=$?
if [ $ret_code -eq 0 ]; then
	normalize_last_run.sh $torun
fi

echo "Alright Urb $torun.do is finally finished on $HOSTNAME at $PWD with return code $ret_code. Message= $2. -Me" | mail -s "Process done" $EMAIL

