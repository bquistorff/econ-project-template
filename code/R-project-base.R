#Basics for all scripts. Preferences etc.

#Do you have packages. Then look into http://rstudio.github.io/packrat/

#Do you want logging when done interactively? Here's a start. At the beginning.
#con <- file("test.log")
#sink(con, append=TRUE)
#sink(con, append=TRUE, type="message")
## Then at the end, restore
#sink() 
#sink(type="message")

##Print the install setup
#Generic ones:
sessionInfo()
print(paste("PWD: ",getwd()))
print(paste("HOSTNAME: ",Sys.getenv("HOSTNAME"))) #If on Windows (not from CYGWIN) then use COMPUTERNAME

#project-specific 
to_show = c()
to_hide = c("UNVERSIONED_DATA")
for(v in to_show){
	print(paste(v,": ",Sys.getenv(v)))
}
for(v in to_hide){
	print(paste("LOGREMOVE ",v,": ",Sys.getenv(v)))
}
