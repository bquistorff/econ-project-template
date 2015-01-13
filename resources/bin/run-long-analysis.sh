#!/bin/bash
# For long jobs, use nice and email when finished
# Requirements: Run in root/code/
# to start, end, do:
#   nohup ./run-long-analysis.sh script.do "message" &
#   killall -9 stata-mp

# Which file
if [ "$1" = "" ]
then
    #torun=analysis_pop
    #torun=analysis_gdp_indep
    torun=analysis_pa_workers_indep
    #torun=decompose-growth-est2
else
    torun=$1
fi

#Just to make sure
source setup-env.sh

# could put nice in front of this
#nice -n10 statab.sh do $torun.do
statab.sh do $torun.do
ret_code=$?

echo "Alright Urb $torun.do is finally finished on $HOSTNAME at $PWD with return code $ret_code. Message= $2. -Me" | mail -s "Process done" bquistorff@gmail.com

