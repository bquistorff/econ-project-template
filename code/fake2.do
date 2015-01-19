* Description: Blah

*Header
do code/setup_ado.do
clear_all
qui include "code/proj_prefs.do"

local do_name fake2
log_open `do_name'

* Content
use ${dir_base}/data/clean/auto2.dta

twoway (scatter price mpg)
save_fig auto_scatter

* Footer
log close `do_name'
