#!/bin/bash
# Converts absolute paths in lyx documents to relative ones.
cd ..
if [ "$OS" = "Windows_NT" ]; then
	TOREMOVE=$(cygpath -w "$PWD" | sed 's|\\|\/|g')
else
	TOREMOVE=$PWD
fi
cd writeups

sed -i "s|$TOREMOVE|..|g" *.lyx
