#!/bin/bash
# Normalizes Stata *.trk files (stata.trk & backup.trk) to have unix line endings
# Use this after installing modules if your project works across Windows and Unix platforms .
# Usage: normalize_trks.sh code/ado

the_d=$1

sed -e '/^f /s/\\/\//g' -i $the_d/stata.trk
sed -e '/^f /s/\\/\//g' -i $the_d/backup.trk
