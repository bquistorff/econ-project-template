#Basics for all scripts. Preferences etc.

#Do you have packages. Then look into http://rstudio.github.io/packrat/
#Global: script_name

log_output_file <-function(fname){
	flog = paste0("temp/lastrun/", script_name, "-files.txt")
	cat(fname,file=flog, sep="\n", append=TRUE)
}

log_open <- function(){
	#Do you want logging when done interactively? Here's a start.
	#You really should have a wrapper that runs the script and source(echo=T)
	# after the below. Seems too cumbersome
	#con <- file(paste0("log/Rout/",script_name,".Rout"))
	#sink(con, append=TRUE)
	#sink(con, append=TRUE, type="message")
	flog = paste0("temp/lastrun/", script_name, "-files.txt")
	err=try(file.remove(flog))
	log_output_file(paste0("log/Rout/",script_name,".Rout"))
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

save_data <- function(data, path){
	log_output_file(path)
	save(data, file=path)
}

#Save a ggplot2 w/ and w/o title in the appropriate folders (in PDF)
save_ggraph_w_wo_title <-function(filename_base, gbeginning, gtitle, gend=NULL, wid=6, hei=4){
	fname1 = paste0("fig/pdf/",filename_base, ".pdf")
	pdf(file=fname1, width=wid, height=hei)
	if(is.null(gend))
		try(print(gbeginning+gtitle))
	else
		try(print(gbeginning+gtitle+gend))
	dev.off()
	log_output_file(fname1)
	
	fname2 = paste0("fig/pdf/notitle/",filename_base, "_notitle.pdf")
	pdf(file=fname2, width=wid, height=hei)
	if(is.null(gend))
		try(print(gbeginning))
	else
		try(print(gbeginning+gend))
	dev.off()
	log_output_file(fname2)
}
#library(ggplot2)
#save_ggraph_w_wo_title(filename_base="scatter2", 
#											 gbeginning=ggplot(mtcars, aes(x=cyl, y=disp))+
#											 	geom_point(shape=1), 
#											 gtitle=ggtitle("Cylinders x Displacement"))


#Save single graph call (e.g plot but not ggplot2) w/ and w/o title in the appropriate folders (in PDF)
save_graph_call_w_wo_title <-function(filename_base, base_call, wid=6, hei=4,...){
	base_call = substitute(base_call)
	fname1 = paste0("fig/pdf/",filename_base, ".pdf")
	pdf(file=fname1, width=wid, height=hei)
	eval(as.call( c(as.list(base_call), ...) ))
	dev.off()
	log_output_file(fname1)
	
	fname2 = paste0("fig/pdf/notitle/",filename_base, "_notitle.pdf")
	pdf(file=fname2, width=wid, height=hei)
	eval( base_call )
	dev.off()
	log_output_file(fname2)
}

