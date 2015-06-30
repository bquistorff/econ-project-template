* Description: Blah

*Header
local do_name fake1
include ${main_root}code/proj_header.do

* Content
use ${main_root}/data/clean/auto.dta
replace price=2*price 
save12 data/clean/auto2.dta, replace

include ${main_root}code/proj_footer.do
