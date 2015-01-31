#Basics for all scripts. Preferences etc.

#Do you have packages. Then look into http://rstudio.github.io/packrat/

log_open <- function(){
	
	#Do you want logging when done interactively? Here's a start. At the beginning.
	#Then you really should have a wrapper that runs the script and source(echo=T)
	# after the below. Seems too cumbersome
	#con <- file(paste0("log/Rout/",name,".Rout"))
	#sink(con, append=TRUE)
	#sink(con, append=TRUE, type="message")
	
	display_run_specs(c(),c("UNVERSIONED_DATA"))
	
	#return(con)
}

log_close <- function(){
	#Put proc stuff on one line so can filter easily
	x= proc.time()
	cat(paste("user.self:", x["user.self"], "\tsystem:", x["sys.self"], "\telapsed:", x["elapsed"],"\n"))
	
	#If doing the extra logging, then restore
	#sink() 
	#sink(type="message")
}

##Print the install setup
display_run_specs <- function(to_show, to_hide){
	#Generic ones:
	sessionInfo()
	cat(paste("PWD: ",getwd(),"\n"))
	cat(paste("HOSTNAME: ",Sys.getenv("HOSTNAME"),"\n")) #If on Windows (not from CYGWIN) then use COMPUTERNAME
	cat(paste("Time: ",Sys.time(),"\n"))

	#project-specific 
	for(v in to_show){
		cat(paste(v,": ",Sys.getenv(v),"\n"))
	}
	for(v in to_hide){
		cat(paste("LOGREMOVE ",v,": ",Sys.getenv(v),"\n"))
	}
}

