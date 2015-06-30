#Basics for all scripts. Preferences etc.

set.seed(1337)
main_root=paste0(getwd(),"/")
#also removes "R_LIBS_USER"
.libPaths(paste0(main_root,"code/Rlib"))

#v = Sys.getenv("var")

if (!exists("testing")){
	testing=0
}
if (!exists("verbose")){
	verbose=0
}
source(paste0(main_root,"code/R_utils.R"))
