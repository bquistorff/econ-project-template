#! /bin/bash
# Removed non-versioned files recursively (otherwise pipe through grep -v '\\')
svn status | grep ^\? | cut -c 9- | sed -e 's/\\/\//g' | xargs -Ifile rm -rf file