*converting a gph to eps's (or other fmt) in the right places
*Callable from the command line 
local file_name_base "`1'"
local ext_fmt "`2'"
if "$S_ADO"!="PERSONAL;BASE" adopath ++ "code/ado/" //called from command-line
gph2fmt "fig/gph/`file_name_base'.gph", ///
	plain_file("fig/eps/`file_name_base'.eps")  ///
	bare_file("fig/eps/bare/`file_name_base'_bare.eps")
	*titleless_file("fig/eps/notitle/`file_name_base'_notitle.eps")
if "`ext_fmt'"!=""{
	gph2fmt "fig/gph/`file_name_base'.gph", ///
		plain_file("fig/`ext_fmt'/`file_name_base'.`ext_fmt'")  ///
		bare_file("fig/`ext_fmt'/bare/`file_name_base'_bare.`ext_fmt'")
		*titleless_file("fig/`ext_fmt'/notitle/`file_name_base'_notitle.`ext_fmt'")
}
