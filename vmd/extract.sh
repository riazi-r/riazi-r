#!/bin/sh
#python3 ./duplicate.py

for i in 1
do
 var=$i
 export var
 #cp extract.tcl ./10_$i
 cd 10_$i

 tclsh ../extract.tcl
 cd .. 
 
done