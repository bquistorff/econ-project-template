#!/bin/bash
# Normalize frequently generated datasets so that 
# SVN diff will really tell if something changed
FILES=../data/estimates/bs_*.dta
for f in $FILES
do
  echo "Normalizing $f file..."
  python normalize_dta.py "${f%.*}"
done
