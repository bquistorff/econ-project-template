#!/bin/bash
# Works well when PDF is generated from the command-line: latexmk, LyX PDF export (via pdflatex).

#gets the folder of the currents script (even if found in path). Can't use cd above here in this script.
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
#echo "$DIR"
sed -bf ${DIR}/normalize_pdf.sed $1 > $1.pdf
# zeros out the PTEX Filename (can't just remove or offsets will be wrong)
#re.sub('(blah) (.+)', lambda match: '{0}{1}'.format(match.group(1), ' '*len(match. group(2))), x)
cat $1 | python -c "import sys,re;[sys.stdout.write(re.sub('(/PTEX.FileName \()([^\)]+)', lambda match: '{0}{1}'.format(match.group(1), ' '*len(match. group(2))), line)) for line in sys.stdin]" > $1
rm -f $1.pdf
