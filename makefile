# If you don't list all dependencies for code (because maybe it varies programmatically) then you can force a remake by doing 'make -B <target>. Note that it will remake all dependencies!

# Todo: Add target to remake all .md5 files.

############################# Project-specific Entries ####################

export PATH := $(shell pwd)/resources/bin:$(PATH)
#Sometimes it uses /bin/sh which has a problem with picking up the better path
SHELL := /bin/bash

# The figs that are too big in vector format and need to be rasterized
#pngs_of_big_figs : fig/png/GE_placebo_dropped_map.png fig/png/RI_effects_map.png


############################# Standard Entries ###########################

.PHONY: epss post_co install_mods clean fullupdate vcs_updatefrom_remote vcs_addcommitlast vcs_addlast vcs_commitlast_remote

### SVN entries
fullupdate : vcs_updatefrom_remote post_co

post_co : install_mods epss

vcs_updatefrom_remote:
	if [ -d ".svn" ]; then \
		svn update .; \
	fi
	if [ -d ".git" ]; then \
		git pull; \
	fi

vcs_addcommitlast: vcs_addlast vcs_commitlast_remote

vcs_addlast:
	if [ -d ".svn" ]; then \
		cd code; \
		cat ../temp/lastrun/files.txt | svn add --targets -; \
	fi
	if [ -d ".git" ]; then \
		cd code; \
		cat ../temp/lastrun/files.txt | xargs git add; \
	fi

vcs_commitlast_remote:
	if [ -d ".svn" ]; then \
		cd code; \
		cat ../temp/lastrun/files.txt | svn commit -m ""  --targets -; \
	fi
	if [ -d ".git" ]; then \
		git commit -m "std commit"; \
		git push ; \
	fi

	

### Local install entries
pkgs_in_ado_store := $(wildcard code/ado-store/*/*.pkg)

code/dep.ados: $(pkgs_in_ado_store)
	cd code && gen-makefile.sh

install_mods: code/dep.ados
	cd code && $(MAKE) all_modules

clean:
	-cd code; cleanup-incomplete-parallel.sh; 
	-cd code; cleanup-tests.sh;
	-rm -f temp/*
	cd code && $(MAKE) clean
	
#### Misc #####

hide_dot_files :
	if [ "$$OS" = "Windows_NT" ]; then \
		ATTRIB +H /s /d ".*" \
	else \
		echo "Only Windows needs Hidden attribute for dot files"; \
	fi


########### Graphs ##############
gph_files := $(wildcard fig/gph/*.gph)
gph_files_to_eps_base := $(patsubst fig/gph/%.gph,fig/eps/%.eps,$(gph_files))
gph_files_to_eps_base_nopath := $(patsubst fig/gph/%.gph,%.eps,$(gph_files))
gph_files_to_eps_notitle_nopath := $(patsubst fig/gph/%.gph,%_notitle.eps,$(gph_files))

.PHONY : remove_orphan_eps
epss : $(gph_files_to_eps_base)

fig/png/%.png fig/png/notitle/%_notitle.png : fig/gph/%.gph
	if [ "$$OS" = "Windows_NT" ]; then \
		cd code; \
		statab.sh do cli_gph_eps.do $* png; \
	else \
		echo "Only works on Windows"; \
	fi

#Should put in here the ghostscript or epstopdf solution (below) if can't rely on Windows
fig/pdf/%.pdf fig/pdf/notitle/%_notitle.pdf : fig/gph/%.gph
	if [ "$$OS" = "Windows_NT" ]; then \
		cd code; \
		statab.sh do cli_gph_eps.do $* pdf; \
	else \
		echo "Only works on Windows"; \
	fi

fig/eps/%.eps fig/eps/notitle/%_notitle.eps : fig/gph/%.gph
	cd code; statab.sh do cli_gph_eps.do $*

fig/svg/%.svg : fig/eps/%.eps
	inkscape -f fig/eps/$*.eps --export-plain-svg=fig/svg/$*.svg  

#the mv command below is big, so cd first to make it smaller. Should be more robust.
remove_orphan_eps : epss
	mkdir -p temp/eps; mkdir -p temp/eps/notitle; cd fig/eps && mv $(gph_files_to_eps_base_nopath) ../../temp/eps/ && cd notitle && mv $(gph_files_to_eps_notitle_nopath) ../../../temp/eps/notitle && cd .. && rm-non-svn.sh && mv ../../temp/eps/notitle/*.eps notitle/ && mv ../../temp/eps/*.eps && rm -rf ../../temp/eps/


########### Logs ##############
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
	tex2lyx tab/tex/$*.tex tab/lyx/$*.lyx

#the mv command below is big, so cd first to make it smaller. Should be more robust.
remove_orphan_table_formats : pdf_tables png_tables lyx_tables
	cd tab/pdf; mkdir -p temp/ && mv $(tex_table_files_to_pdf_nopath) temp/ && rm -f *.pdf && mv temp/*.pdf . && rmdir temp/
	cd tab/png; mkdir -p temp/ && mv $(tex_table_files_to_png_nopath) temp/ && rm -f *.png && mv temp/*.png . && rmdir temp/
	cd tab/lyx; mkdir -p temp/ && mv $(tex_table_files_to_lyx_nopath) temp/ && rm -f *.lyx && mv temp/*.lyx . && rmdir temp/

########### Writeups ##############
writeups/%.pdf : writeups/%.lyx
	cd writeups && lyx -e pdf2 $*.lyx
