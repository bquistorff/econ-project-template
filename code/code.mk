#This is meant to have the PWD be in the project root.
#It is included from the base makefile

#export GENDEP_DISABLE := 1
#export GENDEP_DEBUG := 1
export GENDEP_MD5 := 1
#export GENDEP_PROJDIR := $(CURDIR)

#nice-ness. Uncomment a line to enable. Default is add 10
#export nice_prefix := nice
#export nice_prefix := nice -n10

DO_SCRIPTS := $(wildcard code/*.do)

#Technically the generation of a do file doesn't depend on inputs.
# So turn this command into one that does. This depends on all 
# independent do scripts making a log
DO_SCRIPTS_base := $(patsubst code/%.do,%,$(DO_SCRIPTS))
.PHONY : $(DO_SCRIPTS_base)
$(DO_SCRIPTS_base):
	@echo Converting to make command for the associate log file.
	$(MAKE) log/smcl/$@.smcl

.PHONY : all-dos
all-dos : $(DO_SCRIPTS_base)
	
# Allows a forcing of code to be run (might happen that dep files are out of date).
DO_SCRIPTS_force := $(patsubst code/%.do,%-force,$(DO_SCRIPTS))
.PHONY : $(DO_SCRIPTS_force)
$(DO_SCRIPTS_force) :
	st_launcher.sh $(patsubst %-force,code/%,$@)
	
FORCE:
%.md5 : FORCE
	$(MAKE) $(dir $*)$(patsubst .%,%,$(notdir $*))

#Make sure the mlib is up to date
matas_in_ado := $(wildcard code/ado/*.mata)
$(DO_SCRIPTS) : code/ado/l/lproject.mlib
code/ado/l/lproject.mlib : $(matas_in_ado)
	statab.sh do code/cli_build_proj_mlib.do; \
	mv cli_build_proj_mlib.log temp/lastrun/
	
### Local install entries
pkgs_in_ado_store := $(wildcard code/ado-store/*/*.pkg)

code/dep.ados: $(pkgs_in_ado_store)
	gen-mod-install-rules.sh
	
.PHONY: install_mods
install_mods: code/dep.ados
	$(MAKE) all_modules

#Windows parallel gateway
# hould be handled by autodependency
# from $grep -r eval_synth . --include="*.do"
#DO_SCRIPTS_needing_pll := 
DO_TARGETS_needing_pll := $(patsubst %,log/smcl/%.smcl,$(DO_SCRIPTS_needing_pll))
$(DO_TARGETS_needing_pll) : pll_gateway.sh
#Note you don't need the ; after the & (and it would produce an error).
pll_gateway.sh :
	if [ "$$OS" = "Windows_NT" ]; then \
		setup_win_gateway.sh 2>&1 | tail -100 > pll_gateway.log.extra & \
	else \
		echo "Gateway not needed on non-Windows platforms"; \
	fi


### R scripts ####
R_SCRIPTS := $(wildcard code/*.R)
R_SCRIPTS_base := $(patsubst code/%.R,%,$(R_SCRIPTS))
.PHONY : $(R_SCRIPTS_base)

#Eventually wrap with dependency generation
$(R_SCRIPTS_base):
	GENDEP_DISABLE=1 R_launcher.sh code/$@

### Include ancilary rules ###
DEPS_SCRIPTS := $(wildcard code/.*.dep)
-include $(DEPS_SCRIPTS)

-include code/dep.ados