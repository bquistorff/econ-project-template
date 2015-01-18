* Description: Blah

*Header
clear_all
qui include "proj_prefs.do"

local do_name fake1
log_open `do_name'

* Content
use ../data/clean/auto.dta
save12 ../data/clean/auto2.dta, replace

* Footer
log close `do_name'
