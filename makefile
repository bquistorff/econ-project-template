# If you don't list all dependencies for code (because maybe it varies programmatically) then you can force a remake by doing 'make -B <target>. Note that it will remake all dependencies!

export PATH := $(CURDIR)/resources/bin:$(PATH)
#Sometimes it uses /bin/sh which has a problem with picking up the better path
SHELL := /bin/bash

export GENDEP_MD5 := 1

#Disable the built-in implicit rules inside of makefile
.SUFFIXES:

.PHONY: ALL clean clean-dist dep-master hide_dot_files missing-md5 update-md5 remove-orphan-deps-md5 status-check status-check-last

ALL : 
	@echo Some analyses make take days, so you might not want to do -make all-.
	@echo If you really want to, do -make all-code-. 
	@echo More likely you want to give the basename of a script in code/, like
	@echo -make fake1- which will make sure running code/fake1.do is up to date.


clean:
	-cleanup-incomplete-parallel.sh; 
	-cleanup-tests.sh;
	-rm -f temp/* temp/lastrun/*
	-cd writeups && latexmk -CA
	
clean-dist:
	-rm code/.*.dep
	-rm writeups/*.d writeups/.*.dep
	
missing-md5:
	for file in $$(find data fig/gph tab snippets -type f \! -name *.gitignore \! -name *.md5 | grep -v .mk); do \
	  if ! [ -e "$$(dirname $$file)/.$(basename $$file).md5" ]; then \
	    update_md5.sh $$file; \
	  fi \
	done

update-md5:
	for file in $$(find data fig/gph tab snippets -type f \! -name *.gitignore \! -name *.md5 | grep -v .mk); do \
	  update_md5.sh $$file; \
	done
	
remove-orphan-deps-md5:
	remove_orphan_dotfiles.sh

#check what files have changed (versioned or md5ed)
#The final echo on the last line is so there is no error when the preceding has no output
status-check:
	@echo ..... VC check ......
	@if [ -d ".svn" ]; then \
		svn status; \
	fi
	@if [ -d ".git" ]; then \
		git status -s --untracked-files=no; \
	fi
	#All the other md5s should be intermediate files
	#@echo ...... md5 check ......
	#@ $(find . -name '*.md5' | xargs cat | md5sum -c | grep -v ": OK"; echo "")
	
status-check-last:
	@echo ..... VC check ......
	@if [ -d ".svn" ]; then \
		last_status.sh | xargs svn status; \
	fi
	#use " -uno" after git status to just show the versioned ones
	@if [ -d ".git" ]; then \
		last_status.sh | xargs git status -s; \
	fi
	
	
#Shows input-outputs of the code files.
dep-master:
	#removes logs (never intermediate files). Undoes the md5 conversion.
	#To do: Would be nice to remove the own_code from the Inputs side.
	@echo Outputs : Inputs
	@cat code/.*.dep | grep -v "launcher.sh" | sed -e 's:log/[^ ]\+ ::g' -e "s:\([^ ]\+\)/\.\([^ ]\+\)\.md5:\1/\2:g"

hide_dot_files :
	if [ "$$OS" = "Windows_NT" ]; then \
		ATTRIB +H /s /d ".*" \
	else \
		echo "Only Windows needs Hidden attribute for dot files"; \
	fi

FORCE:
%.md5 : FORCE
	$(MAKE) $(dir $*)$(patsubst .%,%,$(notdir $*))

############## Separate rules files ####################
# Should be able to have all makefiles together to make knows everything
#  (see the Evils of Recursive Make article).
include vcs.mk
include code/code.mk
include fig/fig.mk
include tab/tab.mk
include writeups/writeups.mk
