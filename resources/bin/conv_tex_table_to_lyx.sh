#!/bin/bash
base=$1
infile=tab/tex/$base.tex
infile_tmp1=tab/tex/$base.1.tex
infile_tmp2=tab/tex/$base.2.tex
infile_tmp3=tab/tex/$base.3.tex
outfile=tab/lyx/$base.lyx
outfile_tmp1=tab/lyx/$base.1.lyx
outfile_tmp2=tab/lyx/$base.2.lyx

#get rid of the totally enclosing {}, then the sym stuff
cat $infile | grep --text -v "^[{}]$" | grep --text -v "sym#" |sed -e "s/\\\\sym{\(\**\)}/\\\\(^{\1}\\\\)/g" > $infile_tmp1

# Lyx only handles table spaces that are non-elastic so conver those. Put sentinel values for spacing
#Defined in latex.ltx
#\newskip\smallskipamount \smallskipamount=3pt plus 1pt minus 1pt
#\newskip\medskipamount   \medskipamount  =6pt plus 2pt minus 2pt
#\newskip\bigskipamount   \bigskipamount =12pt plus 4pt minus 4pt
cat $infile_tmp1 | sed -e "s/\\\\noalign{\\\\smallskip}/[3pt]\n/g" -e "s/\\\\noalign{\\\\smallskip}/[6pt]\n/g" -e "s/\\\\noalign{\\\\smallskip}/[12pt]\n/g" | sed -e "s/\[\([0-9]\+..\)\]/FooBarBaz\1/g" >  $infile_tmp2
#Fix up the case where we want a bottom skip
perl -0pe 's/\\\\\n(FooBarBaz[0-9]+..)\n\\hline/$1\\\\\n\\hline/g'  $infile_tmp2 > $infile_tmp3
tex2lyx -f $infile_tmp3 $outfile_tmp1


#Post process, find the sentinel value and go back to edit the lyx-only row tag attribute
perl -0pe 's/<row([^<]+)(<cell[^<]+)FooBarBaz([^ ]+) /<row topspace="$3"$1$2/g' $outfile_tmp1 > $outfile_tmp2
perl -0pe 's|<row((?:[^<]+</?c)*[^<]+)FooBarBaz([^\s]+)([^<]+</c[^<]+</row)|<row bottomspace="$2"$1$3|g' $outfile_tmp2 > $outfile

rm $infile_tmp1 $infile_tmp2 $infile_tmp3 $outfile_tmp1 $outfile_tmp2

