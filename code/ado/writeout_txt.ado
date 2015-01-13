*! Writes out a string to the snippets folder
program writeout_txt
	args towrite filename
	local filepath "${dir_base}/snippets/`filename'.txt"
	file open fhandle using "`filepath'", write text replace
	file write fhandle "`towrite'"
	file close fhandle
	
	if "${track_files}"=="1" {
		writeout_tracked_file "`filepath'"
	}
end
