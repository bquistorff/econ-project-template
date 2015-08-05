#! /bin/bash
# Wrapper for Matlab batch-mode which:
#  -cd's to the directory
#  -can be called with filename (and removes the ".m")
#  -wraps the call in error catching code

filename=$(basename "$1")
fname_base="${filename%.*}"
fdir=$(dirname "$1")
matlab -nodesktop -wait -nosplash -r "addpath('$fdir'); try; $fname_base; catch err; disp(err); disp(err.message); disp(err.identifier); exit(1); end; exit(0);" > /dev/null
# could have the following before the ">": -logfile log/m/$fname_base.log
# could have also 'cd $fdir' instead of adding to path. But the current way is more in  line with other programs.
# If not doing any graphics could alos have -noFigureWindows