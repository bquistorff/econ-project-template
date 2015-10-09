#!/bin/bash
#make a package-specific makefile
#Run from the root folder
# To do: detect STATA_PLATFORM for Mac and SOL

# Determine the Platform Type if not set by STATA_PLATFORM
# The platform names are:
# WIN (32-bit x86) and WIN64A (64-bit x86-64) for Windows; 
# MACINTEL (32-bit Intel, GUI), OSX.X86 (32-bit Intel, console), MACINTEL64 (64-bit Intel, GUI), OSX.X8664 (64-bit Intel, console), MAC (32-bit PowerPC), and OSX.PPC (32-bit PowerPC), for Mac; 
# LINUX (32-bit x86), LINUX64 (64-bit x86-64), SOL64, and SOLX8664 (64-bit x86-64) for Unix.
if [ "$STATA_PLATFORM" = "" ]; then
	N_BITS=`getconf LONG_BIT`
	if [ "$OS" = "Windows_NT" ]; then
		STATA_PLATFORM=WIN
		if [ "$N_BITS" = "64" ]; then
			STATA_PLATFORM=WIN64A
		fi
	else
		STATA_PLATFORM=LINUX
		if [ "$N_BITS" = "64" ]; then
			STATA_PLATFORM=LINUX64
		fi
	fi
fi

# Currently only dealing with locally installable files
# (f,g) not the system installable files (F,G)
# Also disregarding dtas as those are considered "ancillary" by Stata
# and don't go into ado/<>/ like the other files. Should deal
# better with this.

outfile=code/dep.ados
ignore_outfile=code/ado/.gitignore
echo "#Generated makefile rules" > $outfile
echo "#Generated gitignore rules" > $ignore_outfile

#See if there are any yet
find code/ado-store -name "*.pkg" &> /dev/null
if [  "$?" -ne "0" ]; then
	#echo "No locally installable modules. Empty makefile rule file"
	exit
fi

#echo ".DEFAULT_GOAL := all_modules" >> $outfile

PKGFILES=code/ado-store/*/*.pkg

for fullfile in $PKGFILES
do
	#echo "ff=$fullfile"
    filename=$(basename "$fullfile") 
    base="${filename%.*}"
    bases="$bases $base"
done

echo .PHONY : all_modules $bases >> $outfile
echo all_modules : $bases >> $outfile

for fullfile in $PKGFILES
do
	#echo "ff=$fullfile"
    filename=$(basename "$fullfile") 
    base="${filename%.*}"
    base_letter=${base:0:1}
    
    targets=$({ cat $fullfile | grep ^f | grep -v .dta | cut -d ' ' --fields 2; cat $fullfile | grep "^g $STATA_PLATFORM " | cut -d ' ' --fields 4; } | sed -e "s:^:code/ado/$base_letter/:" | paste -sd " ")
    deps=$({ cat $fullfile | grep ^f | grep -v .dta | cut -d ' ' --fields 2; cat $fullfile | grep "^g $STATA_PLATFORM " | cut -d ' ' --fields 3; } | sed -e "s:^:code/ado-store/$base_letter/:" | paste -sd " ")
    echo $targets : $deps >> $outfile
    echo "	statab.sh do code/cli_install_module.do $base" >> $outfile
    echo $base : $targets >> $outfile
    echo -e "\n" >> $outfile
	
	#Get the normal files
	{ cat $fullfile | grep ^f | grep -v .dta | cut -d ' ' --fields 2; cat $fullfile | grep "^g $STATA_PLATFORM " | cut -d ' ' --fields 4; } | sed -e "s:^:$base_letter/:" | sed -e "s:^$base_letter/\.\./::" >> $ignore_outfile
	#Get the ancillary files (probably others too)
	cat $fullfile | grep .dta  | cut -d ' ' --fields 2 >> $ignore_outfile
done

