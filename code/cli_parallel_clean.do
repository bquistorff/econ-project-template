*Callable from the command line for converting a gph to eps's in the right places
global dir_base "./"
adopath ++ "${dir_base}code/ado/"
parallel clean , all force
