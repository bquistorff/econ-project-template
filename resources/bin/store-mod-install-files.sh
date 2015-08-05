#!/bin/bash
# Stores locally the installation files for Stata module
# This is helpful if the installation files include platform-specific files
# (so what is installed isn't sufficient to have it run elsewhere)
# Assumes the standard first-letter directory structure.
#
# How will you know if this is the case?
# - You can check have "g " lines in the module's package file
# - Look through your ado folder for files that might be platform specific
#  $ cat stata.trk | grep "^f " | grep -v '\(ado\|mlib\|hlp\|dlg\)$'
#
# Example usage:
# $ cd code/ado-store
# $ store-mod-install-files.sh http://fmwww.bc.edu/repec/bocode/s/synth.pkg

pkgfilename=$(basename "$1") 
pkgdirpath=$(dirname "$1")
pkgbase="${pkgfilename%.*}"
pkgbase_letter=${pkgbase:0:1}
orig_dir=$PWD

#Remove the existing one if it exists
unstore-mod-install-files.sh $pkgbase

mkdir -p $pkgbase_letter/
cd $pkgbase_letter/

wget $1

files=$({ cat $pkgfilename | grep ^[fF] | cut -d ' ' --fields 2; cat $pkgfilename | grep '^[gG]' | cut -d ' ' --fields 3; })
for f in $files
do
    dirpath=$(dirname "$f")
    mkdir -p $dirpath
    wget $pkgdirpath/$f -P $dirpath
done 

# Now fixup the stata.toc
wget $pkgdirpath/stata.toc -O stata.temp.toc
cat stata.temp.toc | grep "p $pkgbase " >> stata.toc
rm stata.temp.toc

cd $orig_dir