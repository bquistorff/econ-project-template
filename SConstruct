# To do:
#  to add: remove_orphan_pdfs, table stuff
# get Help() output nicer
# see https://bitbucket.org/scons/scons/wiki/LyxBuilder
#
# Try out with more dep changes (what if I add/remove an intermediate file).

import os
import sys
import glob
import pprint
import SCons
import inspect
"""
#Load the .env file 
# (for convenience, could -source resources/bin/setup_env.sh- before scons is called)
def load_env_file(string):
	with open(string, 'r') as infile:
		for line in infile:
			parts = line.split(":")
			if line.startswith("#") or len(parts)!=2:
				continue
			os.environ[parts[0]] = parts[1]
			print "adding " + parts[0] + parts[1]

specific_fname = 'resources/.env'
backup_fname = 'resources/.env.example'
if os.path.isfile(specific_fname):
	load_env_file(specific_fname)
else:
	load_env_file(backup_fname)
"""	

update_deps = True
os.environ["PATH"] += os.pathsep + 'resources/bin/'
os.environ["GENDEP_DISABLE"] = "1"
env = Environment(ENV = os.environ)

#https://bitbucket.org/scons/scons/wiki/PhonyTargets
def PhonyTargets(env = None, **kw):
	if not env: env = DefaultEnvironment()
	for target,action in kw.items():
		env.AlwaysBuild(env.Alias(target, [], action))

help_str = """@echo To check if you have everything needed for make, enter:\n
	@echo \ \ Scons configure\n
	@echo Scons thinks in terms of outputs not code files, so commands for a code file are\n
	@echo are converted to make the associated log file.\n
	@echo Scons knows a code file needs to be run if the log is missing or older than the code,\n
	@echo or if the relation between code files has been entered in code/code-manual.dep.\n
	@echo Then, to ensure the outputs of a file and its dependences are current, give the basename:\n
	@echo \ \ Scons data_post_process\n
	@echo If you want to force a rebuild delete the appropriate log/*.log file.\n
	@echo If you just want to force run a single do file, add "-force":
	@echo \ \ Scons data_post_process-force
	@echo If you want to run all \(takes a while, ~30 min currently\), do:\n
	@echo \ \ Scons all-dos\n
	@echo Other generic targets may be listed in code/code-manual.dep:\n
	@echo We do not store in git the generated PDFs, so before you compile the paper, run:\n
	@echo \ \ Scons pdfs_of_gphs\n"""
PhonyTargets(env, myhelp  = help_str)
h = Help(help_str) #so scons -h picks this up
#Default('myhelp')

conf_str = """@echo Checking for Python in your path
	which python
	@echo checking for needed environment variables
	if [ -z "$$STATABATCH" ]; then \
			echo "Need to set STATABATCH environment variable (e.g. \"StataSE-64.exe /e\" on Windows)"; \
			exit 1; \
	fi
	@echo All good"""
PhonyTargets(env, configure  = conf_str)

clean_str="""-cleanup-tests.sh;
	-rm -f temp/* temp/lastrun/*"""
PhonyTargets(env, clean  = clean_str)

env['BUILDERS']['make_do'] = Builder(action = 'bash st_launcher.sh $SOURCE')


updated_dep = False
def build_track_do_fn(target, source, env):
	
	source_code_file = source[0]
	source_code_fname = os.path.basename(str(source_code_file))
	depname = "resources/deps/" + source_code_fname +".dep"
	dep = File(depname)
	orig_sig = dep.get_csig()
	
	rv = os.system('bash st_launcher.sh ' + str(source_code_file))
	if rv: return rv
	
	delattr(dep.get_ninfo() , "csig")
	new_sig = dep.get_csig()
	#print sig1 + " -> " + sig2
	
	if (orig_sig!=new_sig):
		global updated_dep
		updated_dep = True
		print "Dep file updated. Will Re-run"
		
		#The build succeeded but the orig dep file was incorrect.
		# so fix the nodes and store the results.
		# that way we don't have to compile twice.
		buil = target[0].builder
		ex = target[0].get_executor(False)
		oldbatch = ex.batches[0]
		del ex._memo['get_unignored_sources']
		batch = get_batch_from_dep(depname)
		ex.batches = [batch]
		for t in batch.targets:
			t.set_executor(ex)
			t.builder = buil
			delattr(t, "binfo")
			t.get_binfo()
			t.store_info()
		oldsources_str = map(str,oldbatch.sources)
		for s in batch.sources:
			if str(s) not in oldsources_str:
				s.get_binfo()
				s.get_csig()
				s.store_info()
		
		#Don't return an error because we don't want stuff marked as badly built. 
		#This will call the post_job_func and write the .sconsign file
		Exit(0)

		
env['BUILDERS']['track_do'] = Builder(action = build_track_do_fn)

def get_batch_from_dep(name):
	import SCons.Executor
	with open(name, "r") as depfile:
		for line in depfile:
			parts = line.split(":")
			if line.startswith("#") or len(parts)!=2: continue
			ts = map(File, parts[0].split())
			ss = map(File, parts[1].split())
			return SCons.Executor.Batch(ts, ss)
	return None

def tracked_source(name):
	b = get_batch_from_dep("resources/deps/"+name+".dep")
	
	if (update_deps): env.track_do(b.targets, b.sources)
	else:              env.make_do(b.targets, b.sources)
			

tracked_source("fake1.do")
tracked_source("fake2.do")

# Try to auto-rerun
def myatexit():
	global updated_dep
	#os.system("ls -l /proc/self/fd/") #list open files
	
	#from SCons.Script import GetBuildFailures
	#for bf in GetBuildFailures():
	#	print "%s failed: %s" % (bf.node, bf.errstr)

	if (updated_dep):
		print "restarting due to updated dep"
		#response = raw_input("Do you want to restart, [Y/N]")
		#import sys
		#if response=="Y":
		os.execv(sys.executable, [sys.executable] + sys.argv)

import atexit
atexit.register(myatexit)

env['BUILDERS']['make_pdf'] = Builder(action = 'statab.sh do code/cli_gph_fmt.do $SOURCE pdf both')
"""
env['BUILDERS']['statab'] = Builder(action = 'statab.sh do $SOURCE')
env.statab('code/ado/l/ldhaka.mlib', 'code/cli_build_proj_mlib.do')
env['BUILDERS']['st_launcher'] = Builder(action = 'st_launcher.sh $SOURCE')
#Include as a depend when using code that uses the mata files.

#Read the dependency file #
use_gendep = os.environ['GENDEP']
#if use_gendep:
phonies=[]
pseudo_targets = set()
phony_map = dict()
with open("code/code-manual.dep", "r") as manual:
	for line in manual:
		parts = line.split(":")
		if line.startswith("#") or len(parts)!=2:
			continue
			
		if parts[0].strip()==".PHONY":
			phonies = phonies +parts[1].split()
			continue
		
		dvars0 = parts[1].split()
		#Expand the RHS phonies
		dvars0_new = []
		for dvar0 in dvars0:
			if dvar0 in phonies:
				dvars0_new = dvars0_new+phony_map[dvar0]
			else:
				dvars0_new.append(dvar0)
				pseudo_targets.add(dvar0)
		d_vars = map('log/{0}.log'.format, dvars0_new)

		for t in parts[0].split():
			if t in phonies:
				phony_map[t] = dvars0
				continue
			
			pseudo_targets.add(t)
			t_var = 'log/'+t+'.log'
			Depends(t_var, d_vars)

#Aliases
#Have to create the builders for each of the dependencies for aliases
#Since I have outputs in weird directories from inputs, list the targets as files rather than nodes


#First the manual file ones
for ptarget in pseudo_targets:
	env.make_do('log/'+ptarget+'.log', 'code/'+ptarget+'.do')
	env.Alias(ptarget, 'log/'+ptarget+'.log')
	al = env.Alias(ptarget+'-force', [], 'st_launcher.sh code/'+ptarget+'.do')
	env.AlwaysBuild(al)
for p in phonies:
	d_vars = map('log/{0}.log'.format, phony_map[p])
	env.Alias(p, d_vars)

#The raw coded aliases.
pdfs_of_gphs_fnames = []
for gph_src in glob.glob('fig/gph/*.gph'):
	grp_base = os.path.splitext(os.path.basename(gph_src))[0]
	pdf_tgt = 'fig/pdf/'+grp_base+'.pdf'
	pdf_tgt2 = 'fig/pdf/bare/'+grp_base+'_bare.pdf'
	env.make_pdf([pdf_tgt, pdf_tgt2], gph_src)
	pdfs_of_gphs_fnames.append(pdf_tgt)
env.Alias('pdfs_of_gphs', pdfs_of_gphs_fnames)
"""

Decider('MD5-timestamp')
