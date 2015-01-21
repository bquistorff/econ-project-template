#!/usr/bin/env python3
#
# Rewrites a dataset without the timestamp nor junk in padding
# Helps making things bit-reproducible.
# Doesn't convert byte-order for numerical types.

import struct, sys, datetime, glob, tempfile, shutil, os, getopt

def error(message):
	sys.stderr.write(message + '\n')
	sys.exit(1)

#If encounters null, fill fill rest of length with 0s.
def zero_pading(fh, width):
	for i in range(width):
		char_read = fh.read(1)
		if char_read!=b'\x00':
			continue
		zero_out(fh,width-(i+1))
		break
	
def zero_out(fh, width):
	fh.write(bytearray(width))

C_TYPE_NBYTES = dict([('b', 1), ('B',1), ('h', 2), ('H',2), ('i', 4), ('I',4), ('f', 4), ('d', 4)])

def read_num_ensure_byteorder(fh, format, orig_byteorder='<', final_byteorder='<'):
	nbytes = C_TYPE_NBYTES[format]
	block = fh.read(nbytes)
	#print("read_num: " + format + " " + str(nbytes) +" "+str(len(block)) + " " + str(fh.tell()))
	num = struct.unpack(orig_byteorder + format, block)[0]
	if nbytes>1 and orig_byteorder!=final_byteorder:
		fh.seek(-1*nbytes,1)
		fh.write(struct.pack(final_byteorder+format, num)[:nbytes])
	return num
	
def normalize_file(fname, force_lohi):
	fh = open(fname, "r+b")
	
	#Header
	format_version = read_num_ensure_byteorder(fh,'b')
	if format_version not in [114, 115]:
		error("Stata file is not v114 (Stata 10/11) or v115 (Stata 12)")
	bo_num = read_num_ensure_byteorder(fh,'b')
	orig_byteorder = bo_num == 0x1 and '>' or '<'
	if force_lohi:
		final_byteorder = '<'
		if orig_byteorder!=final_byteorder:
			fh.seek(-1,1)
			fh.write(struct.pack(final_byteorder+'b', 0x2)[:1]) 
	else:
		final_byteorder = orig_byteorder
	
	fh.read(2) #unused
	nvar = read_num_ensure_byteorder(fh, 'H', orig_byteorder, final_byteorder)
	nobs = read_num_ensure_byteorder(fh, 'I', orig_byteorder, final_byteorder)
	zero_pading(fh, 81) #data_label
	zero_out(fh,18) #time_stamp
	
	#Descriptors
	#print("Descriptors. Pos=" + str(fh.tell()))
	types=[read_num_ensure_byteorder(fh,'B', orig_byteorder, final_byteorder) for i in range(nvar)] #typlist
	for i in range(nvar): #varlist
		zero_pading(fh,33)
	for i in range(nvar+1): #srtlist
		vnum = read_num_ensure_byteorder(fh, 'H', orig_byteorder, final_byteorder)
		if vnum==0:
			zero_out(fh,(nvar+1-(i+1))*2) #i is 0 zero-indexed
			break
	for i in range(nvar): #fmtlist
		zero_pading(fh,49)
	for i in range(nvar): #lbllist
		zero_pading(fh,33)
	
	#variable labels
	#print("Variable labels. Pos=" + str(fh.tell()))
	for i in range(nvar):
		zero_pading(fh,81)
	
	#Expansion fields
	#print("Expansion fields. Pos=" + str(fh.tell()))
	while True:
		data_type = fh.read(1)
		data_len = read_num_ensure_byteorder(fh,'I', orig_byteorder, final_byteorder)

		#print("Exp field header " + str(data_type) + " " + str(data_len))
		if data_type == b'\x00':
			break
		zero_pading(fh, 33)
		zero_pading(fh, 33)
		fh.seek(data_len-66,1)

	#Data
	#print("Data. Pos=" + str(fh.tell()))
	num_paddable_strs = sum([dnum<=244 and dnum>1 for dnum in types])
	width_map = list(range(244+1)) + [0,0,0,0,0,0] + [1,2,4,4,8]
	c_format_map = ['b','h','i','f','d'] #index 0==stata dnum 251
	widths = [width_map[dnum] for dnum in types]
	obs_width = sum(widths)
	if orig_byteorder!=final_byteorder:
		for obs_i in range(nobs):
			for dnum in types:
				if dnum<=244: #prob faster to include char1 rather than keep testing
					zero_pading(fh, dnum)
				else:
					read_num_ensure_byteorder(fh, c_format_map[dnum-251], orig_byteorder, final_byteorder)
		
	elif num_paddable_strs>0 :
		for obs_i in range(nobs):
			for dnum in types:
				if dnum<=244 and dnum>1: #zero pad the strings
					zero_pading(fh, dnum)
				else:
					fh.seek(width_map[dnum],1)
	else:
		fh.seek(obs_width*nobs,1)
	
	#Value labels
	while True:
		#check for EOF
		val_label_table_start = fh.read(1)
		if val_label_table_start==b'':
			break
		fh.seek(-1,1)
		#Now process for real
		len = read_num_ensure_byteorder(fh, 'I', orig_byteorder, final_byteorder)
		zero_pading(fh,33)
		fh.seek(3,1)
		n = read_num_ensure_byteorder(fh, 'I', orig_byteorder, final_byteorder)
		txtlen = read_num_ensure_byteorder(fh, 'I', orig_byteorder, final_byteorder)
		for i in range(2*n):
			read_num_ensure_byteorder(fh, 'I', orig_byteorder, final_byteorder) #off[] and val[]
		fh.seek(txtlen,1)
	
	fh.close()


def main(argv):
	try:
		optlist, files = getopt.getopt(argv[1:], "hn")
	except getopt.GetoptError as err:
		print(err)
		error('usage: %s [-h] [-f] [-n] files' % os.path.basename(argv[0]))

	newfile = False
	force_lohi = False
	for o, a in optlist:
		if o == "-h":
			print("Usage: %s [-h] [-n] files")
			print("Options:")
			print("	  -h   Print help")
			print("	  -n   Make new files with extension .nor")
			print("Example:")
			print("	 %s data/ds1.dta data/ds2.dta" % os.path.basename(argv[0]))
			sys.exit(0)
		elif o == "-n":
			newfile = True
		elif o == "-f":
			force_lohi = True
		else:
			error('unhandled option [%s,%s]' % (o, a))

	if len(files)==0:
		error("No files found")
	else:
		for file in files:
			file = file.strip()
			if newfile:
				old_fname = file
				file = file + ".nor"
				shutil.copyfile(old_fname, file)
				#print("Normalizing: " + old_fname + " > " + file)
			else:
				pass
				#print("Normalizing: " + file)
			normalize_file(file, force_lohi)
	
	
if  __name__ =='__main__':
	main(sys.argv)