#!/bin/bash
# Works well when PDF is generated from the command-line: latexmk, LyX PDF export (via pdflatex).

#gets the folder of the currents script (even if found in path). Can't use cd above here in this script.
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
#echo "$DIR"
sed -f ${DIR}/normalize_pdf.sed $1 > $1.pdf
# zeros out the PTEX Filename (can't just remove or offsets will be wrong)
perl -pe 's|(/PTEX.FileName \()([^\)]+)|$1 . " " x length($2)|ge' $1.pdf > $1
rm -f $1.pdf
