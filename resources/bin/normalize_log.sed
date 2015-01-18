#!/usr/bin/sed -f

#### Standard Stata output ####

### Time/speed-specific specific
s/[ 0-9][0-9] [A-Z][a-z][a-z] [0-9]\{4\},\? ..:..\(:..\)\?/-normalized-/g

### Machine-specific
##OS-dependent: file path

#make folder separators Unix-like
/normalizedroot/s/\\/\//g
# Other FS macros (these include paths not already normalized)
s/^\(\(S_FN\|S_ADO\): *\).\+/\1-normalized-/g
## Other OS-dependent
# Optional
s/^\(S_OS: \+\).\+/\1-normalized-/g

### Hardware details
s/^\(S_MACH: \+\).\+/\1-normalized-/g
#sometimes appear
/^S_OSDTL: /d
# Appears in different orders on different machines
/^S_level: /d

### Stata details
s/^\(S_FLAVOR: \+\).\+/\1-normalized-/g
s/c(\(os\|osdtl\|machine_type\|byteorder\|flavor\|stata_version\|processors\)) = .\+/c(\1) = -normalized-/g
#sometimes appear
/^S_\(StataMP\|StataSE\|CONSOLE\|MODE\): /d

#### Module -parallel- ####
# FS macros
s/^\(\(Stata dir\|PLL_DIR\): *\).\+/\1-normalized-/g
# these change (via user) with num CPUs
s/^\(\(Clusters *:\|PLL_CLUSTERS:\|numclusters:\|. global numclusters\|LAST_PLL_N:\|N Clusters:\) *\).\+/\1-normalized-/g
# the # of these changes with # CPUs (and appear in random order)
/^cluster [0-9]\+ has exited without error.../d
# Random components
s/^\(\(pll_id\|ID\|pid\|LAST_PLL_ID\) *: \+\).\+/\1-normalized-/g

#### print_dots.ado ####
# My timing functions depend on computer speed
s/^After .\+/-normalized-/g
s/^\(\.[^0-9]*\)[0-9]\+\(s elapsed\.\)/\1-normalized-\2/g

#### display_run_specs.ado ####
/^LOGREMOVE/d
