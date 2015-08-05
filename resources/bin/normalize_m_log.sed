#!/usr/bin/sed -bf

#### Standard m output ####

### Machine-specific
s/^\(hostname: \).\+/\1-normalized-/g
##OS-dependent: file path
s/^\(PWD: \).\+/\1-normalized-/g

### Hardware details
s/^\(Computer: \).\+/\1-normalized-/g
s/^\(numCores: \).\+/\1-normalized-/g

### Matlab details
s/^\(Version: \).\+/\1-normalized-/g
s/^\(Version (Java): \).\+/\1-normalized-/g

#### Other stuff ####
/^LOGREMOVE/d
s/^\(log opened on:\).\+/\1-normalized-/g
s/^\(log closed on:\).\+/\1-normalized-/g

