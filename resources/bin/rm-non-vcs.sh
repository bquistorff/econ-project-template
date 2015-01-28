#! /bin/bash

if [ -d ".svn" ]; then 
	# Removed non-versioned files recursively (otherwise pipe through grep -v '\\')
	svn status | grep ^\? | cut -c 9- | sed -e 's/\\/\//g' | xargs -Ifile rm -rf file
fi
if [ -d ".git" ]; then 
	#For git see http://stackoverflow.com/questions/61212/remove-local-untracked-files-from-my-current-git-branch
	#Simplest (add -d to include directories)
	git clean -f
fi
