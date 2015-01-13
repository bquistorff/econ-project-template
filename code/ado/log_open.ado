* A wrapper for a standard project setup
program log_open
	args do_name

	local log_file "${dir_base}/log/smcl/`do_name'${extra_f_suff}.smcl"
	* The name can't contain "-"
	log_open_base using "`log_file'", replace name(`do_name')
	
	if "${track_files}"=="1" {
		global do_name "`do_name'"
		*Reset the log file
		cap rm "${dir_base}/temp/lastrun/${do_name}-files.txt"
		writeout_tracked_file "`log_file'"
	}
end
 
* The basics of opening a log everytime.
program log_open_base
	syntax using/ [, name(string) replace]
	if "`name'"!=""{
		cap log close `name'
	}
	log using "`using'", `replace' name(`name')
	
	display_install_specs
end
