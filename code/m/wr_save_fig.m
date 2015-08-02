function wr_save_fig(base_fname, note)
if nargin<2
	note=''
end
save_fig(strcat('../fig/fig/',base_fname,'.fig'), ...
	strcat('../fig/pdf/',base_fname,'.pdf'), ...
	strcat('../fig/pdf/cuts/',base_fname,'_notitle.pdf'), ...
	'', ...
	strcat('../fig/pdf/cuts/',base_fname,'_bare.pdf'), ...
	strcat('../fig/titles/',base_fname,'_title.txt'), ...
	strcat('../fig/notes/',base_fname,'_note.txt'), ...
	note)
end