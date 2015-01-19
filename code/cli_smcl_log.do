*Callable from the command line for converting a gph to eps's in the right places
global dir_base "."
translate "${dir_base}/log/smcl/`1'.smcl" "${dir_base}/log/`1'.log", replace linesize(140)
