* all mata objects used across files (or even just all)
* Should be made into an mlib so you don't have to worry
* about including multiple times.
* This should also help a bit with speed.

*Possibly get some project-specific settings
qui include code/setup_ado.do

* Load all the mata files in ado/
local mata_files : dir "code/ado" files "*.mata"
foreach mata_file in `mata_files'{
	do "code/ado/`mata_file'"
}

mata:
mata mlib create lproject, replace dir("code/ado/l")
mata mlib add lproject *()
mata mlib index

end
