*Override the PLUS (so that -ado dir- and -ssc uninstall- work)
*  this is better than setting the env var S_ADO
*Could put this in a .profile in the root, but want this to work interactively on Windows.
sysdir set PLUS "code/ado"
global S_ADO "PLUS;BASE"
net set ado PLUS
mata: mata mlib index
