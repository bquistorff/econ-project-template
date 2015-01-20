#! /bin/bash
# Removed non-versioned files recursively (otherwise pipe through grep -v '\\')
svn status | grep ^\? | cut -c 9- | sed -e 's/\\/\//g' | xargs -Ifile rm -rf file

#For git see http://stackoverflow.com/questions/61212/remove-local-untracked-files-from-my-current-git-branch
#Simplest:
# git clean -f #add -d to include directories
