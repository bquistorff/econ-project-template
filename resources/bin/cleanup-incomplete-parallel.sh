#!/bin/bash

# Could also include code to remove the parallel junk
statab.sh do code/cli_parallel_clean.do
rm code/cli_parallel_clean.log
rm -f code/__*
rm -f code/l__pll*

# Some setups will use this at STATA TMP
for d in temp/__pll*/ ; do
    rmdir $d
done


