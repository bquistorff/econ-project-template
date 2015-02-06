#!/bin/bash
# This is the template for setting up environment variables.
# On a specific machine you should copy this to resources/setup_env.sh and customize appropriately
# Then you can
#$ source resources/setup_env.sh

#General project-specific stuff (cross machine)
export PATH=$PWD/resources/bin:$PATH

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