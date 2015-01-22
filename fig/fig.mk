#This is meant to have the PWD be in the project root.
#It is included from the base makefile

# The figs that are too big in vector format and need to be rasterized
#pngs_of_big_figs : fig/png/GE_placebo_dropped_map.png fig/png/RI_effects_map.png

gph_files := $(wildcard fig/gph/*.gph)
gph_files_to_eps_base := $(patsubst fig/gph/%.gph,fig/eps/%.eps,$(gph_files))
gph_files_to_eps_base_nopath := $(patsubst fig/gph/%.gph,%.eps,$(gph_files))
gph_files_to_eps_notitle_nopath := $(patsubst fig/gph/%.gph,%_notitle.eps,$(gph_files))

.PHONY : remove_orphan_eps epss
epss : $(gph_files_to_eps_base)

fig/eps/%.eps fig/eps/notitle/%_notitle.eps : fig/gph/%.gph
	statab.sh do code/cli_gph_eps.do $*; \
	mv cli_gph_eps.log temp/lastrun;
	
fig/pdf/%.pdf : fig/eps/%.eps
	epstopdf --outfile=fig/pdf/$*.pdf fig/eps/$*.eps

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

#the mv command below is big, so cd first to make it smaller. Should be more robust.
remove_orphan_eps : epss
	mkdir -p temp/eps; mkdir -p temp/eps/notitle; cd fig/eps && mv $(gph_files_to_eps_base_nopath) ../../temp/eps/ && cd notitle && mv $(gph_files_to_eps_notitle_nopath) ../../../temp/eps/notitle && cd .. && rm-non-svn.sh && mv ../../temp/eps/notitle/*.eps notitle/ && mv ../../temp/eps/*.eps && rm -rf ../../temp/eps/

