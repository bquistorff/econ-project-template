#!/bin/bash
# Shows files modified since the last (Stata) process started.
# Used by 'make status-check-last'
#
# To do: If handy, expand to other log types
 
ffirst=`ls -1t log/smcl/ | head -1`
ftime=`cat log/smcl/$ffirst | grep ' opened on:' | sed -e 's/.\+\(.\+\)/\1/g' | sed -e 's/,//g'`
delta_s=$(( $(date +%s) - $(date -d "$ftime" +%s) ))
delta_m=$(($delta_s/60+1))
find . -mmin -$delta_m -not -path "*/.git/*" -type f -print
