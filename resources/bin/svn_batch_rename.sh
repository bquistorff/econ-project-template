#!/bin/bash
# renames files (and svn mv's them if in svn)
# not sure if this works if there is whitespace in these vars
# use from base of project
findstr=$1
replacestr=$2

# It currently doesn't search in hidden folders
# for no recursion, use:
# for i in *
find . -not -path '*/\.*' -type f -name "*$findstr*"|while read i; do
    #echo $i
    new_name=`echo $i | sed s/$findstr/$replacestr/g`
    svn mv $i $new_name
    # Todo: If not in subversion still rename somehow
    mv $i $new_name
done
