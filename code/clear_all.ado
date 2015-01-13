* This is more a note that -clear all- doesn't clear all
program clear_all
	clear all
	mac drop _all
	cap restore, not
	profiler off
	
	* Usually not needed:
	*closeallmatafiles
	*global S_ADO= `"`"BASE"';`"SITE"';`"."';`"PERSONAL"';`"PLUS"';`"OLDPLACE"'"'
end
