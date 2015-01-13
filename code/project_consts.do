global unix_ts : display %12.0g clock("`c(current_date)' `c(current_time)'", "DMY hms" )/1000 - ///
					clock("1 Jan 1970", "DMY" )/1000
global unix_ts = trim("${unix_ts}")

*Useful for assigning to variable label so as to manage word wrap
global pbox_init = "\pbox[t]{\textwidth}" // \pbox[t]{\textwidth}{Good \\ Control \\ Data}

*See http://tex.stackexchange.com/questions/26149/automatic-wrapping-of-a-multicolumn-table-cell/108448#108448
*http://ideas.repec.org/c/boc/bocode/s457818.html
global PostFootTxt "\hline\hline \multicolumn{@span}{p{\linewidth}}{\footnotesize @note}\\ \end{tabular}}"

