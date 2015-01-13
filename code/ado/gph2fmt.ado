*! converts a *.gph file to another format
* Required globals: dir_base
program gph2fmt
	args file fmt
	
	graph use "${dir_base}/fig/gph/`file'", name(toexport)
	
	local temp=regexm("`file'","(.+)\.gph")
	local file_name_base=regexs(1) 
	
	graph export "${dir_base}/fig/`fmt'/`file_name_base'.`fmt'", replace
	gr_edit .title.draw_view.setstyle, style(no)
	graph export "${dir_base}/fig/`fmt'/notitle/`file_name_base'_notitle.`fmt'", replace
	
	graph drop toexport
	
end
