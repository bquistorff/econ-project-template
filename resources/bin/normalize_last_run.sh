#! /bin/bash

#root="${1%.*}"
root=$1
#ext="${1##*.}"
ext=$2

#Get the list of file outputted from the last run
# Could get this from the dep files also
last_status.sh > temp/lastrun/files.txt

#Normalize the outputs

if  [[ $ext = "do" ]] ; then
	cat temp/lastrun/files.txt | grep \.gph | while read p; do
		normalize_gph.py "$p";
	done

	cat temp/lastrun/files.txt | grep \.dta | while read p; do
		normalize_dta.py "$p";
	done
	
	cp log/do/$root.log log/$root.log
	normalize_log.sh -r . log/$root.log
	sed -be 's:log/::g' -i temp/lastrun/files.txt
fi

if  [[ $ext = "m" ]] ; then
	cp log/m/$root.log log/
	#TODO: normalize the log
fi

if  [[ $ext = "R" ]] ; then
	cp log/R/$root.log log/
	#TODO: normalize the log
fi
