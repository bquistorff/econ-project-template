#! /usr/bin/env python

'''
Normalizes a Stata .gph graph file to remove build-specific information.
Filepaths, dates, times, and random IDs are converted so that the file
will be the same no matter where it is built.

Pass in a file pattern (that is quoted so the shell doesn't expand it).

To do:
-For serset, what if string variable?
'''


import os, sys, tempfile, shutil, re, glob, getopt

# See http://code.activestate.com/recipes/66434-change-line-endings/ for general
def unixline(line):
	# from Windows
	if len(line)>=2 and line[-2:]=="\r\n":
		return line[:-2]+'\n'
	# from Mac
	if len(line)>=1 and line[-1:]=="\r":
		return line[:-1]+'\n'
	return line


# splits line and makes sure each chunk's padding after
# zero-termination is zeroed out.
def zero_pad_list(line, numseries):
	width = len(line)/numseries
	newline = ''
	for series in range(0, numseries):
		startloc = series * width
		loc_zero = line.find('\x00', startloc, startloc + width)
		if(loc_zero!=-1):
			newline += line[startloc:loc_zero] + '\x00'*(width - (loc_zero - startloc))
		else:
			newline += line[startloc:startloc+width]
	return newline

	
def normalize_file(in_fname, newfile=False):
	in_fh = open(in_fname, "rb")
	if newfile:
		out_fname = in_fname + ".nor"
		out_fh = open(out_fname, "wb")
		#print("Normalizing: " + in_fname + " > " + out_fname)
	else:
		out_fh = tempfile.NamedTemporaryFile("wb", delete=False)
		out_fname = out_fh.name
		#print("Normalizing: " + in_fname)

	idnum = 1
	replace_list = {}
	inserset = False
	for line in in_fh:
		# Remove the time- and filesystem-specific info
		# Maybe I should be writing blank values for the RHS ones, but works currently
		if line.find("*! command_date:") == 0 or line.find(".date ") == 0 or \
			line.find("*! command_time:") == 0 or line.find(".time ") == 0 or \
			line.find("*! datafile:") == 0 or line.find(".dta_file") == 0 or \
			line.find("*! datafile_date:") == 0 or line.find(".dta_date ") == 0 :
			continue
		
		if line.find("<BeginSerset>") == 0:
			numseries = 0
		
		if line.find("<BeginSeries>") == 0:
			numseries = numseries + 1	
		
		# Don't do id replacing or line conversion in serset
		# Also zero out the padding in the string fields
		if inserset:
			if line.find("<EndSersetData>") == 0:
				start_vlist = 26 + numseries
				start_flist = start_vlist + numseries*54
				start_data = start_flist + numseries*49
				out_fh.write(sersetline[:start_vlist])
				out_fh.write(zero_pad_list(sersetline[start_vlist:start_flist], numseries))
				out_fh.write(zero_pad_list(sersetline[start_flist:start_data], numseries))
				out_fh.write(unixline(sersetline[start_data:]))
				
				out_fh.write(unixline(line))
				inserset = False
			else:
				sersetline = sersetline+line
			continue

		if line.find("sersetreadwrite") == 0:
			inserset = True
			sersetline = line
			continue
		
		# Windows vs Unix string formating of decimals can be off by a digit
		mat = re.match("^(\.m(in|ax) =.+\.[0-9]{12})[0-9]+", line)
		if(mat != None):
			out_fh.write(mat.group(1)+'\n')
			continue

		# Replace the random ids with deterministic ones 
		#  (same seed doesn't seem to make these deterministic)
		mat = re.match("<BeginItem> [^ ]+ ([^\s]+)", line)
		if(mat != None):
			replace_list[mat.group(1)] = 'K%07x' %  idnum
			idnum = idnum + 1

		for k, v in replace_list.iteritems():
			line = line.replace(k,v)

		out_fh.write(unixline(line))

	in_fh.close()
	out_fh.close()
	
	if not newfile:
		shutil.copyfile(out_fname, in_fname)
		os.remove(out_fname)


def error(message):
	sys.stderr.write(message + '\n')
	sys.exit(1)

	
def main(argv):
	try:
		optlist, files = getopt.getopt(argv[1:], "hn")
	except getopt.GetoptError as err:
		print(err)
		error('usage: %s [-h] [-n] files' % os.path.basename(argv[0]))

	newfile = False
	for o, a in optlist:
		if o == "-h":
			print("Usage: %s [-h] [-n] files")
			print("Options:")
			print("      -h   Print help")
			print("      -n   Make new files with extension .nor")
			print("Example:")
			print("     %s fig/gph/plot1.gph fig/gph/plot2.gph" % os.path.basename(argv[0]))
			sys.exit(0)
		elif o == "-n":
			newfile = True
		else:
			error('unhandled option [%s,%s]' % (o, a))

	if len(files)==0:
		error("No files found")
	else:
		for file in files:
			normalize_file(file.strip(), newfile)


if __name__ == "__main__":
	main(sys.argv)
