# econ-project-template
This is a template to be used in an economics research project (it's geared towards Stata). It is designed to be highly automated and utilizes automatically dependency information between files.


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
The automatic dependency is different from references. There are two file tracking systems.
1) Procmon based for the makefile settings
2) in Stata logging (so that VCS will work if working interactively).
References:
http://make.mad-scientist.net/papers/advanced-auto-dependency-generation/#combine

## Execution commands
-make ...