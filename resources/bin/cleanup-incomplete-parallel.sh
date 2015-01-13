#!/bin/bash

# Could also include code to remove the parallel junk
statab.sh do cli_parallel_clean.do
rm cli_parallel_clean.log
rm -f __*
rm -f l__pll*

# Some setups will use this at STATA TMP
for d in ../temp/__pll*/ ; do
    rmdir $d
done


