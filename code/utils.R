
#no element smaller than from, none bigger than "to"
inc_seq <- function(from = 1, to = 1, by=1){
	if(from>to)
		return(c())
	
	return(seq.int(from, to, by))
}