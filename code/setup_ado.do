*Override the PLUS (so that -ado dir- and -ssc uninstall- work)
sysdir set PLUS "code/ado"
global S_ADO "PLUS;BASE"
net set ado PLUS
mata: mata mlib index
