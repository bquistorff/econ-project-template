*! v1.1 bquistorff@gmail.com
*! saving text versions of title & notes (including wrapping for gph output) as well as the gph_file.
program save_fig
	version 12.0 //just a guess
	*Strip off and deal with my suboptions
	gettoken 0 remainder : 0, parse(":")
	syntax , gph_file(string) [title_file(string) caption_file(string) caption_tex_file(string) width(string)]
	gettoken colon 0 : remainder, parse(":")

	/* If had to load from already written file (but then can' unwrap caption well)
	tempname toexport
	graph use "`gph_file'", name(`toexport')
	qui graph describe
	local 0 `"`r(command)'"'
	* Remember to -drop drop `toexport'-
	*/
	syntax anything(equalok everything name=gph_cmd) [, title(string) note(string asis) *]

	tempname fhandle
	if "`title_file'"!="" & length(`"`title'"')>0{
		file open `fhandle' using "`title_file'", write text replace
		file write `fhandle' "`title'"
		file close `fhandle'
	}
	
	if "`caption_tex_file'"!="" & "`caption_file'"=="" tempfile caption_file
	
	if "`caption_file'"!="" & length(`"`note'"')>0{
		file open `fhandle' using "`caption_file'", write text replace
		if substr(`"`note'"',1,1)==`"""' | substr(`"`note'"',1,2)==`" ""'{
			local w_count : list sizeof note
			if `w_count'==1 file write `fhandle' `note'
			else{
				forval i=1/`w_count'{
					local line : word `i' of `note'
					if `i'>1 file write `fhandle' _n
					file write `fhandle' "`line'"
				}
			}
		}
		else{
			file write `fhandle' `"`note'"'
		}
		file close `fhandle'
		
		if "`caption_tex_file'"!="" escape_latex_file, txt_infile("`caption_file'") tex_outfile("`caption_tex_file'")
	}
	
	if "`width'"!=""{
		cap which wrap_text
		if _rc==0 wrap_text , unwrappedtext(`note') wrapped_out_loc(note) width(`width')
	}
	
	`gph_cmd', `options' title("`title'") note(`note') saving("`gph_file'", replace)
end
