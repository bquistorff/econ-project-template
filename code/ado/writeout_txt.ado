*! Writes out a string to the snippets folder
program writeout_txt
	args towrite filename
	local filepath "snippets/`filename'.txt"
	file open fhandle using "`filepath'", write text replace
	file write fhandle "`towrite'"
	file close fhandle
end
