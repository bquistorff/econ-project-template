#! /bin/bash
cp temp/lastrun/$1-files.txt temp/lastrun/files.txt
#Normalize the outputs
cat temp/lastrun/files.txt | grep \.gph | while read p; do
	normalize_gph.py $p;
done

cat temp/lastrun/files.txt | grep \.dta | while read p; do
	normalize_dta.py $p;
done


if  [[ $2 = "do" ]] ; then
	cp log/do/$1.log log/$1.log #do I need this?
	normalize_log.sh -r . log/$1.log
	sed -e 's:do/::g' -i temp/lastrun/files.txt
else
	normalize_log.sh -r . log/$1.log
	sed -e 's:R/::g' -i temp/lastrun/files.txt
fi

