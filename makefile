# If you don't list all dependencies for code (because maybe it varies programmatically) then you can force a remake by doing 'make -B <target>. Note that it will remake all dependencies!

#nice-ness. Uncomment a line to enable. Default is +10
#nice_prefix := nice
#nice_prefix := nice -n10

############################# Project-specific Entries ####################

# which entries use parallel and need a windows gateway	
# from $grep -r eval_synth . --include="*.do"
#analysis_gdp_indep analysis_pa_workers_indep analysis_pop analysis_germany analysis_populstat analysis_state_exp : code/pll_gateway.sh

# which do files depend on each other
#GE_ge2med_map analysis_weighted_p_value analysis_misc : analysis_pop

# The figs that are too big in vector format and need to be rasterized
#pngs_of_big_figs : fig/png/GE_placebo_dropped_map.png fig/png/RI_effects_map.png


############################# Standard Entries ###########################

.PHONY: epss post_co install_mods clean fullupdate svnupdate svnaddcommitlast svnaddlast svncommitlast

### SVN entries
fullupdate : svnupdate post_co

post_co : install_mods epss

svnupdate:
	svn update .
	
svnaddcommitlast: svnaddlast svncommitlast

svnaddlast:
	cd code; cat ../temp/lastrun/files.txt | svn add --targets -

svncommitlast:
	cd code; cat ../temp/lastrun/files.txt | svn commit -m ""  --targets -

### Local install entries
pkgs_in_ado_store := $(wildcard code/ado-store/*/*.pkg)

code/makefile: $(pkgs_in_ado_store)
	cd code && gen-makefile.sh

install_mods: code/makefile
	cd code && $(MAKE)

#Note you don't need the ; after the & (and it would produce an error).
code/pll_gateway.sh :
	if [ "$$OS" = "Windows_NT" ]; then cd code; setup_win_gateway.sh 2>&1 | tail -100 > pll_gateway.log.extra & else echo "Gateway not needed on non-Windows platforms"; fi

clean:
	-cd code; cleanup-incomplete-parallel.sh; 
	-cd code; cleanup-tests.sh;
	-rm -f temp/*
	-mv code/*.log code/*.log.extra temp/lastrun/

matas_in_ado := $(wildcard code/ado/*.mata)
code/ado/l/lproject.mlib : $(matas_in_ado)
	cd code; statab.sh do cli_build_proj_mlib.do

########### Stata scripts
do_files := $(wildcard code/*.do)
dos := $(patsubst code/%.do,%,$(do_files))
#do_files_to_log_base := $(patsubst code/%.do,log/%.log,$(do_files))
do_files_to_smcl := $(patsubst code/%.do,log/smcl/%.smcl,$(do_files))

#The below was working on Linux but not Cygwin so switched to blanket secondary
#.INTERMEDIATE : $(do_files_to_smcl)
.SECONDARY:

log/smcl/%.smcl : code/%.do
	cd code; $(nice_prefix) statab.sh do $*.do && cp ../temp/lastrun/$*-files.txt ../temp/lastrun/files.txt
	cd code; cat ../temp/lastrun/files.txt | grep \.gph | while read p; do python ../resources/normalize_gph.py $$p; done
	cd code; cat ../temp/lastrun/files.txt | grep \.dta | while read p; do python ../resources/normalize_dta.py $$p; done

.PHONY : all_stata $(dos)

$(dos) : % : log/%.log
$(dos) : code/ado/l/lproject.mlib

#all_stata: $(dos)

########### Graphs ##############
gph_files := $(wildcard fig/gph/*.gph)
gph_files_to_eps_base := $(patsubst fig/gph/%.gph,fig/eps/%.eps,$(gph_files))
gph_files_to_eps_base_nopath := $(patsubst fig/gph/%.gph,%.eps,$(gph_files))
gph_files_to_eps_notitle_nopath := $(patsubst fig/gph/%.gph,%_notitle.eps,$(gph_files))

.PHONY : remove_orphan_eps
epss : $(gph_files_to_eps_base)

fig/png/%.png fig/png/notitle/%_notitle.png : fig/gph/%.gph
	if [ "$$OS" = "Windows_NT" ]; then cd code; statab.sh do cli_gph_eps.do $* png; else echo "Only works on Windows"; fi

#Should put in here the ghostscript solution (below) if can't rely on Windows
fig/pdf/%.pdf fig/pdf/notitle/%_notitle.pdf : fig/gph/%.gph
	if [ "$$OS" = "Windows_NT" ]; then cd code; statab.sh do cli_gph_eps.do $* pdf; else echo "Only works on Windows"; fi

fig/eps/%.eps fig/eps/notitle/%_notitle.eps : fig/gph/%.gph
	cd code; statab.sh do cli_gph_eps.do $*

fig/svg/%.eps : fig/eps/%.eps
	inkscape -f fig/eps/$*.eps --export-plain-svg=fig/svg/$*.eps  

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

########### Logs ##############
smcl_files := $(wildcard log/smcl/*.smcl)
smcl_files_to_log := $(patsubst log/smcl/%.smcl,log/raw/%.log,$(smcl_files))

log/%.log : log/smcl/%.smcl
	cd code; statab.sh do cli_smcl_log.do $*
	cd code; normalize_log.sh -r .. -b ../log/raw/ ../log/$*.log
	cd code; sed -e 's:\.smcl:\.log:g' -e 's:smcl/::g' -i ../temp/lastrun/files.txt

########### Writeups ##############
writeups/%.pdf : writeups/%.lyx
	cd writeups && lyx -e pdf2 $*.lyx
