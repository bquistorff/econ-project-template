#!/bin/bash
# Removes orphan dep files

find resources/deps/ -type f | while read i; do
	i_fname=$(basename "$i")
	i_fname=${i_fname%.*}
	i_path="code/${i_fname}"
	if ! [ -e "$i_path"]; then
		rm "$i"
	fi
done
