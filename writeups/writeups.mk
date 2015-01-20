#This is meant to have the PWD be in the project root.
#It is included from the base makefile

#writeups/%.pdf : writeups/%.lyx
#	lyx -e pdf2 writeups/$*.lyx
#	lyx -e pdfl writeups/$*.lyx
-include writeups/*.dep

#.INTERMEDIATE: writeups/fake_article.tex

writeups/%.tex : writeups/%.lyx
	cd writeups && lyx -e pdflatex $*.lyx

writeups/%.pdf : writeups/%.tex
	#we ignore this error so that the filtering still happens.
	-cd writeups; latexmk -pdf -f -pdflatex="cat responses | pdflatex -interaction=nonstopmode" -use-make -deps -deps-out=$*.d $*.tex
	cd writeups; cat $*.d | grep -v "\(texmf\|temp\|ProgramData\)"  > $*.d2 && mv $*.d2 $*.d
	cd writeups; cat $*.d | grep -v "^#" | sed -e "s@ \([^\. :]\)@ writeups/\1@g" -e "s|^\([^ #]\)|writeups/\1|g" -e "s|  \.\./|  |g" > $*.dep
	cd writeups; latexmk -c

