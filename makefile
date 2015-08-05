# If you don't list all dependencies for code (because maybe it varies programmatically) then you can force a remake by doing 'make -B <target>. Note that it will remake all dependencies!

export PATH := $(CURDIR)/resources/bin:$(PATH)
#Sometimes it uses /bin/sh which has a problem with picking up the better path
SHELL := /bin/bash

#Disable the built-in implicit rules inside of makefile
.SUFFIXES:

.PHONY: ALL clean clean-dist dep-master dep-graph status-check status-check-last

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
	-rm resources/deps/*.dep
	-rm writeups/*.d writeups/*.dep

#check what files have changed
#The final echo on the last line is so there is no error when the preceding has no output
status-check:
	@echo ..... VC check ......
	@if [ -d ".svn" ]; then \
		svn status; \
	fi
	@if [ -d ".git" ]; then \
		git status -s --untracked-files=no; \
	fi
	
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
#currently using github.com/lindenb/makefile2dot
#Other options: github.com/lindenb/makefile2graph, metacpan.org/pod/Makefile::GraphViz, metacpan.org/pod/GraphViz::Makefile
dep-master:
	#removes logs (never intermediate files).
	#To do: Would be nice to remove the own_code from the Inputs side.
	@echo Outputs : Inputs
	@cat resources/deps/*.dep | grep -v "launcher.sh" | sed -e 's:log/[^ ]\+ ::g'

#If you are on cygwin you will need graphviz (and I think fontconfig and a vector font like the Vera ones)
dep-graph:
	cat resources/deps/*.dep | grep "^# " | sed -e "s/# //g" | sed -e "s/ code\\/\\(ado\\|m\\|Rlib\\)[^ ]\\+//g" -e "s/^log[^ ]\\+ //g" > temp/dep_graph.mk
	python resources/bin/makefile2dot.py < temp/dep_graph.mk |dot -Tpdf > temp/dep_graph.pdf

FORCE:

############## Separate rules files ####################
# Should be able to have all makefiles together to make knows everything
#  (see the Evils of Recursive Make article).
include vcs.mk
include code/code.mk
include fig/fig.mk
include tab/tab.mk
include writeups/writeups.mk
