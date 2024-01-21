

for (( i=87; i<=100; i += 1 ))
do
  var=$i
  export var
  vmd -e solutegen.tcl
 done