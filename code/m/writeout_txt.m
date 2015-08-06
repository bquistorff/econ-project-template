function writeout_txt(stuff, where)
	fid = fopen(where,'w');
	fprintf(fid, stuff);
	fclose(fid);
end
