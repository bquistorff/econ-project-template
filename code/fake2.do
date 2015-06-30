* Description: Blah

*Header
local do_name fake2
include ${main_root}code/proj_header.do

* Content
use ${main_root}/data/clean/auto2.dta

twoway (scatter price mpg), title("Scatter of price on mpg") note("Source: -sysuse auto-" "Produced: Stata")
save_fig auto_scatter

include ${main_root}code/proj_footer.do
