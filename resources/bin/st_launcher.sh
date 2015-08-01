#! /bin/bash
# Launches Stats-program with the following features:
# -if dependency tracking is desired, will trace the Stata process
# -Will normalize the output files

fname=$1
fname_base=$(basename $1)
fname_base="${fname_base%.*}"
ext="${fname##*.}"

if [ "$ext" = "do" ]; then stat_cmd="statab.sh $fname"; fi
if [ "$ext" = "m"  ]; then stat_cmd="matlabb.sh $fname"; fi
if [ "$ext" = "R"  ]; then stat_cmd="R CMD BATCH --vanilla --no-timing $fname log/R/$fname_base.log"; fi

if [ "$GENDEP_DISABLE" = "1" ]; then 
	$nice_prefix $stat_cmd; 
else
	DEP_FILE=$fname_base.dep $nice_prefix dep_tracker.sh $stat_cmd;
fi

if [ ! $? -eq 0 ]; then exit $?; fi
#echo "finished stats run"
if [ "$GENDEP_DISABLE" != "1" ]; then 
	dep_post_proc.sh $fname_base $ext
fi

#echo "finished dep post"
normalize_last_run.sh $fname_base $ext
#echo "finished normalize"

