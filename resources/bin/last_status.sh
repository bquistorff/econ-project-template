#!/bin/bash
# Shows files modified since the last (Stata) process started.
# Used by 'make status-check-last'
#
# To do: If handy, expand to other log types

ffirst=`ls -1t log/do/ | head -1`
ftime=`cat log/do/$ffirst | grep ' opened on:' | sed -e 's/.\+\(.\+\)/\1/g' | sed -e 's/,//g'`
delta_s=$(( $(date +%s) - $(date -d "$ftime" +%s) ))
delta_m=$(($delta_s/60+1))
#needed if called from cmd
PATH=/usr/bin/:$PATH
find . -mmin -$delta_m -not -path "*/.git/*" -type f -print
