function save_fig(fig_file, plain_pdf_file, titleless_pdf_file, noteless_pdf_file, bare_pdf_file, ...
	title_file, note_file, note_tex_file, note)

savefig(fig_file)
h = get(gca,'title');
orig_title = get(h,'String');
if ~strcmp(title_file,'')
	fid = fopen(title_file,'w');
	fprintf(fid, orig_title);
	fclose(fid);
end

%normal PDF out put has huge borders
%http://stackoverflow.com/questions/5256516/matlab-print-a-figure-to-pdf-as-the-figure-shown-in-the-matlab
set(gcf,'Units','inches');
screenposition = get(gcf,'Position');
set(gcf, 'PaperPosition',[0 0 screenposition(3:4)], 'PaperSize', [screenposition(3:4)]);

if ~strcmp(noteless_pdf_file,''); saveas(gcf, noteless_pdf_file); end;

if ~strcmp(note,'')
	if ~strcmp(note_file,'')
		fid = fopen(note_file,'w');
		fprintf(fid, note);
		fclose(fid);
		if ~strcmp(note_tex_file,'')
			escape_latex_file(note_file, note_tex_file)
		end
	end
	title('')
	if ~strcmp(bare_pdf_file,''); saveas(gcf, bare_pdf_file); end;
	%Add note
	
	%first shift plot to make room for note
	ax1 = gca;
	orig_units = get(ax1,'Units');
	set(ax1,'Units','norm')
	plot_pos0 = get(ax1,'Position');
	diff0 = plot_pos0(3)/2;
	plot_pos1 = [plot_pos0(1),plot_pos0(2)+diff0,plot_pos0(3),plot_pos0(4)-diff0];
	set(ax1,'Position',plot_pos1)

	%place the note
	ax2 = axes('Position',[0 0 1 1],'Visible','off');
	wrapped_note2=textwrap({note},100);
	t1_orig_coord = [0.05, .3];
	t1=text(t1_orig_coord(1),t1_orig_coord(2),wrapped_note2, 'VerticalAlignment','top', 'HorizontalAlignment','left');
	t1_orig_pos = get(t1,'extent');
	set(t1,'Position',[t1_orig_coord(1), t1_orig_pos(4)+.05]);
	diff1 = t1_orig_pos(4)+.18;
	%{
	%Was trying to do uicontrols as that doesn't require second axis but
	% can't make PDFs of these on Linux.
	MyBox = uicontrol('style','text','Units','inches','HorizontalAlignment','Left');
	%For some reason when printing to PDF the figure background goes to
	%white, but on the UI controls
	set(MyBox,'backgroundcolor',[1, 1, 1])
	init_note_pos = [0.15, 0.05, plot_pos0(3), 1];
	set(MyBox,'Position',init_note_pos)
	[wrapped_note,new_note_pos] = textwrap(MyBox,{note});
	set(MyBox,'String',wrapped_note,'Position',new_note_pos)
	diff1 = diff0 - (init_note_pos(4)-new_note_pos(4));
	%}
	
	%re-shift the graph back down
	plot_pos2 = [plot_pos1(1), plot_pos1(2)-diff1,plot_pos1(3),plot_pos1(4)+diff1];
	set(ax1,'Position',plot_pos2)
	set(ax1,'Units',orig_units)
	
	
	if ~strcmp(titleless_pdf_file,''); saveas(gcf, titleless_pdf_file); end;
	title(orig_title)
	if ~strcmp(plain_pdf_file,''); saveas(gcf, plain_pdf_file); end;
else
	if ~strcmp(plain_pdf_file,''); saveas(gcf, plain_pdf_file); end;
	title('')
	if ~strcmp(titleless_pdf_file,''); saveas(gcf, titleless_pdf_file); end;
	if ~strcmp(bare_pdf_file,''); saveas(gcf, bare_pdf_file); end;
	title(orig_title)
end

end
