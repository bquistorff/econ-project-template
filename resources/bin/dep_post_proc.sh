#!/bin/bash
# Post-processes the dep files into makefile rules:


# Reprocess the dependency info: First line unifies the two lines. Second removes a unwanted (launchers and temporary files)
cat $1.dep | tr -d '\n' | sed -e "s/ : $1$1 //g" > $1.dep2
cat $1.dep2 | sed -e "s/\\b$1.log\\b//g" -e "s/\(resource\|temp\)[^ ]\+//g" > $1.dep3
echo "" >> $1.dep3

#Write out comment line (because it's nice to be able to cat .*.dep and have that looknice).
echo "# $1" > $1.dep
#There's only one line
while read line; do
	for word in $line; do
		if  [[ $word = ":" ]] ; then
			#echo "Now line 2"
			LINE_SECOND=1
		fi
		#echo "$word"
		# All output dirs but log (since they are never intermediate files) 
		# for the prerequisites that are outputs, substitute with MD5 format
		if [[ $word =~ (data|fig|snippets|tab)/.* && "$LINE_SECOND" = "1" && "$GENDEP_MD5" = "1" ]] ; then
			p_md5name="$(dirname $word)/.$(basename $word).md5"
			echo -n "$p_md5name " >> $1.dep
		else
			echo -n "$word " >> $1.dep
		fi
	done
done < $1.dep3
echo "" >> $1.dep
rm $1.dep2 $1.dep3

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
