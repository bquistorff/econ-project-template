function escape_latex_file(txt_file, tex_file)
	%TODO: real character escaping
	infile = fopen(txt_file,'r');
	outfile = fopen(tex_file,'w');
	
	tline = fgetl(infile);
	line=1;
	while ischar(tline)
		if line>1
			fprintf(outfile, '\n\n');
		end
		fprintf(outfile, tline);
		tline = fgetl(infile);
		line=line+1;
	end
	
	fclose(infile);
	fclose(outfile);
end
