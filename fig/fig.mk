#This is meant to have the PWD be in the project root.
#It is included from the base makefile

# The figs that are too big in vector format and need to be rasterized
#pngs_of_big_figs : fig/png/GE_placebo_dropped_map.png fig/png/RI_effects_map.png

#not all platforms can use stata to make pdf from gph. So use intermediate eps
gphs := $(wildcard fig/gph/*.gph)
gphs_to_eps_base := $(patsubst fig/gph/%.gph,fig/eps/%.eps,$(gphs))
gphs_to_eps_notitle := $(patsubst fig/gph/%.gph,fig/eps/notitle/%_notitle.eps,$(gphs))
.INTERMEDIATE : $(gphs_to_eps_base) $(gphs_to_eps_notitle)

fig/eps/%.eps fig/eps/notitle/%_notitle.eps : fig/gph/%.gph
	statab.sh do code/cli_gph_eps.do $*; \
	mv cli_gph_eps.log temp/lastrun;
	
fig/pdf/%.pdf : fig/eps/%.eps
	epstopdf --outfile=fig/pdf/$*.pdf fig/eps/$*.eps && \
	  normalize_pdf.sh fig/pdf/$*.pdf && \
	  update_md5.sh fig/pdf/$*.pdf

#fig/png/%.png fig/png/notitle/%_notitle.png : fig/gph/%.gph
#	if [ "$$OS" = "Windows_NT" ]; then \
#		statab.sh do code/cli_gph_eps.do $* png; \
#		mv cli_gph_eps.log temp/lastrun; \
#	else \
#		echo "Only works on Windows"; \
#	fi
fig/png/%.png : fig/pdf/%.pdf	
	$(GSEXE) -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pnggray -r600 -sOutputFile=fig/png/$*.png fig/pdf/$*.pdf

fig/svg/%.svg : fig/eps/%.eps
	inkscape -f fig/eps/$*.eps --export-plain-svg=fig/svg/$*.svg  

.PHONY : pdfs_of_gphs pdfs_of_epss remove_orphan_pdfs
gphs_to_pdfs_base := $(patsubst fig/gph/%.gph,fig/pdf/%.pdf,$(gphs))
gphs_to_pdfs_notitle := $(patsubst fig/gph/%.gph,fig/pdf/notitle/%_notitle.pdf,$(gphs))
pdfs_of_gphs : $(gphs_to_pdfs_base) $(gphs_to_pdfs_notitle)

epss_base := $(wildcard fig/eps/*.eps)
epss_to_pdfs_base := $(patsubst fig/eps/%.eps,fig/pdf/%.pdf,$(epss_base))
epss_notitle := $(wildcard fig/eps/notitle/*.eps)
epss_to_pdfs_notitle := $(patsubst fig/eps/notitle/%.eps,fig/pdf/notitle/%.pdf,$(epss_notitle))
pdfs_of_epss : $(epss_to_pdfs_base) $(epss_to_pdfs_notitle)

gphs_to_pdfs_base_nopath := $(patsubst fig/gph/%.gph,%.pdf,$(gphs))
gphs_to_pdfs_notitle_nopath := $(patsubst fig/gph/%.gph,%_notitle.pdf,$(gphs))
epss_to_pdfs_base_nopath := $(patsubst fig/eps/%.eps,%.pdf,$(epss_base))
epss_to_pdfs_notitle_nopath := $(patsubst fig/eps/%.eps,%_notitle.pdf,$(epss_base))

#mv out the accompanied ones, then remove non-versioned.
#the mv command below is big, so cd first to make it smaller. Should be more robust.
remove_orphan_pdfs : pdfs_of_gphs pdfs_of_epss
	mkdir -p temp/pdf; \
	  mkdir -p temp/pdf/notitle; \
	  cd fig/pdf && mv $(gphs_to_pdfs_base_nopath) $(epss_to_pdfs_base_nopath) ../../temp/pdf/ && \
	  cd notitle && mv $(gphs_to_pdfs_notitle_nopath) $(epss_to_pdfs_notitle_nopath) ../../../temp/pdf/notitle && \
	  cd .. && rm-non-vcs.sh && \
	  mv ../../temp/pdf/notitle/*.pdf notitle/ && \
	  cd .. && mv ../temp/pdf/*.pdf pdf/ && \
	  rm -rf ../temp/pdf/


