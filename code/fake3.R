# Fake project script
source("code/R-project-base.R", echo=TRUE, max.deparse.length=10000)
script_name="fake3"
log_open()

x = 2
saveRDS(x, file="data/estimates/fake3.RData")

cat("stuff",file="snippets/fake3.txt")

p <- qplot(1:10, 1:10)
p_note = "data from N. data from N. data from N. data from N. data from N. data from N. data from N. data from N"
p_grid = wr_save_ggraph_parts(p, title="Note Test", note=p_note, base_name="plot1", note_width=40)
show_graph(p_grid)

library(haven)
auto2 = read_dta("data/clean/auto2.dta")
p2 = ggplot(auto2, aes(x=mpg, y=price))+geom_point(shape=1)
p2_full = wr_save_ggraph_parts(p2, title="Cylinders x Displacement", base_name="scatter2")
show_graph(p2_full)				
			 
log_close()
