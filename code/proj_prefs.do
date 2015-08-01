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
set sortseed 123456 //undocumented. Makes normal sort stable
global try_stata12 = 1
if ("${testing}"=="") global testing = 0
if ("${verbose}"=="") global verbose = 0

global main_root "`c(pwd)'/"
if ${testing}{
	pause on
	set trace on
	
	*get the testing dir
	global testing_root `: environment TESTING_ROOT'
	if "$testing_root"=="" global testing_root "temp"
	*make sure it's absolute
	*cd $testing_root
	*global testing_root `c(pwd)'
}

if !${verbose}{
	global qui "qui"
}

* Machine-specific stuff from environment
* Get stuff that isn't versioned (too big).
*global unversioned_data "${main_root}/../../Data/" //specify this default
if `"`: environment UNVERSIONED_DATA'"'!="" {
	global unversioned_data `"`: environment UNVERSIONED_DATA'"'
}

global defnumclusters = 2
if "`: environment DEFNUMCLUSTERS'"!="" {
	global defnumclusters = `: environment DEFNUMCLUSTERS'
}

*All of the above env vars should be in one category
global envvars_show ""
global envvars_hide "UNVERSIONED_DATA DEFNUMCLUSTERS"
