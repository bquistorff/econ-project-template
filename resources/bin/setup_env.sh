#!/bin/bash
# This brings the .env vars into your shell
# Gets from .env (or .env.example if not)
# Usage:
#$ source resources/bin/setup_env.sh
BINDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
f=${BINDIR}/../.env
if [ ! -f $f ];
then
   f=${BINDIR}/../.env.example
fi
#echo $f
source $f
export $(cat $f | grep -v ^# | cut -d= -f1 | xargs)
