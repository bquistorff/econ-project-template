#This is meant to have the PWD be in the project root.
#It is included from the base makefile

#writeups/%.pdf : writeups/%.lyx
#	lyx -e pdf2 writeups/$*.lyx
#	lyx -e pdfl writeups/$*.lyx
-include writeups/.*.dep

#Do we want to delete the tex files after compilation?
#.INTERMEDIATE: writeups/fake_article.tex

writeups/%.tex : writeups/%.lyx
	cd writeups && lyx -e pdflatex $*.lyx

#note: using auxdir in the first latexmk line does work (compilation fails) so do a cleanup (-c) after.
writeups/%.pdf : writeups/%.tex
	#we ignore this error so that the filtering still happens.
	-cd writeups; latexmk -pdf -f -pdflatex="yes '' | pdflatex -interaction=nonstopmode" -use-make -deps -deps-out=$*.d $*.tex
	cd writeups; cat $*.d | grep -v "\(texmf\|MiKTeX\|ProgramData\|temp\)"  > $*.d2 && mv $*.d2 $*.d
	cd writeups; to_parent_dep.sh writeups $*.d .$*.dep
	cd writeups; latexmk -c

