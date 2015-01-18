export GENDEP_PROJDIR != dirname $$PWD
export PATH := $(shell pwd)/../resources/bin:$(PATH)
#export GENDEP_DEBUG := 1
#export GENDEP_DISABLE := 1
export GENDEP_MD5 := 1

#nice-ness. Uncomment a line to enable. Default is add 10
#export nice_prefix := nice
#export nice_prefix := nice -n10

DO_SCRIPTS := $(wildcard *.do)

#Technically the generation of a do file doesn't depend on inputs.
# So turn this command into one that does. This depends on all 
# independent do scripts making a log
DO_SCRIPTS_base := $(patsubst %.do,%,$(DO_SCRIPTS))
.PHONY : $(DO_SCRIPTS_base)
$(DO_SCRIPTS_base):
	$(MAKE) ../log/smcl/$@.smcl

# Allos a forcing of code to be run (might happen that dep files are out of date).
DO_SCRIPTS_force := $(patsubst %.do,%-force,$(DO_SCRIPTS))
.PHONY : $(DO_SCRIPTS_force)
$(DO_SCRIPTS_force) :
	st_launcher.sh $(patsubst %-force,%,$@)
	
#Make sure the mlib is up to date
matas_in_ado := $(wildcard ado/*.mata)
ado/l/lproject.mlib : $(matas_in_ado)
	statab.sh do cli_build_proj_mlib.do
	
DO_SCRIPTS_logs := $(patsubst %.do,../log/smcl/%.smcl,$(DO_SCRIPTS))
$(DO_SCRIPTS_logs) : ado/l/lproject.mlib

#Windows parallel gateway
# hould be handled by autodependency
# from $grep -r eval_synth . --include="*.do"
#DO_SCRIPTS_needing_pll := 
DO_TARGETS_needing_pll := $(patsubst %,../log/smcl/%.smcl,$(DO_SCRIPTS_needing_pll))
$(DO_TARGETS_needing_pll) : pll_gateway.sh
#Note you don't need the ; after the & (and it would produce an error).
pll_gateway.sh :
	if [ "$$OS" = "Windows_NT" ]; then \
		setup_win_gateway.sh 2>&1 | tail -100 > pll_gateway.log.extra & \
	else \
		echo "Gateway not needed on non-Windows platforms"; \
	fi
	
clean:
	mv *.log *.log.extra ../temp/lastrun
	
clean-dep:
	rm *.dep
	
dep-master:
	cat *.dep | grep -v "\t"
	
DEPS_SCRIPTS := $(wildcard .*.dep)
-include $(DEPS_SCRIPTS)
-include dep.ados
