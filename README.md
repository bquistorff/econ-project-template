# econ-project-template
This is a template to be used in an economics research project (it's geared towards Stata). It is designed to be highly automated and utilizes automatically dependency information between files.

## Usage
To use this template for your own project you can use the "Download ZIP" option. If you don't use git you can delete any .gitattributes or .gitignore. Even if you use git, the .gitignore files are often used as a dummy file so that a folder is under version control, so once you put other files in that folder you can delete the .gitignore file.

Once you have it setup, you just use 'make fake1' to ensure code/fake1.do is up to date (only runs if inputs or code are newer than outputs). This will track the dependencies (inputs & outputs) for fake1.do. To make papers, just use 'make writeups/fake_article.pdf'. It should even go back and run code so that dependencies are up to date.

## Installation
Requirements:

1. PATH must include dep_tracker.sh (from either [gendep](https://github.com/bquistorff/gendep) or [wingendep](https://github.com/bquistorff/wingendep)).

1. SCons

1. STATABATCH assigned to the local batch stata command (e.g. "stata-se -b" or "StataSE-64.exe /e" with those in your path)

1. Ghostscript installed with GSEXE set to find it.

1. If you want to make SVGs: inkscape.

1. Python and Perl.

1. (optional) Latex with latexmk

1. Windows: Cygwin (with make, and maybe some other utilities).

### Using packages
This project is setup to load R/Stata packages from project-specific folders.

Stata repositories don't track versions of packages, so not only should the package files be in the project, they should also be under version control. To install a new package that is platform independent, inside Stata run setup_ado.do and then install normally from inside. Then run `normalize_trks.sh code/ado/stata.trk` and add the new files to VC. To install a package that is platform dependent do `cd code/ado-store` and then use `store-mod-install-files.sh` (instructions at top of file). You may also want to install net_install from [here](https://github.com/bquistorff/Stata-modules)

For R packages, repositories I use packrat. If you are on Windows+Cygwin and don't want RTools normally in your path, then before installing new packages that need compilation you will have to add 'c:\Rtools\bin;C:\Rtools\gcc-4.6.3\bin;' to your path before starting R/Studio that will do the installation.

# Tracking file changes
Often you want to know whether a file has really changed. File modification timestamps however just record the last time something was written to the file even it was the same content or insignificantly different. If you know when a file has actually changed you can monitor your workflow for errors and avoid costly down-stream estimation. Assuming we can get rid of harmless differences to get "normalized" versions of files (see below) then Scons tracks content changes using hashes like md5.

# Makefile dependency generation
I use gendep/wingendep based for the generation of makefile rules for the code and for LaTeX I use latexmk since LaTeX dependencies in process might be circular. They create .dep files with makefile rules that are hidden. This is controlled by GENDEP_DISABLE.

# Last-run tracking
Sometimes you just want to do something with the last run (e.g. maybe you don't want to commit all changes just from the last estimation). If you are running interactively then you can't just get the list of outputs from the code.dep file. See last-status.sh

# File normalization #
Ideally output files would be the same on different platforms, but this is not always possible. Here are some caveats:

-Logs. The contents of `log/*/` are platform dependent. "Normalized" versions of their content are in the base of log/. The latter files are kept in version control while the former are not.

-Stata: outputs in `data/*.dta` and `fig/gph/*` are normalized in-place to be platform independent. They can be under VC if you would like (you might not want to if the data are big and constantly changing). (I don't know how to normalize Stata eps, and stata can't produce PDF on all platforms).

-R: outputs in `data/*.RData` and `fig/eps/*` are platform independent. They can be under VC if you would like (you might not want to if the data are big and constantly changing). (I don't know how to make the PDFs platform independent).

-It's helpful to have `writeups/*.pdf` under VC (as it saves time checking the history). To do this all the `writeups/*.pdf` and `fig/pdf/*.pdf` are normalized in-place to be consistent for a platform (they don't change with time).

-To do: PNG and SVG normalization