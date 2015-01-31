#!/usr/bin/sed -f

#### Standard R output ####

### Time/speed-specific specific
s/[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}/-normalized-/g

### Machine-specific
##OS-dependent: file path

#make folder separators Unix-like
/normalizedroot/s/\\/\//g

### R details
s/^\(R version\|Platform:\) .\+/\1 -normalized-/g
s/^\(Copyright [\^0-9]\+\)[0-9]+ \(.\+\)/\1-normalized- \2/g
s/^\(HOSTNAME: \) [a-zA-Z0-9-]\+/\1 -normalized-/g

#### remove stuff that should be removed ####
/^LOGREMOVE/d
/^user\.self/d
/^Copyright/d
