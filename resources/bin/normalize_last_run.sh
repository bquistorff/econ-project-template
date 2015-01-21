#! /bin/bash
cp temp/lastrun/$1-files.txt temp/lastrun/files.txt
#Normalize the outputs
cat temp/lastrun/files.txt | grep \.gph | while read p; do
	normalize_gph.py $p;
done

cat temp/lastrun/files.txt | grep \.dta | while read p; do
	normalize_dta.py $p;
done

statab.sh do code/cli_smcl_log.do $1
mv cli_smcl_log.log temp/lastrun/
normalize_log.sh -r . log/$1.log
sed -e 's:\.smcl:\.log:g' -e 's:smcl/::g' -i temp/lastrun/files.txt
