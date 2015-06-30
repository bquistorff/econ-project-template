#! /bin/bash
# Launches R with the following features:
# -if dependency tracking is desired, will trace the R process
# -Will normalize the output files
# -if md5 tracking is on, will generate those files.

fname_base=$(basename $1)
R_cmd="R CMD BATCH --vanilla --no-timing $1.R log/R/$fname_base.log"

if [ "$GENDEP_DISABLE" = "1" ]; then 
	$nice_prefix $R_cmd
else
	GENDEP_TARGET=$fname_base $nice_prefix dep_tracker.sh $R_cmd
fi
ret_code=$?

if [ $ret_code -eq 0 ]; then
	if [ "$GENDEP_DISABLE" != "1" ]; then 
		dep_post_proc.sh $fname_base R
	fi
	
	cp log/R/$fname_base.log log/
	normalize_last_run.sh $fname_base R

	#make the md5 hashes
	if [ "$GENDEP_MD5" = "1" ]; then 
		#Exclude the logs because they are never intermediate files
		#keep launchers in sync with make_deps_md5
		cat temp/lastrun/files.txt | grep -v "log/" | while read p; do
			update_md5.sh $p
		done
	fi
fi

exit $ret_code
