*! Appends another file to the file list
program writeout_tracked_file
	args filename
	qui file open fhandle using "${dir_base}/temp/lastrun/${do_name}-files.txt", write text append
	file write fhandle `"`filename'"' _n
	file close fhandle
end
