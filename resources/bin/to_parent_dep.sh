#!/bin/bash
# Converts a dep file with relative paths into one that is relative to the parent directory
owndir=$1
infile=$2
outfile=$3
cat $infile | grep -v "^#" | sed -e "s@ \([^\. :]\)@ $owndir/\1@g" -e "s|^\([^ #]\)|$owndir/\1|g" -e "s|  \.\./|  |g" > $outfile
