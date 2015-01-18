*Preferences

* include proj_prefs.do //more/trace are local only so have to "include" not "do"

version 12.1
set matsize 10000
set more off
set linesize 140
set scheme s2mono
mata: mata set matafavor speed
set matalnum on
set varabbrev off
set tracedepth 1

*Defaults
set seed 1337
if ("${dir_base}"=="") global dir_base ".."
if ("${track_files}"=="") global track_files = ("${testing}" != "1")

if "${testing}"== "1"{
	pause on
	set trace on
	global extra_f_suff = "${extra_f_suff}_test"
}

* Machine-specific stuff from environment
* Get stuff that isn't versioned (too big).
*global unversioned_data "${dir_base}/../../Data/" //specify this default
if `"`: environment UNVERSIONED_DATA'"'!="" {
	global unversioned_data `"`: environment UNVERSIONED_DATA'"'
}

global defnumclusters = 2
if "`: environment DEFNUMCLUSTERS'"!="" {
	global defnumclusters = `: environment DEFNUMCLUSTERS'
}

*This one will already have been imported
if `"`: environment S_ADO'"'=="" {
	global S_ADO =`""ado/";BASE"'
	mata: mata mlib index
}

*All of the above env vars should be in one category
global envvars_show ""
global envvars_hide "UNVERSIONED_DATA DEFNUMCLUSTERS S_ADO"
