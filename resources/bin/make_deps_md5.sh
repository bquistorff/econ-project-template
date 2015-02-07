#!/bin/bash
# Make the dependencies point to the md5 sentinels

#There's only one line
while read line; do
	for word in $line; do
		if  [[ $word = ":" ]] ; then
			#echo "Now line 2"
			LINE_SECOND=1
		fi
		#echo "$word"
		# All output dirs but log (since they are never intermediate files) 
		# for the prerequisites that are outputs, substitute with MD5 format
		if [[ $word =~ (data/|fig/gph/|fig/eps/|snippets/|tab/).* && "$LINE_SECOND" = "1" ]] ; then
			p_md5name="$(dirname $word)/.$(basename $word).md5"
			echo -n "$p_md5name " >> $2
		else
			echo -n "$word " >> $2
		fi
	done
done < $1
