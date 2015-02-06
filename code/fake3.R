# Fake project script
code_path = "code/"
source("code/R-project-base.R", echo=TRUE, max.deparse.length=10000)
script_name="fake3"
log_open()

x = 2
save_data(x, path="data/estimates/fake3.RData")

save_graph_call_w_wo_title("scatter2", 
													 plot(x=mtcars$cyl, y=mtcars$disp),
													 main="Main")
log_close()
