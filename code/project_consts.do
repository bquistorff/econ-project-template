*See http://tex.stackexchange.com/questions/26149/automatic-wrapping-of-a-multicolumn-table-cell/108448#108448
*http://ideas.repec.org/c/boc/bocode/s457818.html
global PostFootTxt "\hline\hline \multicolumn{@span}{p{\linewidth}}{\footnotesize @note}\\ \end{tabular}}"
*don't use starlevels() as that won't put stars in superscript.
global star_opt "star(* 0.1 ** 0.05 *** 0.01)"
*Use non-breaking (protected) space so that there's no line break among elements.
global star_line "\(^{*}~p<.1\), \(^{**}~p<.05\), \(^{***}~p<.01\)"
