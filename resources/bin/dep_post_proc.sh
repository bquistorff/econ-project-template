#!/bin/bash
# Post-processes the dep files into makefile rules:

cp $1.dep $1.dep2

#Write out comment line (because it's nice to be able to cat .*.dep and have that looknice).
echo "# $1" > $1.dep

# Reprocess the dependency info: First line unifies the two lines. Second removes a unwanted (launchers and temporary files)
cat $1.dep2 | tr -d '\n' | sed -e "s/ : $1$1 //g" \
	| sed -e "s/\\b$1.log\\b//g" -e "s/\(resource\|temp\)[^ ]\+//g" \
	> $1.dep2
echo "" >> $1.dep2

#No for the prerequisites that are outputs, substitute with MD5 format
if [ "$GENDEP_MD5" = "1" ]; then 
	#There's only one line
	while read line; do
		for word in $line; do
			#This could be refactored better
			if  [[ $word = ":" ]] ; then
				LINE_SECOND=1
			fi
			# All output dirs but log (since they are never intermediate files)
			if  [[ $word =~ (data|fig|snippets|tab)/.* ]] ; then
				p_dir=$(dirname $word)
				p_fname=$(basename "$word")
				p_md5name="${p_dir}/.${p_fname}.md5"
				if  [[ $LINE_SECOND = "1" ]] ; then
					echo -n "$p_md5name " >> $1.dep
				else
					echo -n "$word " >> $1.dep
				fi
			else
				echo -n "$word " >> $1.dep
			fi
		done
	done < $1.dep2
fi
echo "" >> $1.dep
rm $1.dep2

#Write out the recipe
echo "	st_launcher.sh code/$1" >> $1.dep

#Hide the file
oldname_dir=$(dirname "$1.dep")
oldname_fname=$(basename "$1.dep")
newname=${oldname_dir}/code/.${oldname_fname}
mv $1.dep $newname
if [ "$OS" = "Windows_NT" ]; then
	ATTRIB +H $newname
fi
