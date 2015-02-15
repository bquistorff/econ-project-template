#!/bin/bash
# Normalizes a Stata *.trk file (e.g. stata.trk or backup.trk):
# - to have unix folder separators
# - remove the PWD from local install locations (requires fork of adoupdate + net_* utils to still work)
#
# Use this after installing modules if your project works across Windows and Unix platforms .
# Usage: normalize_trks.sh code/ado/stata.trk

f=$1
cp $f $f.temp1
sed -e '/^f /s/\\/\//g' $f.temp1 > $f.temp2

# Normalize the rootdir
if [ "$OS" = "Windows_NT" ]; then
	prj_base_unesc=`cygpath -pw "$PWD"`
	prj_base=`echo "$prj_base_unesc"| sed 's|\\\\|\\\\\\\\|g'`
	prj_base_better=`echo "$prj_base_unesc"| sed 's|\\\\|\\\/|g'`
else
	prj_base_unesc=$PWD
	prj_base=`echo "$prj_base_unesc"| sed 's|\/|\\\\\/|g'`
	prj_base_better=prj_base
fi


# On the UMD econ cluster Stata reports the pwd different than the shell 
sed -e 's|\/econ_s\/|\/home\/|g' $f.temp2 > $f.temp3

#For windows, first swtich all the folder separators wround
sed -e "/^S ${prj_base}/s/\\\\/\\//g" $f.temp3 > $f.temp4
#normalize machine-specific roots
sed -e "s|^S ${prj_base_better}\\/|S |g" $f.temp4 > $f

rm -f $f.temp1 $f.temp2 $f.temp3 $f.temp4
