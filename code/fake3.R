# Fake project script
code_path = "code/"
source(paste0(code_path,"R-project-base.R"), echo=TRUE, max.deparse.length=10000)
script_name="fake3"
log_open()

x = 2
x

log_close()
