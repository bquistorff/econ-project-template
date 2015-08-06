#Basics for all scripts. Preferences etc.
setwd("code")
source("packrat/init.R")
setwd("..")
#not sure why I need this off(), the lib-ext of sometimes created/destroyed
#sometimes there an error in here, but it seems inconsequential.
packrat::off() 
packrat::on(project="code")

set.seed(1337)

main_root=paste0(getwd(),"/")

#.libPaths(paste0(main_root,"code/Rlib")) #also removes "R_LIBS_USER"

#v = Sys.getenv("var")

if (!exists("testing")) testing=0

if (!exists("verbose")) verbose=0
source(paste0(main_root,"code/R_utils.R"))

library(ggplot2)
theme_set(theme_bw())

#########################################
# Wrapper utils for my file paths
#########################################
wr_save_ggraph_parts <-function(gbase, title, note="", note_width=80, base_name, ext="eps"){
	return(save_ggraph_parts(gbase, title, note, note_width=note_width, 
										rdata_file=paste0("fig/RData/", base_name, ".RData"),
										plain_file=paste0("fig/",ext,"/", base_name, ".",ext), 
										titleless_file=paste0("fig/",ext,"/cuts/", base_name, "_notitle.",ext), 
										bare_file=paste0("fig/",ext,"/cuts/", base_name, "_bare.",ext),  
										note_file=paste0("fig/notes/",base_name,"_note.txt"),
										note_tex_file=paste0("fig/notes/tex/",base_name,"_note.tex"),
										title_file=paste0("fig/titles/",base_name,"_title.txt")))
}

wr_save_graph_call_w_wo_title <-function(filename_base, base_call, wid=6, hei=4,...){
	save_graph_call_w_wo_title(paste0("fig/eps/",filename_base, ".eps"), paste0("fig/eps/cuts/",filename_base, "_bare.eps"), base_call, wid=wid, hei=hei,...)
}
#Example:
#wr_save_graph_call_w_wo_title("scatter2", plot(x=mtcars$cyl, y=mtcars$disp), main="Main")

wr_log_open<-function(script_name){
	log_open(paste0("log/R/",script_name,".log"))
}