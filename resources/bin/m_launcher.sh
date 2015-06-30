#! /bin/bash
# Launches Matlab with the following features:
# -if dependency tracking is desired, will trace the Matlab process
# -Will normalize the output files
# -if md5 tracking is on, will generate those files.

fname_base=$(basename $1)
m_cmd="matlabb.sh $1.m"

if [ "$GENDEP_DISABLE" = "1" ]; then 
	$nice_prefix $m_cmd
else
	GENDEP_TARGET=$fname_base $nice_prefix dep_tracker.sh $m_cmd
fi
ret_code=$?

if [ $ret_code -eq 0 ]; then
	if [ "$GENDEP_DISABLE" != "1" ]; then 
		dep_post_proc.sh $fname_base m
	fi
	
	cp log/m/$fname_base.log log/
#	normalize_last_run.sh $fname_base R
#
#	#make the md5 hashes
#	if [ "$GENDEP_MD5" = "1" ]; then 
#		#Exclude the logs because they are never intermediate files
#		#keep launchers in sync with make_deps_md5
#		cat temp/lastrun/files.txt | grep -v "log/" | while read p; do
#			update_md5.sh $p
#		done
#	fi
else
	exit $ret_code
fi
