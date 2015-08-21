#!/bin/bash
# Works well when PDF is generated from the command-line: latexmk, LyX PDF export (via pdflatex).

NORM_SED=$(which normalize_pdf.sed)
sed -bf ${NORM_SED} $1 > $1.pdf
# zeros out the PTEX Filename (can't just remove or offsets will be wrong)
#re.sub('(blah) (.+)', lambda match: '{0}{1}'.format(match.group(1), ' '*len(match. group(2))), x)
cat $1 | python -c "import sys,re;[sys.stdout.write(re.sub('(/PTEX.FileName \()([^\)]+)', lambda match: '{0}{1}'.format(match.group(1), ' '*len(match. group(2))), line)) for line in sys.stdin]" > $1
rm -f $1.pdf
