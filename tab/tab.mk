#This is meant to have the PWD be in the project root.
#It is included from the base makefile

# Can make PDFs (vector format but can't be displayed in MS Office), PNGs (raster format so displayable everywhere), and LyXs (editable text) of tex tables.

# Less useful formats and how to make them
# Make EPS (vector format but use only only if printing as MS Office can't display well inline)
# pdftops -eps mytable.pdf mytable.eps
# Make EMF (vector format but does font substitution so looks weird)
# pstoedit -f emf mytable.pdf mytable.emf

tex_table_files := $(wildcard tab/tex/*.tex)
tex_table_files_to_pdf := $(patsubst tab/tex/%.tex,tab/pdf/%.pdf,$(tex_table_files))
tex_table_files_to_pdf_nopath := $(patsubst tab/tex/%.tex,%.pdf,$(tex_table_files))
tex_table_files_to_png := $(patsubst tab/tex/%.tex,tab/png/%.png,$(tex_table_files))
tex_table_files_to_png_nopath := $(patsubst tab/tex/%.tex,%.png,$(tex_table_files))
tex_table_files_to_lyx := $(patsubst tab/tex/%.tex,tab/lyx/%.lyx,$(tex_table_files))
tex_table_files_to_lyx_nopath := $(patsubst tab/tex/%.tex,%.lyx,$(tex_table_files))

.PHONY: pdf_tables png_tables lyx_tables remove_orphan_table_formats

pdf_tables : $(tex_table_files_to_pdf)
png_tables : $(tex_table_files_to_png)
lyx_tables : $(tex_table_files_to_lyx)

tab/pdf/%.pdf : tab/tex/%.tex
	mkdir -p temp/topdf; (echo \\documentclass[varwidth=true, border=10pt]{standalone} && echo \\begin{document} && cat tab/tex/$*.tex && echo \\end{document} ) > temp/topdf/$*.tex && pdflatex temp/topdf/$*.tex --output-directory=tab/pdf --aux-directory=temp/topdf/ && rm -rf temp/topdf

tab/png/%.png : tab/pdf/%.pdf	
	$(GSEXE) -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pnggray -r600 -sOutputFile=tab/png/$*.png tab/pdf/$*.pdf

tab/lyx/%.lyx : tab/tex/%.tex
	conv_tex_table_to_lyx.sh tab/tex/$*.tex tab/lyx/$*.lyx

#the mv command below is big, so cd first to make it smaller. Should be more robust.
remove_orphan_table_formats : pdf_tables png_tables lyx_tables
	cd tab/pdf; mkdir -p temp/ && mv $(tex_table_files_to_pdf_nopath) temp/ && rm -f *.pdf && mv temp/*.pdf . && rmdir temp/
	cd tab/png; mkdir -p temp/ && mv $(tex_table_files_to_png_nopath) temp/ && rm -f *.png && mv temp/*.png . && rmdir temp/
	cd tab/lyx; mkdir -p temp/ && mv $(tex_table_files_to_lyx_nopath) temp/ && rm -f *.lyx && mv temp/*.lyx . && rmdir temp/