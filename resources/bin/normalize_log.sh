#!/bin/bash
#
# File to normalize Stata log files. Remove computer-specific,
# time-specific, and random components from log files.
# This enables identification of differences in Stata runs by
# using binary diffs (easy with a versioned project like one on SVN).

#To do: 
# deal with the unversioned env variable (quieted for now in ipums_migr...)

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
		echo '    $0 -r .. ../log/log1.log ../log2.log'
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

# Normalize the tempdir  the rootdir
if [ "$OS" = "Windows_NT" ]; then
    #Can have two tempdirs: Interactive uses Window's TEMP and batch uses Cygwin's TEMP
    #Want to get Window's %TEMP% first but this is over-ridden by Cygwin, so use default
	temp_base_unesc=`cygpath -d "$LOCALAPPDATA\Temp"`
    temp_base_unesc2=`cygpath -d "$TEMP"`
	prj_base_unesc=`cygpath -pw "$root_dir"`
	temp_base=`echo "$temp_base_unesc"| sed 's|\\\\|\\\\\\\\|g'`
	temp_base2=`echo "$temp_base_unesc2"| sed 's|\\\\|\\\\\\\\|g'`
	prj_base=`echo "$prj_base_unesc"| sed 's|\\\\|\\\\\\\\|g'`
else
	temp_base_unesc=$STATATMP
	prj_base_unesc=$root_dir
	temp_base=`echo "$temp_base_unesc"| sed 's|\/|\\\\\/|g'`
	prj_base=`echo "$prj_base_unesc"| sed 's|\/|\\\\\/|g'`
fi

for f in "$@"
do
	if [ "$backup" = "" ]; then
		echo "Normalizing: $f"
	else
		cp $f $backup
		echo "Normalizing: $f (backup in $backup)"
	fi
    
    #On Cygwin I was getting errors with 'sed -i' like
    #sed: cannot rename ../temp/lastrun/sed8xOWT7: Permission denied
    # so switch to manual file manipulation
    
    ### Machine-specific (from script because they use a shell variable)
    ##OS-dependent: file path
    # On the UMD econ cluster Stata reports the pwd different than the shell 
    sed -e 's|\/econ_s\/|\/home\/|g' $f > $f.temp1
    # Temp file mechanism vary from OS to OS
    if [ "$OS" = "Windows_NT" ]; then
        sed -e "s/${temp_base}[^ ]\+/-normalizedtempfile-/g" $f.temp1 > $f.temp2
        sed -e "s/${temp_base2}[^ ]\+/-normalizedtempfile-/g" $f.temp2 > $f.temp3
    else
        sed -e "s/${temp_base}[^ ]\+/-normalizedtempfile-/g" $f.temp1 > $f.temp3
    fi
    #normalize machine-specific roots
    sed -e "s/${prj_base}/-normalizedroot-/g" $f.temp3 > $f.temp4

	sed -f ${root_dir}/resources/bin/normalize_log.sed $f.temp4 > $f
    rm -f $f.temp1 $f.temp2 $f.temp3 $f.temp4
done
