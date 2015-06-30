* A wrapper for a standard project setup
program log_open
	args do_name

	*Don't use names for now
	* The name can't contain "-"
	*cap log close `do_name'
	log using "log/do/`do_name'.log", replace /*name(`do_name')*/
	
	display_run_specs
	
end
