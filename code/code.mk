#This is meant to have the PWD be in the project root.
#It is included from the base makefile
# The only manual part about the script is that if you want all-dos all-Rs all-Ms
# you will have to list as dependencies for those targets the stand-alone relevant scripts

#export GENDEP_DISABLE := 1
#export GENDEP_DEBUG := 1

#nice-ness. Uncomment a line to enable. Default is add 10
#export nice_prefix := nice
#export nice_prefix := nice -n10


### Do scripts ###
DO_SCRIPTS := $(wildcard code/*.do)

#Technically the generation of a do file doesn't depend on inputs.
# So turn this command into one that does. This depends on all 
# independent do scripts making a log
DO_SCRIPTS_base := $(patsubst code/%.do,%,$(DO_SCRIPTS))
.PHONY : $(DO_SCRIPTS_base)
$(DO_SCRIPTS_base):
	@echo Converting to make command for the associate log file.
	$(MAKE) log/do/$@.log

.PHONY : all-dos
all-dos : fake1 fake2
	
# Allows a forcing of code to be run (might happen that dep files are out of date).
DO_SCRIPTS_force := $(patsubst code/%.do,%-force,$(DO_SCRIPTS))
.PHONY : $(DO_SCRIPTS_force)
$(DO_SCRIPTS_force) :
	st_launcher.sh $(patsubst %-force,code/%,$@)
	

#Make sure the mlib is up to date
matas_in_ado := $(wildcard code/ado/*.mata)
$(DO_SCRIPTS) : code/ado/l/lproject.mlib
code/ado/l/lproject.mlib : $(matas_in_ado)
	statab.sh do code/cli_build_proj_mlib.do; \
	mv cli_build_proj_mlib.log temp/lastrun/
	
## Local install entries
pkgs_in_ado_store := $(wildcard code/ado-store/*/*.pkg)

code/ados.dep: $(pkgs_in_ado_store)
	gen-mod-install-rules.sh
	
.PHONY: install_mods
install_mods: code/ados.dep
	$(MAKE) all_modules

#Windows parallel gateway
# should be handled by autodependency
# from $grep -r eval_synth . --include="*.do"
#DO_SCRIPTS_needing_pll := 
DO_TARGETS_needing_pll := $(patsubst %,log/do/%.log,$(DO_SCRIPTS_needing_pll))
$(DO_TARGETS_needing_pll) : pll_gateway.sh
#Note you don't need the ; after the & (and it would produce an error).
pll_gateway.sh :
	if [ "$$OS" = "Windows_NT" ]; then \
		setup_win_gateway.sh 2>&1 | tail -100 > pll_gateway.log.extra & \
	else \
		echo "Gateway not needed on non-Windows platforms"; \
	fi

-include code/ados.dep

### R scripts ####
R_SCRIPTS := $(wildcard code/*.R)

R_SCRIPTS_base := $(patsubst code/%.R,%,$(R_SCRIPTS))
.PHONY : $(R_SCRIPTS_base)
$(R_SCRIPTS_base):
	@echo Converting to make command for the associate log file.
	$(MAKE) log/R/$@.log

.PHONY : all-Rs
all-Rs : fake3

R_SCRIPTS_force := $(patsubst code/%.R,%-force,$(R_SCRIPTS))
.PHONY : $(R_SCRIPTS_force)

$(R_SCRIPTS_force):
	R_launcher.sh $(patsubst %-force,code/%,$@)
	

### Matlab scripts ####
M_SCRIPTS := $(wildcard code/*.m)

M_SCRIPTS_base := $(patsubst code/%.m,%,$(M_SCRIPTS))
.PHONY : $(M_SCRIPTS_base)
$(M_SCRIPTS_base):
	@echo Converting to make command for the associate log file.
	$(MAKE) log/m/$@.log

.PHONY : all-Ms
all-ms : fake4

M_SCRIPTS_force := $(patsubst code/%.m,%-force,$(M_SCRIPTS))
.PHONY : $(M_SCRIPTS_force)

$(M_SCRIPTS_force):
	m_launcher.sh $(patsubst %-force,code/%,$@)

### Include ancilary rules ###
ifeq "$(GENDEP_DISABLE)" "1"
-include code/code-manual.dep
else
DEPS_SCRIPTS := $(wildcard code/.*.dep)
-include $(DEPS_SCRIPTS)
endif

.PHONY : all-code
all-code : all-dos all-Rs all-Ms