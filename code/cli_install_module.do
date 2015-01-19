*Callable from the command line for install packages from local store (that need machine-specific installation)
*Non-SSC installs: see code/readme.txt
global dir_base "."

* Use the -net set- line before installing other packages
net set ado "${dir_base}/code/ado/"
local letter1 = substr("`1'",1,1)
net install `1' , all force from("`c(pwd)'/${dir_base}/code/ado-store/`letter1'/")

