* Description: Blah

*Header
do code/setup_ado.do
clear_all
qui include "code/proj_prefs.do"

local do_name fake1
log_open `do_name'

* Content
use ${dir_base}/data/clean/auto.dta
replace price=2*price 
save12 ${dir_base}/data/clean/auto2.dta, replace

* Footer
log close `do_name'
