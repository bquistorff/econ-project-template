#!/bin/bash
# Must "source" this file.
#$ source setup_env.sh

#General project-specific stuff (cross machine)
export PATH=$PWD/bin:$PATH

# Could set the ADO here, but want it to work interactively too, so have default in code
#the mlibs in relative paths are only auto found if started in the correct directory
#Otherwise -mata: mata mlib index-
#export S_ADO="\"code/ado/\";BASE"

#likely computer-specific and project-specific
export UNVERSIONED_DATA=../data
export DEFNUMCLUSTERS=2
#On cluster, the machine's Stata temp is big but cleaned out daily
export STATATMP=temp

#likely computer-specific and cross-project (so maybe defined elsewhere)
#export STATAEXE=StataSE-64.exe
#export STATABATCH=StataSE-64.exe /e
#export PATH=C:\Program Files (x86)\STATA13:C:\Program Files (x86)\LyX 2.1\bin:C:\Program Files\gs\gs9.15\bin:$PATH
#export STATA_PLATFORM=WIN64A
#export GSEXE=gswin64c

#On Windows, set SHELLOPTS=igncr (to fix http://stackoverflow.com/questions/14598753/running-bash-script-in-cygwin-on-windows-7)