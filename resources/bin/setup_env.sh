#!/bin/bash
# This brings the .env vars into your shell
# Gets from .env (or .env.example if not)
# Usage:
#$ source resources/bin/setup_env.sh

#Could set the path here given I know BINDIR
# (would make it so that you could source from anywhere).
BINDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
f=${BINDIR}/../.env
if [ ! -f $f ];
then
   f=${BINDIR}/../.env.example
fi
#echo $f
source $f
export $(cat $f | grep -v ^# | cut -d= -f1 | xargs)
