#This is meant to have the PWD be in the project root.
#It is included from the base makefile

# The figs that are too big in vector format and need to be rasterized
#pngs_of_big_figs : fig/png/GE_placebo_dropped_map.png fig/png/RI_effects_map.png

# Stata file lists
#not all platforms can use stata to make pdf from gph. So use intermediate eps
gphs := $(wildcard fig/gph/*.gph)
gphs_to_eps_base := $(patsubst fig/gph/%.gph,fig/eps/%.eps,$(gphs))
gphs_to_eps_notitle := $(patsubst fig/gph/%.gph,fig/eps/notitle/%_notitle.eps,$(gphs))
gphs_to_pdfs_base := $(patsubst fig/gph/%.gph,fig/pdf/%.pdf,$(gphs))
gphs_to_pdfs_notitle := $(patsubst fig/gph/%.gph,fig/pdf/notitle/%_notitle.pdf,$(gphs))
.INTERMEDIATE : $(gphs_to_eps_base) $(gphs_to_eps_notitle)

ifeq "$(GENDEP_MD5)" "1"
$(gphs_to_eps_base) : fig/eps/%.eps : fig/gph/.%.gph.md5
else
$(gphs_to_eps_base) : fig/eps/%.eps : fig/gph/%.gph
endif
	statab.sh do code/cli_gph_eps.do $* eps title; \
	  mv cli_gph_eps.log temp/lastrun;

ifeq "$(GENDEP_MD5)" "1"
$(gphs_to_eps_notitle) : fig/eps/notitle/%_notitle.eps : fig/gph/.%.gph.md5
else
$(gphs_to_eps_notitle) : fig/eps/notitle/%_notitle.eps : fig/gph/%.gph
endif
	statab.sh do code/cli_gph_eps.do $* eps notitle; \
	  mv cli_gph_eps.log temp/lastrun;
	
$(gphs_to_pdfs_base) $(gphs_to_pdfs_notitle) : fig/pdf/%.pdf : fig/eps/%.eps
	epstopdf --outfile=fig/pdf/$*.pdf fig/eps/$*.eps;
	normalize_pdf.sh fig/pdf/$*.pdf

fig/png/%.png : fig/pdf/%.pdf	
	$(GSEXE) -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pnggray -r600 -sOutputFile=fig/png/$*.png fig/pdf/$*.pdf

fig/svg/%.svg : fig/pdf/%.pdf
	inkscape --without-gui -f fig/pdf/$*.pdf --export-plain-svg=fig/svg/$*.svg  

.PHONY : pdfs_of_gphs pdfs_of_epss all_pdfs remove_orphan_pdfs
pdfs_of_gphs : $(gphs_to_pdfs_base) $(gphs_to_pdfs_notitle)

## Now the R-generation ones
epss_base := $(wildcard fig/eps/*.eps)
epss_to_pdfs_base := $(patsubst fig/eps/%.eps,fig/pdf/%.pdf,$(epss_base))
epss_notitle := $(wildcard fig/eps/notitle/*.eps)
epss_to_pdfs_notitle := $(patsubst fig/eps/notitle/%.eps,fig/pdf/notitle/%.pdf,$(epss_notitle))
pdfs_of_epss : $(epss_to_pdfs_base) $(epss_to_pdfs_notitle)

all_pdfs : pdfs_of_gphs pdfs_of_epss

ifeq "$(GENDEP_MD5)" "1"
$(epss_to_pdfs_base) : fig/pdf/%.pdf : fig/eps/.%.eps.md5
else
$(epss_to_pdfs_base) : fig/pdf/%.pdf : fig/eps/%.eps
endif
	epstopdf --outfile=fig/pdf/$*.pdf fig/eps/$*.eps;
	normalize_pdf.sh fig/pdf/$*.pdf

ifeq "$(GENDEP_MD5)" "1"
$(epss_to_pdfs_notitle) : fig/pdf/notitle/%_notitle.pdf : fig/eps/notitle/.%_notitle.eps.md5
else
$(epss_to_pdfs_notitle) : fig/pdf/notitle/%_notitle.pdf : fig/eps/notitle/%_notitle.eps
endif
	epstopdf --outfile=fig/pdf/notitle/$*_notitle.pdf fig/eps/notitle/$*_notitle.eps;
	normalize_pdf.sh fig/pdf/notitle/$*_notitle.pdf

## Removal of orphaned PDFs (could do the other formats if need be).
gphs_to_pdfs_base_nopath := $(patsubst fig/gph/%.gph,%.pdf,$(gphs))
gphs_to_pdfs_notitle_nopath := $(patsubst fig/gph/%.gph,%_notitle.pdf,$(gphs))
epss_to_pdfs_base_nopath := $(patsubst fig/eps/%.eps,%.pdf,$(epss_base))
epss_to_pdfs_notitle_nopath := $(patsubst fig/eps/%.eps,%_notitle.pdf,$(epss_base))

#mv out the accompanied ones, then remove non-versioned.
#the mv command below is big, so cd first to make it smaller. Should be more robust.
remove_orphan_pdfs : all_pdfs
	mkdir -p temp/pdf; \
	  mkdir -p temp/pdf/notitle; \
	  cd fig/pdf && mv $(gphs_to_pdfs_base_nopath) $(epss_to_pdfs_base_nopath) ../../temp/pdf/ && \
	  cd notitle && mv $(gphs_to_pdfs_notitle_nopath) $(epss_to_pdfs_notitle_nopath) ../../../temp/pdf/notitle && \
	  cd .. && rm-non-vcs.sh && \
	  mv ../../temp/pdf/notitle/*.pdf notitle/ && \
	  cd .. && mv ../temp/pdf/*.pdf pdf/ && \
	  rm -rf ../temp/pdf/


