#!/bin/bash
#
# File to normalize R log files. Remove computer-specific,
# time-specific, and random components from log files.
# This enables identification of differences in runs by
# using binary diffs (easy with a versioned project like one on SVN).

#To do: 
# deal with the unversioned env variable
# deal with the package load warnings (erg multiline so try python).

usage() { echo "Usage: $0 [-b backup_dir] [-h] [-r path_to_root] files" 1>&2; exit 1; }

if [ "$1" = "" ]; then
	usage
fi

orig_pwd=$PWD
root_dir=$orig_pwd

while getopts "hb:r:" opt; do
	case $opt in 
	h)
		echo 'Usage: $0 [-b backup_dir] [-h] [-r path_to_root] files'
		echo 'Options:'
		echo '       -b   make backups of originals'
		echo '       -r   Path to the project root (use for normalizing paths)'
		echo '       -h   Help'
		echo 'Example:'
		echo '    $0 -r . log/log1.log log2.log'
		exit 0
	;;
	b)
		backup=$OPTARG
	;;
	r)
		cd $OPTARG
		root_dir=$PWD		
		cd $orig_pwd
	;;
	
	\?)
		usage
	;;
	esac
done

shift $((OPTIND-1))

for f in "$@"
do
	if ! [ "$backup" = "" ]; then
		cp $f $backup
		#echo "Normalizing: $f (backup in $backup)"
	fi
	ext="${f##*.}"
    
	#On Cygwin I was getting errors with 'sed -i' like
	# so switch to manual file manipulation
#sed: cannot rename temp/lastrun/sed8xOWT7: Permission denied
	
	sed -bf ${root_dir}/resources/bin/normalize_R_log.sed $f > $f.temp1
	cp $f.temp1 $f
  rm -f $f.temp1
done
