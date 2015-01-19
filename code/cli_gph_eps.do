*Callable from the command line for converting a gph to eps's in the right places
global dir_base "."
adopath ++ "${dir_base}/code/ado/"
gph2fmt `1'.gph eps
if "`2'"!=""{
    gph2fmt `1'.gph `2'
}
