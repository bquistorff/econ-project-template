#This is meant to have the PWD be in the project root.
#It is included from the base makefile

writeups/%.pdf : writeups/%.lyx
#	cd writeups && lyx -e pdf2 $*.lyx
	latexmk -pdf -pdflatex="pdflatex -interactive=nonstopmode" -use-make writeups/$*.tex
	