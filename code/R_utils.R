
#no element smaller than from, none bigger than "to"
inc_seq <- function(from = 1, to = 1, by=1){
	if(from>to)
		return(c())
	
	return(seq.int(from, to, by))
}

#requires ggplot2 produced after June-2015
save_ggraph_parts<-function(gbase, title, note="", plain_file="", title_file="", titleless_file="", noteless_file="", bare_file="", note_file="", width=80) {
	if (bare_file!="") ggsave(bare_file, gbase)
	
	#An alternative to ggtile() is the top= param in arrangeGrob()
	gtitled = gbase+ggtitle(title)
	if (noteless_file!="") ggsave(noteless_file, gtitled) 
	
	if (title_file!="") writeLines(title, title_file)
	
	library(grid)
	library(gridExtra)
	if (note!=""){
		if (note_file!="") writeLines(note, note_file)
		
		foot = textGrob(paste(strwrap(p_note, width),collapse="\n"))
		g1 <- arrangeGrob(gbase, bottom = foot)
		if (titleless_file!="") ggsave(titleless_file, g1)
		
		g2 <- arrangeGrob(gtitled, bottom = foot)
		grid.draw(g2)
		if (plain_file!="") ggsave(plain_file, g2) 
	}
	else{
		if (titleless_file!="") ggsave(titleless_file, gbase) 
		if (plain_file!="") ggsave(plain_file, gtitled) 
	}
}

log_open <- function(){
	#Do you want logging when done interactively? Here's a start.
	#You really should have a wrapper that runs the script and source(echo=T)
	# after the below. Seems too cumbersome
	#con <- file(log_name)
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


#Save single graph call (e.g plot but not ggplot2) w/ and w/o title 
#A bit old (can't handle notes) but worth keeping around.
save_graph_call_w_wo_title <-function(plain_file,titleless_file, base_call, wid=6, hei=4,...){
	base_call = substitute(base_call)

	postscript(file=plain_file, width=wid, height=hei, encoding="ISOLatin1.enc", paper = "special")
	eval(as.call( c(as.list(base_call), ...) ))
	dev.off()
	
	postscript(file=titleless_file, width=wid, height=hei, encoding="ISOLatin1.enc", paper = "special")
	eval( base_call )
	dev.off()
}