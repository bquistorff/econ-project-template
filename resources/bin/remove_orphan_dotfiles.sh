#!/bin/bash
# Removes orphan dot files (.*.dep and .*.md5)

find . -not -path '*/\.*/*' -path '*/\.*' -type f | grep ".\(dep\|md5\)$" | while read i; do
	i_dir=$(dirname "$i")
	i_fname=$(basename "$i")
	i_ext="${i_fname##*.}"
	i_fname=${i_fname%.*}
	i_fname=${i_fname#?}
	i_path="${i_dir}/${i_fname}"
	if [ "$i_ext" = "dep" ]; then
		i_path="${i_path}.do"
	fi
	if ! [ -e "$i_path"]; then
		rm "$i"
	fi
done
