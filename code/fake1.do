* Description: Blah

*Header
local do_name fake1
include ${main_root}code/proj_header.do
set trace on
* Content
use ${main_root}data/clean/auto.dta
replace price=3*price 

local read_other = 1

save12 data/clean/auto2.dta, replace

writeout_txt 1, filename("snippets/fake1.txt")

if "`read_other'"=="1"{
	wrap_text, unwrappedtext("Hello yes") wrapped_out_loc(temp)
	copy resources/deps/fake1.do.dep.complex resources/deps/fake1.do.dep, replace
}
else{
	copy resources/deps/fake1.do.dep.simple resources/deps/fake1.do.dep, replace
}


include ${main_root}code/proj_footer.do
