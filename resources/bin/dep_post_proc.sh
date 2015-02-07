#!/bin/bash
# Post-processes the (win)gendep files into nicer makefile rules:

cp $1.dep $1.dep1
# Unifies the two lines
cat $1.dep1 | tr -d '\n' | sed -e "s/ : $1$1 //g" > $1.dep2
#remove unwanteds (launchers and temporary files)
cat $1.dep2 | sed -e "s/\\b$1.log\\b//g" -e "s/\(resource\|temp\)[^ ]\+//g" > $1.dep3
echo "" >> $1.dep3

if [[ "$GENDEP_MD5" = "1" ]] ; then
	make_deps_md5.sh $1.dep3 $1.dep4
	mv $1.dep4 $1.dep3
fi

#Write out comment line (because it's nice to be able to cat .*.dep and have that looknice).
echo "# $1.$2" > $1.dep
cat $1.dep3 >> $1.dep
echo "" >> $1.dep

#Write out the recipe
if  [[ $2 = "do" ]] ; then
	echo "	st_launcher.sh code/$1" >> $1.dep
else
	echo "	R_launcher.sh code/$1" >> $1.dep
fi

#Hide the file
oldname_dir=$(dirname "$1.dep")
oldname_fname=$(basename "$1.dep")
newname=${oldname_dir}/code/.${oldname_fname}
mv $1.dep $newname
if [ "$OS" = "Windows_NT" ]; then
	ATTRIB +H $newname
fi

if [ "$GENDEP_DEBUG" != "1" ]; then 
	rm $1.dep1 $1.dep2 $1.dep3
fi
