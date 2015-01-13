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
global unversioned_data "${dir_base}/../../Downloads/_archive/Data_unrestricted"
if `"`: environment UNVERSIONED_DATA'"'!="" {
	global unversioned_data `"`: environment UNVERSIONED_DATA'"'
}

global defnumclusters = 2
if "`: environment DEFNUMCLUSTERS'"!="" {
	global defnumclusters = `: environment DEFNUMCLUSTERS'
}

