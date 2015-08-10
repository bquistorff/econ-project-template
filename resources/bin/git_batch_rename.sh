#!/bin/bash
# renames files (and git mv's them if in git)
# not sure if this works if there is whitespace in these vars
# use from base of project
# (for svn just change all git->svn)
findstr=$1
replacestr=$2

# It currently doesn't search in hidden folders
# for no recursion, use:
# for i in *
find . -not -path '*/\.*' -type f -name "*$findstr*"|while read i; do
    #echo $i
    new_name=`echo $i | sed s/$findstr/$replacestr/g`
    git mv $i $new_name
    #If not in git still rename
    mv $i $new_name
done
