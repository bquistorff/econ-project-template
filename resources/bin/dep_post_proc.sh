#!/bin/bash
# Post-processes the dep files:

cp $1.dep $1.$2.bak.dep

#Write out comment line (because it's nice to be able to cat *.dep and have that looknice).
echo "## $1.$2" > $1.dep

# Reprocess the dependency info: remove unwanted (launchers and temporary files).
cat $1.$2.bak.dep | sed -e "s/\(resource\|temp\)[^ ]\+//g" >> $1.dep
echo "" >> $1.dep

#Write out the recipe
#Not needed for Scons
#echo "	st_launcher.sh code/$1" >> $1.dep

mv $1.dep resources/deps/$1.$2.dep

rm $1.$2.bak.dep
