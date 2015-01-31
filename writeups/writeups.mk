#This is meant to have the PWD be in the project root.
#It is included from the base makefile

-include writeups/.*.dep

HAVE_LATEXMK := $(shell command -v latexmk 2>/dev/null)

ifneq "$(HAVE_LATEXMK)" ""

writeups/%.tex : writeups/%.lyx
	cd writeups && lyx -e pdflatex $*.lyx
#note: using auxdir in the first latexmk line does work (compilation fails) so do a cleanup (-c) after.
writeups/%.pdf : writeups/%.tex
	echo "$(HAVE_LATEXMK)"
	#we ignore this error so that the filtering still happens.
	-cd writeups; latexmk -pdf -f -pdflatex="yes '' | pdflatex -interaction=nonstopmode" -use-make -deps -deps-out=$*.d $*.tex
	cd writeups; cat $*.d | grep -v "\(texmf\|MiKTeX\|ProgramData\|temp\)"  > $*.d2 && mv $*.d2 $*.d
	cd writeups; to_parent_dep.sh writeups $*.d .$*.dep
	cd writeups; latexmk -c
	normalize_pdf.sh writeups/$*.pdf
#Alternative (only if have LyX on all platforms)
#writeups/%.pdf : writeups/%.lyx
#	lyx -e pdfl writeups/$*.lyx
#	normalize_pdf.sh writeups/$*.pdf
#Do we want to delete the tex files after compilation?
#.INTERMEDIATE: writeups/fake_article.tex

else

writeups/%.tex : writeups/%.lyx
	cd writeups && lyx -e pdflatex $*.lyx
writeups/%.pdf : writeups/%.tex
	cd writeups && pdflatex -interaction=nonstopmode -aux-directory=../temp $*.tex
	normalize_pdf.sh writeups/$*.pdf
#Alternative (only if have LyX on all platforms)
#writeups/%.pdf : writeups/%.lyx
#	lyx -e pdf2 writeups/$*.lyx
#	#normalize_pdf.sh writeups/$*.pdf
#	#Even after normalizing this appears to change. 
 
endif
