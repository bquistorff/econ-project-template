
#no element smaller than from, none bigger than "to"
inc_seq <- function(from = 1, to = 1, by=1){
	if(from>to)
		return(c())
	
	return(seq.int(from, to, by))
}

#A bit hacky, but don't know a better way
is_batch_mode<-function(){
	return(commandArgs()[2]=="-f")
}

#This both makes a similar call for normal grahpics as gtables
# and it doesn't try to print in batch mode (which would make a Rplot.pdf!))
show_graph<-function(gobj){
	if (!is_batch_mode()){
		if(is.grob(gobj)) grid.draw(gobj)
		else print(gobj)
	}
}

#TODO: put in the extra line breaks and do real char escaping
escape_latex_file<-function(note_file, note_tex_file){
	input <- readLines(note_file)
	#for now, do nothing
	output = input
	writeLines(output, note_tex_file)
}

#requires ggplot2 produced after June-2015
#returns the full graph. For notes, it's grid object so show with grid.draw rather than print
save_ggraph_parts<-function(gbase, title, note="", rdata_file="", plain_file="", title_file="", titleless_file="", noteless_file="", bare_file="", note_file="", note_tex_file="", note_width=80, width=4, height=3) {
	if (rdata_file!="") save(gbase, title, note, file=rdata_file)
	if (bare_file!="") ggsave(bare_file, gbase, width=width, height=height)
	
	#An alternative to ggtile() is the top= param in arrangeGrob()
	gtitled = gbase+ggtitle(title)
	if (noteless_file!="") ggsave(noteless_file, gtitled, width=width, height=height) 
	
	if (title_file!="") writeLines(title, title_file)
	
	library(grid)
	library(gridExtra)
	if (note!=""){
		if (note_file!="") writeLines(note, note_file)
		if (note_tex_file!="") escape_latex_file(note_file, note_tex_file)
		
		foot = textGrob(paste(strwrap(p_note, note_width),collapse="\n"))
		g1 <- arrangeGrob(gbase, bottom = foot)
		if (titleless_file!="") ggsave(titleless_file, g1, width=width, height=height)
		
		g2 <- arrangeGrob(gtitled, bottom = foot)
		if (plain_file!="") ggsave(plain_file, g2, width=width, height=height) 
		return(g2)
	}
	else{
		if (titleless_file!="") ggsave(titleless_file, gbase, width=width, height=height) 
		if (plain_file!="") ggsave(plain_file, gtitled, width=width, height=height) 
		return(gtitled)
	}
}

log_open <- function(){
	#Do you want logging when done interactively? Here's a start.
	#You really should have a wrapper that runs the script and source(echo=T)
	# after the below. Seems too cumbersome
	#con <- file(log_name)
	#sink(con, append=TRUE)
	#sink(con, append=TRUE, type="message")
	cat(paste0(" opened on: ",Sys.time(),"\n"))
	display_run_specs(c(),c("UNVERSIONED_DATA"))
	
	#return(con)
}

log_close <- function(){
	#Put proc stuff on one line so can filter easily
	x= proc.time()
	cat(paste("user.self:", x["user.self"], "\tsystem:", x["sys.self"], "\telapsed:", x["elapsed"],"\n"))
	packrat::off()
	#If doing the extra logging, then restore
	#sink() 
	#sink(type="message")
}

##Print the install setup
#Similar to sessionInfo(), but I don't care about different stuff
display_run_specs <- function(to_show, to_hide){
	#Generic ones:
	sessionInfo()
	cat(paste0("PWD: ",getwd(),"\n"))
	cat(paste0("HOSTNAME: ",Sys.getenv("HOSTNAME"),"\n")) #If on Windows (not from CYGWIN) then use COMPUTERNAME
	
	#project-specific 
	for(v in to_show){
		cat(paste0(v,": ",Sys.getenv(v),"\n"))
	}
	for(v in to_hide){
		cat(paste0("LOGREMOVE ",v,": ",Sys.getenv(v),"\n"))
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