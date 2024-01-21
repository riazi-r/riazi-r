#!/bin/sh
#python3 ./duplicate.py

for (( i=120; i<=130; i += 1 ))
do
 var=$i
 export var
 vmd -e merge.tcl
 #vmd -e solutiongen.tcl
done