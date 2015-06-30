program save_fig
	args file_name_base
	
	graph save "fig/gph/`file_name_base'.gph", replace
end
