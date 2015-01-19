# If you don't list all dependencies for code (because maybe it varies programmatically) then you can force a remake by doing 'make -B <target>. Note that it will remake all dependencies!

# Todo: Add target to remake all .md5 files.

export PATH := $(CURDIR)/resources/bin:$(PATH)
#Sometimes it uses /bin/sh which has a problem with picking up the better path
SHELL := /bin/bash


############################# Version Control ###########################
.PHONY: post_co fullupdate vcs_updatefrom_remote vcs_addcommitlast vcs_addlast vcs_commitlast_remote

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
		cat temp/lastrun/files.txt | svn add --targets -; \
	fi
	if [ -d ".git" ]; then \
		cat temp/lastrun/files.txt | xargs git add; \
	fi

vcs_commitlast_remote:
	if [ -d ".svn" ]; then \
		cat temp/lastrun/files.txt | svn commit -m ""  --targets -; \
	fi
	if [ -d ".git" ]; then \
		git commit -m "std commit"; \
		git push ; \
	fi


#### Misc #####
.PHONY: clean clean-dist dep-master hide_dot_files
clean:
	-cleanup-incomplete-parallel.sh; 
	-cleanup-tests.sh;
	-rm -f temp/*
	-cd writeups && latexmk -CA
	
clean-dist:
	rm code/*.dep
	
dep-master:
	cat code/*.dep | grep -v "\t"

hide_dot_files :
	if [ "$$OS" = "Windows_NT" ]; then \
		ATTRIB +H /s /d ".*" \
	else \
		echo "Only Windows needs Hidden attribute for dot files"; \
	fi

############## Subdirectory files ####################
include code/code.mk
include fig/fig.mk
include tab/tab.mk
include writeups/writeups.mk
