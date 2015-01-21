#!/bin/bash
# Writes to .fname.md5 the md5, though only if wasn't correct before.

p_md5name="$(dirname $1)/.$(basename $1).md5"
md5sum $1 | cmp -s $p_md5name -
if test $? -ne 0; then 
	md5sum $1 > $p_md5name; 
fi

if [ "$OS" = "Windows_NT" ]; then
	ATTRIB +H $p_md5name
fi
