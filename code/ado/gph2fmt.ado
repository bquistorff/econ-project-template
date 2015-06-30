*! converts a *.gph file to another format
* Required globals: dir_base
program gph2fmt
	args file fmt solo_type
	
	graph use "${dir_base}fig/gph/`file'", name(toexport)
	
	local temp=regexm("`file'","(.+)\.gph")
	local file_name_base=regexs(1) 
	
	if "`solo_type'"!="bare" {
		graph export "fig/`fmt'/`file_name_base'.`fmt'", replace
	}
	
	if "`solo_type'"!="title" {
		qui graph describe
		local 0 `"`r(command)'"'
		syntax anything(equalok everything), title(string) note(string asis) *
		
		if length(`"`title'"')>0{
			file open fhandle using "fig/`fmt'/bare/`file_name_base'_title.txt", write text replace
			file write fhandle "`title'"
			file close fhandle
		}
		
		if length(`"`note'"')>0{
			file open fhandle using "fig/`fmt'/bare/`file_name_base'_caption.txt", write text replace
			if substr(`"`note'"',1,1)==""{
				forval i=1/`: word count `note''{
					file write fhandle `"`: word `i' of `note''"'
				}
			}
			else{
				file write fhandle `"`note'"'
			}
			file close fhandle
		}
		
		gr_edit .title.draw_view.setstyle, style(no)
		gr_edit  .note.draw_view.setstyle, style(no)
		graph export "fig/`fmt'/bare/`file_name_base'_bare.`fmt'", replace
	}
	
	graph drop toexport
	
end
