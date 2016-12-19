#!/bin/bash
# example: (after getting path setup via, e.g., 'source resources/bin/setup_env.sh')
# $ make_paper_products.sh paper/QLPG.lyx

if [[ -z "${1}" ]]; then
	echo "Need to pass in the file parameter"
	exit 1
fi

filename=${1%%.*}
cat $filename.lyx | python -c 'import sys,re;sys.stdout.write(re.sub("(\n\\\\branch (Notes|Sources)[\r\n]+\\\\selected) .","\\1 1",sys.stdin.read()))' > $filename-on.lyx
cat $filename.lyx | python -c 'import sys,re;sys.stdout.write(re.sub("(\n\\\\branch (Notes|Sources)[\r\n]+\\\\selected) .","\\1 0",sys.stdin.read()))' > $filename-off.lyx

lyx -e pdf2 $filename-on.lyx
mv $filename-on-Notes-Sources.pdf $filename-Notes-Sources.pdf
lyx -e pdf2 $filename-off.lyx
mv $filename-off.pdf $filename.pdf

rm $filename-on.lyx $filename-off.lyx
