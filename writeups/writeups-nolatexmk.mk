#This is meant to have the PWD be in the project root.
#It is included from the writeups makefile
writeups/%.tex : writeups/%.lyx
	cd writeups && lyx -e pdflatex $*.lyx

writeups/%.pdf : writeups/%.tex
	cd writeups && pdflatex -interaction=nonstopmode -aux-directory=../temp $*.tex

#Alternatively could build it directly (only if have LyX on all platforms)
#writeups/%.pdf : writeups/%.lyx
#	lyx -e pdf2 writeups/$*.lyx
# Could do this but requires installation of latexmk into LyX
#	lyx -e pdfl writeups/$*.lyx
#Do we want to delete the tex files after compilation?
#.INTERMEDIATE: writeups/fake_article.tex
 