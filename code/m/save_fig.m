function save_fig(fig_file, plain_pdf_file, titleless_pdf_file, noteless_pdf_file, bare_pdf_file, ...
	title_file, note_file, note)

savefig(fig_file)
orig_title = get(gca,'title');
orig_title = orig_title.String;
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
	end
	title('')
	if ~strcmp(bare_pdf_file,''); saveas(gcf, bare_pdf_file); end;
	%Add note
	
	%first shift plot to make room for note
	orig_units = get(gca,'Units');
	set(gca,'Units','inches')
	plot_pos0 = get(gca,'Position');
	diff0 = plot_pos0(3)/2;
	plot_pos1 = [plot_pos0(1),plot_pos0(2)+diff0,plot_pos0(3),plot_pos0(4)-diff0];
	set(gca,'Position',plot_pos1)

	%place the note
	MyBox = uicontrol('style','text','Units','inches','HorizontalAlignment','Left');
	%For some reason when printing to PDF the figure background goes to
	%white, but on the UI controls
	set(MyBox,'backgroundcolor',[1, 1, 1])
	init_note_pos = [0.15, 0.05, plot_pos0(3), 1];
	set(MyBox,'Position',init_note_pos)
	[wrapped_note,new_note_pos] = textwrap(MyBox,{note});
	set(MyBox,'String',wrapped_note,'Position',new_note_pos)

	%re-shift the graph back down
	diff1 = diff0 - (init_note_pos(4)-new_note_pos(4));
	plot_pos2 = [plot_pos1(1), plot_pos1(2)-diff1,plot_pos1(3),plot_pos1(4)+diff1];
	set(gca,'Position',plot_pos2)
	set(gca,'Units',orig_units)
	
	
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