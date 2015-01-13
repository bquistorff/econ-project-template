#!/bin/bash
# Creates three PDFs from a Beamer LyX document.
# Doesn't assume anything about existing options
# so makes all docs with new file suffixes.
#
# Added to Right-click menu with FileMenu Tools by lopesoft

# Pass in the filename with extension
filename=${1%%.*}

# Get the plain slides version
cp $filename.lyx  $filename-slides.lyx

# Be careful if no options have been set
optLines="$(grep -c '\\options' $filename.lyx)" 
if [ $optLines -eq 0 ]
then
	sed -i 's/\(\\end_preamble\)/\1\n\\options /g' $filename-slides.lyx
fi
if [ $optLines -gt 1 ]
then
	echo "Warning: More than one \\option line. This may not work"
fi

# Remove just the relevant options
sed -i 's/\(\\options .*\)notes=show,*/\1/g' $filename-slides.lyx
sed -i 's/\(\\options .*\)handout,*/\1/g' $filename-slides.lyx

# Make the other versions
cp $filename-slides.lyx  $filename-handout.lyx
sed -i 's/\(\\options \)/\1handout,/g' $filename-handout.lyx

cp $filename-slides.lyx  $filename-notes.lyx
sed -i 's/\(\\options \)/\1handout,notes=show,/g' $filename-notes.lyx


# export slides
lyx -e pdf2 $filename-slides.lyx
lyx -e pdf2 $filename-notes.lyx
lyx -e pdf2 $filename-handout.lyx

# clean up extra files
rm $filename-handout.lyx $filename-slides.lyx $filename-notes.lyx
