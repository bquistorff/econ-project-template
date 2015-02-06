#!/bin/bash
# Example usage:
# cd code/ado-store
# unstore-mod-install-files.sh synth
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

pkgbase="$1"
pkgfilename="$pkgbase".pkg
pkgbase_letter=${pkgbase:0:1}

if ! [ -e $pkgbase_letter/$pkgfilename ]; then
	#echo "No existing package to remove"
	exit
fi

cd $pkgbase_letter
files=$({ cat $pkgfilename | grep ^[fF] | cut -d ' ' --fields 2; cat $pkgfilename | grep '^[gG]' | cut -d ' ' --fields 3; } | paste -sd " ")
rm $files $pkgfilename
cat stata.toc | grep -v "^p $pkgbase " > stata.toc

cd ..
