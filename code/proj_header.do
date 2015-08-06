* Notes:
*  Trying to keep all the pathing stuff (main vs testing) here and (proj_footer.do)
*
* Usage:
* local do_name XXX
* include ${main_root}code/proj_header.do

*Get paths setup
if "${main_root}"!="" cd ${main_root} //recover from testing
do code/setup_ado.do

*Logging. Has to go before clear_all
* Don't use names for now because of complications with clearing. Names can't contain "-"
*For now don't allow duplicate logs coming in.
log close _all //don't use clear_all for this as we need ours open
if "`do_name'"!=""{
	*If testing, put it in the right dir
	get_config_value testing, global(testing) default(0)
	if ${testing} cd temp/testing/ //match with below
	set linesize 140 //sync with proj_prefs.do
	log using "log/do/`do_name'.log", replace /*name(`do_name')*/
	display_run_specs
	if ${testing} cd ../..
}

clear_all //use all globals and passed in locals before this!
*Could restore do_name from -log query-,-return list- and parse filename

*Roots should be include final slash so if blank we get relative paths
global main_root "`c(pwd)'/"
global testing_root "`c(pwd)'/temp/testing/"

get_config_value testing, global(testing) default(0) //re-get
if ${testing} cd temp/testing/

include "${main_root}code/proj_prefs.do" //needs $main_root

