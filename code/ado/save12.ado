*! Saves in version 12 format
*! Note: Won't work possibly for stata versions <12
program save12
	syntax anything [, replace save_convert_restore notrack]
	
	if "`save_convert_restore'"==""{
		if `c(stata_version)'>=13 {
			saveold `anything', `replace'
		}
		else {
			save `anything', `replace'
		}
	}
	else{
		if `c(stata_version)'>=13 {
			tempfile initdata
			qui save `initdata'
			use `anything', clear
			saveold `anything', `replace'
			use `initdata', clear
		}
	}
	
	if "${track_files}"=="1" & "`track'"!="notrack" {
		* Anything already grabs the quotes
		writeout_tracked_file `anything'
	}
end
