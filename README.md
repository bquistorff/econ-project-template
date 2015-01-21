# econ-project-template
This is a template to be used in an economics research project (it's geared towards Stata). It is designed to be highly automated and utilizes automatically dependency information between files.

## Usage
Typically, you just use 'make fake1' to ensure code/fake1.do is up to date (only runs if inputs or code are newer than outputs). This will track the dependencies (inputs & outputs) for fake1.do. If somehow the dependencies get messed up you should be able to always do 'make fake1-force' (and you can delete the dependency info stored in code/.fake1.dep if make is complaining about that). To make papers, just use 'make writeups/fake_article.pdf'. It should even go back and run code so that dependencies are up to date.

## Installation
Requirements:

1. PATH must include dep_tracker.sh (from either [gendep](https://github.com/bquistorff/gendep) or [wingendep](https://github.com/bquistorff/wingendep)).

1. STATABATCH assigned to the local batch stata command (e.g. "stata-se -b" or "StataSE-64.exe /e" with those in your path)

1. Ghostscript installed with GSEXE set to find it.

1. If you want to make SVGs: inkscape.

1. Python.

1. Latex with latexmk

1. Windows: Cygwin (with make, and maybe some other utilities).


## Setup details (HW and installed software)
When you instantiate this project make sure to:
*List OS-CPU-software* combinations that have been tested
*List any known limitations (e.g. X doesn't work on Unix)
*List the source of software if not obvious
-e.g. Many other modules from https://raw.githubusercontent.com/bquistorff/Stata-modules/master/
*List what environment variables must be setup:
-see resources/setup-env.bak.sh
*Mention any non-repo resources required (websites or external data)

# Tracking freshness by content not timestamps
For some files that take a while to generate we don't want to regenerate them if harmless modifications have been done to their prerequisites. So files in data/ fig/ tab/ snippets/ are hashed (using md5 check sums) and only when those change will downstream files be remade.
Previous references had not accounted for intermediate files well. Say code1 creates data1 and code2 reads data1. We can make data1.md5 and have that be the actual prerequisite of the code2 rule so that only when it changes will code2 be re-run. But how do we know when to run code1? Code1 may be harmlessly edited so that it is newer than data1.md5. Now asking to update the code2 process will always run code1 process. The condition for updating data1.md5 should be if code1 is newer than data1. Solve this by always "updating md5" which launches a new Make that depends only "data1:code1" which updates the md5.
References:
http://blog.jgc.org/2006/04/rebuilding-when-hash-has-changed-not.html
http://stackoverflow.com/questions/8821319/make-only-build-something-if-the-sources-md5-checksum-was-changed
http://lists.gnu.org/archive/html/bug-make/2009-09/msg00015.html
http://www.kolpackov.net/pipermail/notes/2004-September/000011.html
http://www.cmcrossroads.com/article/rebuilding-when-files-checksum-changes

# Automatic Dependencies
The automatic dependency is different by domain. For statistical code, there are two file tracking systems.

1. Procmon based for the makefile settings

2. in-Stata logging (so that VCS will work if working interactively).
References:
http://make.mad-scientist.net/papers/advanced-auto-dependency-generation/#combine
For LaTeX, I use latexmk since LaTeX dependencies in process might be circular.