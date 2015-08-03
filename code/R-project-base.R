#Basics for all scripts. Preferences etc.

set.seed(1337)
main_root=paste0(getwd(),"/")
#also removes "R_LIBS_USER"
#.libPaths(paste0(main_root,"code/Rlib"))

#v = Sys.getenv("var")

if (!exists("testing")) testing=0

if (!exists("verbose")) verbose=0
source(paste0(main_root,"code/R_utils.R"))

library(ggplot2)
theme_set(theme_bw())

#########################################
# Wrapper utils for my file paths
#########################################
wr_save_ggraph_parts <-function(gbase, title, note="", width=80, base_name){
	save_ggraph_parts(gbase, title, note, width=width, 
										rdata_file=paste0("fig/RData/", base_name, ".RData"),
										plain_file=paste0("fig/eps/", base_name, ".eps"), 
										titleless_file=paste0("fig/eps/cuts/", base_name, "_notitle.eps"), 
										bare_file=paste0("fig/eps/cuts/", base_name, "_bare.eps"),  
										note_file=paste0("fig/notes/",base_name,"_note.txt"),  
										title_file=paste0("fig/titles/",base_name,"_title.txt"))
}

wr_save_graph_call_w_wo_title <-function(filename_base, base_call, wid=6, hei=4,...){
	save_graph_call_w_wo_title(paste0("fig/eps/",filename_base, ".eps"), paste0("fig/eps/cuts/",filename_base, "_bare.eps"), base_call, wid=wid, hei=hei,...)
}
#Example:
#wr_save_graph_call_w_wo_title("scatter2", plot(x=mtcars$cyl, y=mtcars$disp), main="Main")

wr_log_open<-function(script_name){
	log_open(paste0("log/R/",script_name,".log"))
}