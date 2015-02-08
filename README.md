# econ-project-template
This is a template to be used in an economics research project (it's geared towards Stata). It is designed to be highly automated and utilizes automatically dependency information between files.

## Usage
To use this template for your own project you can use the "Download ZIP" option. If you don't use git you can delete any .gitattributes or .gitignore. Even if you use git, the .gitignore files are often used as a dummy file so that a folder is under version control, so once you put other files in that folder you can delete the .gitignore file.

Once you have it setup, you just use 'make fake1' to ensure code/fake1.do is up to date (only runs if inputs or code are newer than outputs). This will track the dependencies (inputs & outputs) for fake1.do. If somehow the dependencies get messed up you should be able to always do 'make fake1-force' (and you can delete the dependency info stored in code/.fake1.dep if make is complaining about that). To make papers, just use 'make writeups/fake_article.pdf'. It should even go back and run code so that dependencies are up to date.

## Installation
Requirements:

1. PATH must include dep_tracker.sh (from either [gendep](https://github.com/bquistorff/gendep) or [wingendep](https://github.com/bquistorff/wingendep)).

1. STATABATCH assigned to the local batch stata command (e.g. "stata-se -b" or "StataSE-64.exe /e" with those in your path)

1. Ghostscript installed with GSEXE set to find it.

1. If you want to make SVGs: inkscape.

1. Python and Perl.

1. (optional) Latex with latexmk

1. Windows: Cygwin (with make, and maybe some other utilities).

### Using packages
This project is setup to load R/Stata packages from project-specific folders.

Stata repositories don't track versions of packages, so not only should the package files be in the project, they should also be under version control. To install a new package that is platform independent, just run setup_ado.do, then install normally (then add to VC). To install a package that is platform dependent do `cd code/ado-store` and then use `store-mod-install-files.sh` (instructions at top of file).

For R packages, repositories (e.g. CRAN) keep old histories so you can have the packages in the project folder but not under version control (because many are non platform-independent). See Rlib-management.R. If you have packages that aren't from a repository that stores version history then you should setup your own local CRAN (see the miniCRAN package) which would be under version control.

# Tracking file changes
Often you want to know whether a file has really changed. File modification timestamps howver just record the last time something was written to the file even it was the same content or insignificantly different. If you know when a file has actually changed you can monitor your workflow for errors and avoid costly down-stream estimation. Assuming we can get rid of harmless differences to get "normalized" versions of files (see below) then we can track content changes using hashes like md5. Version control systems implicitly have this built in, however I augment this setup with manual hashes for the 'make' build system. 

The 'make' build-system works strictly off of file modification timestamps. We can mould 'make' to our needs by creating md5 sentinel files to accompany intermediate files (data and text for estimation; text, tables, and PDFs for writeups). Then we simply re-write make dependency rules so that required files become the md5 sentinels which are then only updated when real content changes. While this idea has been noted before [1](http://blog.jgc.org/2006/04/rebuilding-when-hash-has-changed-not.html) [2](http://stackoverflow.com/questions/8821319/make-only-build-something-if-the-sources-md5-checksum-was-changed) [3] (http://lists.gnu.org/archive/html/bug-make/2009-09/msg00015.html) [4](http://www.kolpackov.net/pipermail/notes/2004-September/000011.html) [5](http://www.cmcrossroads.com/article/rebuilding-when-files-checksum-changes) my solution deals well with intermediate files (suppose code1->intermediate->code2, so we have a modified rule that code2 depends on intermediate.md5 and when check if intermediate.md5 is up-to-date we relaunch make to check if intermediate needs to be updated from code1 and if so re-make intermediate.md5 in the process).

All direct outputs of estimation are md5 tracked. This behaviour is controlled by GENDEP_MD5.

# Makefile dependency generation
I use gendep/wingendep based for the generation of makefile rules for the code and for LaTeX I use latexmk since LaTeX dependencies in process might be circular. They create .file.dep files with makefile rules that are hidden. This is controlled by GENDEP_DISABLE. Then a requirement points to a folder that contains direct estimation output this is converted to the md5 sentinel file.

# Last-run tracking
Sometimes you just want to do something with the last run (e.g. maybe you don't want to commit all changes just from the last estimation). If you are running interactively then you can't just get the list of outputs from the code.dep file. Therefore in Stata and R I have file output saving wrapping functions that track the files outputted by the last and save the results to temp/lastrun/

# File normalization #
Ideally output files would be the same on different platforms, but this is not always possible. Here are some caveats:

-Logs. The contents of log/smcl/ and log/Rout are platform dependent. "Normalized" versions of their content are in the base of log/. The latter files are kept in version control while the former are not.

-Stata: outputs in data/*.dta and fig/gph/* are normalized in-place to be platform independent. They can be under VC if you would like (you might not want to if the data are big and constantly changing). (I don't know how to normalize Stata eps, and stata can't produce PDF on all platforms).
-R: outputs in data/*.RData and fig/eps/* are platform independent. They can be under VC if you would like (you might not want to if the data are big and constantly changing). (I don't know how to make the PDFs platform independent).

-It's helpful to have writeups/*.pdf under VC (as it saves time checking the history). To do this all the writeups/*.pdf and fig/pdf/*.pdf are normalized in-place to be consistent for a platform (they don't change with time).

-To do: PNG and SVG normalization