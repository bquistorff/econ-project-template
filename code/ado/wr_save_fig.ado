*Wrapper for save_fig that: 
* -has our folders setup for ease
* -forces wraptext
program wr_save_fig
	gettoken 0 remainder_with_colon : 0, parse(":")
	syntax , name(string) [width(int 100)]

	save_fig, title_file("fig/titles/`name'_title.txt") ///
		caption_file("fig/notes/`name'_note.txt") ///
		gph_file("fig/gph/`name'.gph") width(`width') ///
		`remainder_with_colon'
end
