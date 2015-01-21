#Makefile rules for Version Control System (Subversion or git)

.PHONY: post_co fullupdate vcs_updatefrom_remote vcs_addcommitlast vcs_addlast vcs_commitlast_remote ALL

fullupdate : vcs_updatefrom_remote post_co

# Dont think I need this explicity if code has .dep files
#post_co : install_mods

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