#!/bin/bash
# Example usage:
# cd code/ado-store
# store-mod-install-files.sh http://fmwww.bc.edu/repec/bocode/s/synth.pkg
# Assumes the standard first-letter directory structure.

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