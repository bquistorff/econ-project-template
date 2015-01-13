program save_fig
	args file_name_base
	
	local file_name "${dir_base}/fig/gph/`file_name_base'.gph"
	graph save "`file_name'", replace
	
	if "${track_files}"=="1" {
		writeout_tracked_file "`file_name'"
	}
end
