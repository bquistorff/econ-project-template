# Fake project script
source("code/R-project-base.R", echo=TRUE, max.deparse.length=10000)
script_name="fake3"
log_open()

x = 2
saveRDS(x, file="data/estimates/fake3.RData")


library(ggplot2)
p <- qplot(1:10, 1:10)
p_note = "data from N. data from N. data from N. data from N. data from N. data from N. data from N. data from N"
wr_save_ggraph_parts(p, title="Note Test", note=p_note, base_name="plot1", width=40)

p2 = ggplot(mtcars, aes(x=cyl, y=disp))+geom_point(shape=1)
wr_save_ggraph_parts(p2, title="Cylinders x Displacement", base_name="scatter2")
								 
log_close()
